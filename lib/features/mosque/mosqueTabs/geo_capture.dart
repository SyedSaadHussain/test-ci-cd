// lib/screens/mosque/mosqueTabs/geo_capture.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/location_picker_page.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/gps_permission.dart';
import '../../../shared/widgets/app_form_field.dart';
import '../core/models/mosque_local.dart';
import '../createMosque/form/create_mosque_view_model.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';

class GeoCaptureSection extends StatefulWidget {
  final MosqueLocal local;
  final bool editing;


  const GeoCaptureSection({
    super.key,
    required this.local,
    required this.editing,
  });

  @override
  State<GeoCaptureSection> createState() => _GeoCaptureSectionState();
}

class _GeoCaptureSectionState extends State<GeoCaptureSection> {
  static const _timeout = Duration(seconds: 12);


  GPSPermission? _perm;
  bool _busy = false;
  double? _initialLat; // [ADDED]
  double? _initialLng; // [ADDED]
  bool _seededInitial = false; // [ADDED]


  double? _payloadLat() {
    final v = widget.local.payload?['latitude'];
    if (v is num) return v.toDouble();
    return double.tryParse('$v');
  }

  double? _payloadLng() {
    final v = widget.local.payload?['longitude'];
    if (v is num) return v.toDouble();
    return double.tryParse('$v');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // [ADDED] seed initial values once from LocalView (API/model wins)
    if (!_seededInitial) {
      //final view = localViewOf(context, widget.local);
      _initialLat =  widget.local.latitude ?? _payloadLat();
      _initialLng =  widget.local.longitude ?? _payloadLng();
      _seededInitial = true;
    }
  }

  double? get _lat {
    final v = widget.local.payload?['latitude'];
    print("latitude:$v");
    if (v is num) return v.toDouble();
    return double.tryParse('$v');
  }

  double? get _lng {
    final v = widget.local.payload?['longitude'];
    if (v is num) return v.toDouble();
    return double.tryParse('$v');
  }

  Future<void> _getCoords() async {
    if (!widget.editing) {
      _toast('Tap Edit first to enable changes'.tr());
      return;
    }
    if (_busy) return;
    setState(() => _busy = true);
    bool got = false;
    // 1) GPS-only (offline friendly)
    got = await _tryHelperOnce(isOnlyGps: true);
    // 2) Fused (retry)
    if (!got) {
      debugPrint('[Geo] GPS-only failed; retrying with fused provider…');
      got = await _tryHelperOnce(isOnlyGps: false);
    }
    // 3) Direct Geolocator (then last-known)
    if (!got) {
      debugPrint('[Geo] Helper failed. Trying direct Geolocator…');
      got = await _fallbackGeolocatorFetch();
    }
    if (!got) {
      // Show one final failure message
      _toast(_statusMessage() ?? 'Failed to get location'.tr(), replace: true);
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<bool> _tryHelperOnce({required bool isOnlyGps}) async {
    _perm = GPSPermission(
      allowDistance: 0,
      latitude: 0,
      longitude: 0,
      isOnlyGPS: isOnlyGps,
    );
    debugPrint('[Geo] checkPermission() (isOnlyGPS=$isOnlyGps)');
    _perm!.checkPermission();
    try {
      // NOTE: helper stream is spelled `.listner`
      final ok = await _perm!.listner.first.timeout(_timeout, onTimeout: () {
        debugPrint('[Geo] listener timeout after $_timeout');
        return false;
      });
      final pos = _perm!.currentPosition;
      debugPrint('[Geo] listener returned ok=$ok, pos=$pos');
      if (ok && pos != null) {
        _setLatLng(pos.latitude, pos.longitude);
        _toast('Coordinates updated'.tr(), replace: true); // success replaces any prior snack
        return true;
      }
    } catch (e, st) {
      debugPrint('[Geo] error while waiting for location: $e\n$st');
    }
    // No failure toast here — we’ll show a single final message in _getCoords()
    return false;
  }

  Future<bool> _fallbackGeolocatorFetch() async {
    // Ensure service + permission
    final serviceOn = await Geolocator.isLocationServiceEnabled();
    if (!serviceOn) {
      return false;
    }
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return false;
    }
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: 25),

      );
      _setLatLng(pos.latitude, pos.longitude);
      _toast('Coordinates updated'.tr(), replace: true);
      return true;
    } catch (e) {
      debugPrint('[Geo] getCurrentPosition failed: $e');
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        _setLatLng(last.latitude, last.longitude);
        _toast('Used last known location'.tr(), replace: true);
        return true;
      }
    }
    return false;
  }

  void _setLatLng(double lat, double lng) {
    final lat6 = double.parse(lat.toStringAsFixed(6));
    final lng6 = double.parse(lng.toStringAsFixed(6));

    widget.local.latitude=lat;
    widget.local.longitude=lng;

    vm.notifyListeners();

    // widget.updateLocal((m) {
    //   m.payload ??= <String, dynamic>{};
    //   m.payload!['latitude']  = lat6;
    //   m.payload!['longitude'] = lng6;
    //   m.latitude  = lat6;
    //   m.longitude = lng6;
    //   m.updatedAt = DateTime.now();
    // });
    setState(() {}); // [ADDED] repaint to show new values immediately
  }

  void _toast(String msg, {bool replace = false}) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (replace) messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(msg)));
  }

  String? _statusMessage() {
    final s = _perm?.status?.toString() ?? '';
    if (s.contains('locationDisabled')) return 'Turn on Location (device/emulator)'.tr();
    if (s.contains('permissionDeniedForever')) return 'Location denied forever — enable in Settings'.tr();
    if (s.contains('permissionDenied')) return 'Location permission denied — allow it in Settings'.tr();
    if (s.contains('failFetchCoordinate')) {
      return 'No GPS fix — set a location in the emulator or use: adb emu geo fix <lon> <lat>'.tr();
    }
    return null;
  }
  late CreateMosqueBaseViewModel vm;

  @override
  Widget build(BuildContext context) {
     vm = context.read<CreateMosqueBaseViewModel>();


    //final view = localViewOf(context, widget.local);
    final lat =  vm.mosqueObj.latitude ?? _payloadLat();
    final lng =  vm.mosqueObj.longitude ?? _payloadLng();

    final latText = lat == null ? '' : lat.toStringAsFixed(6);
    final lngText = lng == null ? '' : lng.toStringAsFixed(6);



    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInputField(
          title: 'latitude'.tr(),
          value: widget.local.latitude,
          isRequired: true,
          isReadonly: true,
        ),
        const SizedBox(height: 10),
        AppInputField(
          title: 'longitude'.tr(),
          value: widget.local.longitude,
          isRequired: true,
          isReadonly: true,
        ),
        const SizedBox(height: 10),


        // capture + manage row
        Row( // [ADDED]
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: (!widget.editing || _busy) ? null : _getCoords,
                icon: _busy
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.my_location),
                label: Text(_busy ? 'Fetching…'.tr() : 'Get location'.tr()),
              ),
            ),
            const SizedBox(width: 8),
             ],
        ),
      ],
    );
  }
}