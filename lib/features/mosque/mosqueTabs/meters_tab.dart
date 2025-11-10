import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/utils/app_regix_validation.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:provider/provider.dart';
import '../../../core/models/combo_list.dart';
import '../core/models/mosque_local.dart';
// App controls
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import '../../../shared/widgets/form_controls/app_attachment_field.dart';
import 'logic/image_help_dialog.dart';

class MetersTab extends StatefulWidget {
  final MosqueLocal local;
  final bool editing;

  const MetersTab({
    super.key,
    required this.local,
    required this.editing,
  });

  @override
  State<MetersTab> createState() => _MetersTabState();
}

class _MetersTabState extends State<MetersTab> {
  // ---------- API list keys (align with server) ----------
  static const String kElectric = 'meter_ids';
  static const String kWater   = 'water_meter_ids';

  // ---------- row field keys (align with server) ----------
  static const String rNumber     = 'meter_number';
  static const String rAttachId   = 'attachment_id'; // base64 / file id
  static const String rNew        = 'meter_new';     // bool
  static const String rImam       = 'imam';          // bool (electric use-case)
  static const String rMuezzin    = 'muezzin';       // bool (water use-case)
  static const String rMosque     = 'mosque';        // bool
  static const String rFacility   = 'facility';      // bool

  final Map<String, GlobalKey<FormFieldState<bool>>> _sectionValKeys = {
    kElectric: GlobalKey<FormFieldState<bool>>(),
    kWater: GlobalKey<FormFieldState<bool>>(),
  };

  // ---------- helpers ----------
  bool _boolFrom(dynamic v) {
    if (v is bool) return v;
    final s = (v ?? '').toString().toLowerCase().trim();
    return s == 'yes' || s == 'true' || s == '1';
  }

  bool _anyTrue(Map<String,dynamic> row, List<String> keys) =>
      keys.any((k) => _boolFrom(row[k]));

  /// Read a list from payload. Supports legacy keys & field names, normalizes on the fly.
  List<Map<String, dynamic>> _getList(String apiKey) {
    // primary key (API-aligned)
    dynamic raw = widget.local.payload?[apiKey];

    // legacy fallback (if someone saved older structure)
    if (raw == null && apiKey == kElectric) raw = widget.local.payload?['electric_meters'];
    if (raw == null && apiKey == kWater)   raw = widget.local.payload?['water_meters'];

    if (raw is! List) return <Map<String, dynamic>>[];

    // normalize each row to API keys & types
    return raw.map<Map<String, dynamic>>((e) {
      final m = Map<String, dynamic>.from(e as Map);

      // rename legacy fields to API names
      if (m.containsKey('is_meter_new')) {
        m[rNew] = _boolFrom(m.remove('is_meter_new'));
      } else {
        m[rNew] = _boolFrom(m[rNew]);
      }
      if (m.containsKey('attachment')) {
        m[rAttachId] = m.remove('attachment');
      }

      // ensure all boolean flags are true booleans
      for (final k in [rImam, rMuezzin, rMosque, rFacility]) {
        m[k] = _boolFrom(m[k]);
      }

      // cast number/attach to strings
      m[rNumber]   = (m[rNumber] ?? '').toString();
      m[rAttachId] = (m[rAttachId] ?? '').toString();

      return m;
    }).toList();
  }

  void _saveList(String key, List<Map<String, dynamic>> rows) {
    if(vm.mosqueObj.payload==null)
      vm.mosqueObj.payload= {};

    vm.mosqueObj.payload![key]=rows;
    vm.notifyListeners();
    // widget.updateLocal((m) {
    //   (m.payload ??= {})[key] = rows;
    //   // optionally purge old legacy keys so payload stays clean:
    //   (m.payload!)..remove('electric_meters')..remove('water_meters');
    //   m.updatedAt = DateTime.now();
    //
    // });
    // setState(() {});
  }

  void _addLine(String listKey, {required bool isElectric}) {

    final rows = _getList(listKey);
    rows.add({
      rNumber: '', rAttachId: '', rNew: false,
      rImam: false, rMuezzin: false, rMosque: false, rFacility: false,
    });
    _saveList(listKey, rows);

    // re-validate to show fresh “required” markers
    Future.microtask(() {
      Form.of(context)?.validate();
      _sectionValKeys[listKey]?.currentState?.validate(); // FIX: revalidate section
    });
  }

  void _removeLine(String listKey, int index) {
    final rows = _getList(listKey);
    if (index >= 0 && index < rows.length) {
      rows.removeAt(index);
      _saveList(listKey, rows);
      Future.microtask(() {
        Form.of(context)?.validate();
        _sectionValKeys[listKey]?.currentState?.validate(); // FIX: revalidate section
      });
    }
  }



  void _updateField(String listKey, int index, String field, dynamic value) {
    final rows = _getList(listKey);
    if (index >= 0 && index < rows.length) {
      rows[index][field] = value;
      _saveList(listKey, rows);
    }
  }

  // ---------- compact checkbox tile ----------
  Widget _checkTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return CheckboxListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      value: value,
      onChanged: widget.editing ? (b) {
        onChanged(b ?? false);
        // keep legacy_forms validation up-to-date with the toggle
        Future.microtask(() => Form.of(context)?.validate());
      } : null,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _section({
    required String title,
    required String listKey,
    required bool isElectric,
  }) {
    final rows = _getList(listKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 8),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),

        for (int i = 0; i < rows.length; i++) ...[
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Meter Number | Delete ─────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // METER NUMBER (MANDATORY; regex only for electric+new)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppInputField(
                              title: 'meter_number_label'.tr(),
                              value: rows[i][rNumber] as String,
                              isDisable: !widget.editing,
                              denyRegex: AppRegexValidation.noSpaces,
                              isRequired: true, // ← mandatory per row
                              validationRegex: (isElectric && rows[i][rNew] == true)
                                  ? RegExp(r'^[A-Za-z]{3}[0-9]{13}$')
                                  : null,
                              validationError: null, // Disable built-in error to use custom one
                              onChanged: widget.editing
                                  ? (v) => _updateField(listKey, i, rNumber, (v ?? '').toString())
                                  : null,
                            ),
                            // Custom error message with full width and proper wrapping
                            if (isElectric && rows[i][rNew] == true && 
                                (rows[i][rNumber] as String).isNotEmpty &&
                                !RegExp(r'^[A-Za-z]{3}[0-9]{13}$').hasMatch(rows[i][rNumber] as String))
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'new_electric_meter_validation_error'.tr(),
                                  style: const TextStyle(
                                    color: Colors.red, 
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                          ],
                        ),
                      ),

                      if (widget.editing) ...[
                        const SizedBox(width: 6),
                        IconButton(
                          onPressed: () => _removeLine(listKey, i),
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'remove_button_tooltip'.tr(),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

                  // ATTACHMENT (MANDATORY)
                  SizedBox(
                    width: double.infinity,
                    child: FormField<String>(
                      validator: (_) {
                        final empty = ((rows[i][rAttachId] ?? '') as String).trim().isEmpty;
                        return empty ? 'attachment_is_required'.tr() : null;
                      },
                      builder: (ff) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Custom title row with help icon (only for electric meters)
                          if (isElectric)
                            ImageHelpDialog.fieldTitleRow(
                              title: 'attachment_label'.tr(),
                              onHelpTap: () => ImageHelpDialog.showMeterImageHelp(context),
                              isRequired: true,
                            )
                          else
                            Row(
                              children: [
                                Text(
                                  'attachment_label'.tr(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '*',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 8),
                          AppAttachmentField(
                            title: '', // Empty title since we're using custom title above
                            value: (rows[i][rAttachId] ?? '') as String,
                            isRequired: true,
                            isMemory: true,
                            onChanged: widget.editing
                                ? (val) {
                              final v = (val is String)
                                  ? val
                                  : (val is Map && val['id'] is String)
                                  ? val['id'] as String
                                  : (val ?? '').toString();
                              _updateField(listKey, i, rAttachId, v);
                              Future.microtask(() {
                                ff.validate();
                                _sectionValKeys[listKey]?.currentState?.validate(); // FIX
                              });
                            }
                                : null,
                          ),
                          if (ff.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(ff.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // IS METER NEW
                  _checkTile(
                    title: 'is_meter_new_label'.tr(),
                    value: (rows[i][rNew] == true),
                    onChanged: (b) => _updateField(listKey, i, rNew, b),
                  ),

                  const SizedBox(height: 4),

                  // ── Per-row roles validator (at least one) ──────────────────
                  FormField<bool>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (_) {
                      final imam     = rows[i][rImam]     == true;
                      final mosque   = rows[i][rMosque]   == true;
                      final muezzin  = rows[i][rMuezzin]  == true;
                      final facility = rows[i][rFacility] == true;
                      final hasAny = imam || mosque || muezzin || facility;
                      return hasAny ? null : 'select_at_least_one_role_for_this_meter'.tr();
                    },
                    builder: (rowFF) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 4.6,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 12,
                          children: [
                            _checkTile(
                              title: 'imam_label'.tr(),
                              value: _boolFrom(rows[i][rImam]),
                              onChanged: (b) {
                                _updateField(listKey, i, rImam, b);
                                rowFF.didChange(b);
                                _sectionValKeys[listKey]?.currentState?.validate(); // FIX
                              },
                            ),
                            _checkTile(
                              title: 'muezzin_label'.tr(),
                              value: _boolFrom(rows[i][rMuezzin]),
                              onChanged: (b) {
                                _updateField(listKey, i, rMuezzin, b);
                                rowFF.didChange(b);
                                _sectionValKeys[listKey]?.currentState?.validate(); // FIX
                              },
                            ),
                            _checkTile(
                              title: 'mosque_label'.tr(),
                              value: _boolFrom(rows[i][rMosque]),
                              onChanged: (b) {
                                _updateField(listKey, i, rMosque, b);
                                rowFF.didChange(b);
                                _sectionValKeys[listKey]?.currentState?.validate(); // FIX
                              },
                            ),
                            _checkTile(
                              title: 'facility_label'.tr(),
                              value: _boolFrom(rows[i][rFacility]),
                              onChanged: (b) {
                                _updateField(listKey, i, rFacility, b);
                                rowFF.didChange(b);
                                _sectionValKeys[listKey]?.currentState?.validate(); // FIX
                              },
                            ),
                          ],
                        ),

                        if (rowFF.hasError)
                          Padding(
                            padding: const EdgeInsetsDirectional.only(top: 6, start: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, size: 14, color: Colors.red),
                                const SizedBox(width: 6),
                                Flexible(child: Text(rowFF.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12))),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        // ── Section-level validator: “some row has Mosque” (both sections) ──
        FormField<bool>(
          key: _sectionValKeys[listKey],
          validator: (_) {
            if (rows.isEmpty) return null; // or enforce at least one row if needed
            final hasMosqueSomewhere = rows.any((r) => r[rMosque] == true);
            if (hasMosqueSomewhere) return null;
            // Use your i18n keys; replace if you already have specific ones.
            return isElectric
                ? 'electric_require_mosque'.tr()
                : 'water_require_mosque'.tr(); // FIX: require Mosque for water, per your latest rule
          },
          builder: (ff) => ff.hasError
              ? Padding(
            padding: const EdgeInsetsDirectional.only(top: 4, start: 4),
            child: Row(
              children: [
                const Icon(Icons.error_outline, size: 14, color: Colors.red),
                const SizedBox(width: 6),
                Flexible(child: Text(ff.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12))),
              ],
            ),
          )
              : const SizedBox.shrink(),
        ),

        if (widget.editing)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _addLine(listKey, isElectric: isElectric),
              icon: const Icon(Icons.add),
              label: Text('add_a_line'.tr()),
            ),
          ),
      ],
    );
  }


  late CreateMosqueBaseViewModel vm;
  @override
  Widget build(BuildContext context) {
    vm = context.watch<CreateMosqueBaseViewModel>();
    // NOTE: Place MetersTab inside the same <Form key=_formDetailKey> that wraps TabBarView
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
        _section(
          title: 'electric_meter_title'.tr(),
          listKey: kElectric,
          isElectric: true,
        ),
        const SizedBox(height: 12),
        _section(
          title: 'water_meter_title'.tr(),
          listKey: kWater,
          isElectric: false,
        ),
          ],
        ),
      ),
    );
  }
}

/// Shows an inline requirement error if role selection is invalid.
/// Electric: require Imam OR Mosque
/// Water:   require Muezzin OR Facility
class _RoleRequirementHint extends StatelessWidget {
  final bool isElectric;
  final Map<String, dynamic> row;
  const _RoleRequirementHint({
    required this.isElectric,
    required this.row,
  });

  @override
  Widget build(BuildContext context) {
    final imam     = row[_MetersTabState.rImam]    == true;
    final mosque   = row[_MetersTabState.rMosque]  == true;
    final muezzin  = row[_MetersTabState.rMuezzin] == true;
    final facility = row[_MetersTabState.rFacility]== true;

    final ok = isElectric ? (imam || mosque) : (muezzin || facility);
    if (ok) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 14, color: Colors.red),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              isElectric
                  ? 'select_at_least_one_imam_or_mosque'.tr()
                  : 'select_at_least_one_muezzin_or_facility'.tr(),
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}