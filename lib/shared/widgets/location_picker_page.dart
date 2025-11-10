import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class OsmLocationPicker extends StatefulWidget {
  final LatLng? location;

  // Add a constructor parameter
  const OsmLocationPicker({Key? key, this.location}) : super(key: key);

  @override
  State<OsmLocationPicker> createState() => _OsmLocationPickerState();
}
class _OsmLocationPickerState extends State<OsmLocationPicker> {
  final MapController _mapController = MapController();
  LatLng? _selectedLatLng; // Default Riyadh

  @override
  void initState() {
    super.initState();
    _selectedLatLng=widget.location!;
    // _setCurrentLocation();
  }
  @override
  void didUpdateWidget(covariant OsmLocationPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.location != oldWidget.location && widget.location != null) {
      _selectedLatLng = widget.location!;

      // Move map to new location
      _mapController.move(_selectedLatLng!, 18); // 18 is zoom level
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return _selectedLatLng==null?Container():Container(
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // same as container
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _selectedLatLng!,
            initialZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate:
              'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 50,
                  height: 50,
                  point: _selectedLatLng!,
                  child:  Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}