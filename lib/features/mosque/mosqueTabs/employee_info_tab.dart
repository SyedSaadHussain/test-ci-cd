import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/features/mosque/core/models/employee_local.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:hijri/hijri_calendar.dart';               // for Gregorian -> Hijri
import 'package:mosque_management_system/data/services/yakeen_service.dart';
import 'package:mosque_management_system/core/models/date_conversion.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';

// App controls
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/modal_sheet/show_item_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../core/viewmodel/create_mosque_base_view_model.dart';

class EmployeeInfoTab extends StatefulWidget {
  final MosqueLocal local;
  final bool editing;
  final FieldListData fields;

  /// Hook later; should return: {'full_name_ar':..., 'full_name_en': ...}
  final Future<Map<String, String>?> Function({
  required String nationalId,
  required DateTime dateOfBirth,
  })? onVerifyYaqeen;

  const EmployeeInfoTab({
    super.key,
    required this.local,
    required this.editing,
    required this.fields,
    this.onVerifyYaqeen,
  });

  @override
  State<EmployeeInfoTab> createState() => _EmployeeInfoTabState();
}

class _EmployeeInfoTabState extends State<EmployeeInfoTab> {
  // Hive helper (opens lazily)
  final _emp = HiveRegistry.employee;

  // role options from assets/json/category_id.json
  List<ComboItem> _roleOptions = const [];

  // cached list reload
  late Future<List<EmployeeLocal>> _listF;

  @override
  void initState() {
    super.initState();
    _reload();
    _loadRoleOptions();
  }

  void _reload() {
    _listF = _emp.getAll();
  }

  Future<void> _loadRoleOptions() async {
    try {
      final s = await rootBundle.loadString(
          'assets/data/mosque/category_id.json');
      final List js = jsonDecode(s) as List;
      setState(() {
        _roleOptions = js
            .map((e) => ComboItem(key: '${e['id']}', value: '${e['name']}'))
            .toList();
      });
    } catch (e) {
      debugPrint('⚠️ role options from asset failed: $e');
      setState(() {
        _roleOptions = widget.fields.getComboList('category_ids') ?? const [];
      });
    }
  }

  String _label(String key, String fallback) {
    final f = widget.fields.getField(key);
    final lbl = f?.label;
    return (lbl == null || lbl
        .trim()
        .isEmpty) ? fallback.tr() : lbl.tr();
  }

  String _roleName(int id) {
    final fallback = {
      8: 'imam'.tr(),
      9: 'muezzin'.tr(),
      // 10: 'khatib'.tr(), // kept for reference; disabled per requirements
      11: 'khadem'.tr()

    }[id] ?? 'Role $id';
    final found = _roleOptions.firstWhere(
          (c) => (c.key ?? '').toString() == id.toString(),
      orElse: () => ComboItem(key: '$id', value: fallback),
    );
    return found.value ?? fallback;
  }

  Future<void> _syncIsEmployeeFlag() async {
    final all = await _emp.getAll();
    final hasAny = all.any((e) => e.parentLocalId == widget.local.localId);

    debugPrint('🔁 sync is_employee => ${hasAny ? 'yes' : 'no'}');
  }

  Future<void> _addOrEdit(
      {EmployeeLocal? existing, int? preselectRoleId}) async {
    if (!widget.editing) return;

    final res = await showModalBottomSheet<EmployeeLocal>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          _EmployeeEditorSheet(
            parentLocalId: widget.local.localId,
            roleOptions: _roleOptions,
            staffRelationOptions:
            widget.fields.getComboList('staff_relation_type') ?? const [],
            existing: existing,
            preselectRoleId: preselectRoleId,
            onVerifyYaqeen: widget.onVerifyYaqeen,
            fields: widget.fields,
            cityId: widget.local.cityId,
          ),
    );
    if (res == null) return;

    await _emp.put(res.localId, res);
    await _syncIsEmployeeFlag();
    _reload();
    if (mounted) setState(() {});
    debugPrint('💾 saved ${res.localId} (${res.categoryIds})');
  }

  Future<void> _delete(String id) async {
    await _emp.delete(id);
    await _syncIsEmployeeFlag();
    _reload();
    if (mounted) setState(() {});
    debugPrint('🗑️ deleted $id');
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateMosqueBaseViewModel>();
    //final isEmp = (widget.local.payload?['is_employee'] ?? 'no').toString();
    final isEmp = widget.local.payload?['is_employee']?.toString();

    return FutureBuilder<List<EmployeeLocal>>(
      future: _listF,
      builder: (ctx, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final all = snap.data!;
        final list = all.where((e) => e.parentLocalId == widget.local.localId)
            .toList();
        final imams = list.where((e) => e.categoryIds.contains(8)).toList();
        final muezzin = list.where((e) => e.categoryIds.contains(9)).toList();
        // final khatib = list.where((e) => e.categoryIds.contains(10)).toList(); // kept for reference
        final khadem = list.where((e) => e.categoryIds.contains(11)).toList();

        debugPrint(' by role: imam=${imams.length}, muezzin=${muezzin.length}, khadem=${khadem.length}');
        // debugPrint(' by role: imam=${imams.length}, muezzin=${muezzin.length}, khatib=${khatib.length}, khadem=${khadem.length}');

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
            // Is Employee (radio)
            AppSelectionField(
              title: vm.fields.getField('is_employee').label,
              //title: 'is_employee'.tr(),
              value: vm.mosqueObj.isEmployee,
              type: SingleSelectionFieldType.radio,
              options: widget.fields.getComboList('is_employee'),
              isRequired: true,
              isReadonly: !widget.editing,
              isDisable: !widget.editing,
              onChanged: widget.editing
                  ? (v) async {
                final sv = (v ?? '').toString();
                debugPrint(' is_employee changed => $sv');
                vm.mosqueObj.isEmployee=v;
                if (sv == 'no') {
                  final allEmployees = await _emp.getAll();
                  final mosqueEmployees = allEmployees
                      .where((e) => e.parentLocalId == widget.local.localId)
                      .toList();

                  for (final emp in mosqueEmployees) {
                    await _emp.delete(emp.localId);
                  }
                  _reload(); // Reload the list from Hive
                }
                vm.notifyListeners();

                // widget.updateLocal((m) {
                //   (m.payload ??= {})['is_employee'] = sv;
                //   m.updatedAt = DateTime.now();
                // });
                setState(() {});
              }
                  : null,
            ),
            const SizedBox(height: 12),

            // Hide everything else if user selected "no"
            if (vm.mosqueObj.isEmployee != 'yes')
              Padding(
                padding: const EdgeInsets.only(top: 8),
                //child: Text('No employees to manage.', style: Theme.of(context).textTheme.bodySmall),
                child: Text('No employees to manage.'.tr(), style: Theme.of(context).textTheme.bodySmall),
              )
            else
              ...[
                // if (list.isEmpty)
                //   Padding(
                //     padding: const EdgeInsets.only(bottom: 8),
                //     child: Row(
                //       children: const [
                //         Icon(Icons.error_outline, size: 16, color: Colors.red),
                //         SizedBox(width: 6),
                //         Expanded(
                //           child: Text(
                //             'Please add at least one employee (Imam/Muezzin/Khatib/Khadem).',
                //             style: TextStyle(color: Colors.red, fontSize: 12),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                if(list.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, size: 16, color: Colors.red),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Please add at least one employee (Imam/Muezzin/Khadem).'.tr(),
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                _roleHeader(title: _roleName(8),
                    count: imams.length,
                    onAdd: () => _addOrEdit(preselectRoleId: 8)),
                ...imams.map(_empTile),

                _roleHeader(title: _roleName(9),
                    count: muezzin.length,
                    onAdd: () => _addOrEdit(preselectRoleId: 9)),
                ...muezzin.map(_empTile),

                // _roleHeader(title: _roleName(10),
                //     count: khatib.length,
                //     onAdd: () => _addOrEdit(preselectRoleId: 10)),
                // ...khatib.map(_empTile),


                _roleHeader(title: _roleName(11),
                    count: khadem.length,
                    onAdd: () => _addOrEdit(preselectRoleId: 11)),
                ...khadem.map(_empTile),
                FormField<int>(
                    validator: (value) {
                      // Note: Khatib (category 10) is excluded by requirements.
                      // Only Imam, Muezzin, and Khadem are considered here.
                      if (imams.isEmpty && muezzin.isEmpty && khadem.isEmpty) {
                        return 'Please create at least one employee'.tr();
                      }
                      return null;
                    },
                    builder: (FormFieldState<int> field) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                field.errorText ?? '',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      );
                    }
                )
              ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _roleHeader({
    required String title,
    required int count,
    required VoidCallback onAdd,
    bool showAdd = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text('$title ($count)', style: Theme
              .of(context)
              .textTheme
              .titleMedium)),
          if (widget.editing && showAdd)
            IconButton(
                onPressed: onAdd, icon: const Icon(Icons.add), tooltip: 'Add'.tr()),
        ],
      ),
    );
  }

  Widget _empTile(EmployeeLocal e) {
    final subtitle = [
      if ((e.identificationId ?? '').isNotEmpty) 'ID: ${e.identificationId}'.tr(),
      if ((e.workPhone ?? '').isNotEmpty) 'Phone: ${e.workPhone}'.tr(),
      if ((e.staffRelationType ?? '').isNotEmpty) e.staffRelationType!.tr(),
    ].join(' · ');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Row(
          children: [
            Expanded(child: Text(
                (e.nameAr?.isNotEmpty ?? false) ? e.nameAr! : (e.nameEn ??
                    '—'))),
            // [YAKEEN] NEW
            if (e.yakeenVerified)
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Icon(Icons.verified, size: 16, color: Colors.green),
              )
            else
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Icon(
                    Icons.privacy_tip_outlined, size: 16, color: Colors.orange),
              ),
          ],
        ),
        subtitle: subtitle.isEmpty ? null : Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.editing)
              IconButton(icon: const Icon(Icons.edit),
                  onPressed: () => _addOrEdit(existing: e)),
            if (widget.editing)
              IconButton(icon: const Icon(Icons.delete_outline),
                  onPressed: () => _delete(e.localId)),
          ],
        ),
      ),
    );
  }

}

/* ----------------------- Editor bottom-sheet ----------------------- */

class _EmployeeEditorSheet extends StatefulWidget {
  final String parentLocalId;
  final List<ComboItem> roleOptions;            // 8/9/10/11
  final List<ComboItem> staffRelationOptions;   // from FieldListData
  final EmployeeLocal? existing;
  final int? preselectRoleId;
  final FieldListData fields;
  final Future<Map<String, String>?> Function({
  required String nationalId,
  required DateTime dateOfBirth,
  })? onVerifyYaqeen;
  final int? cityId;

  const _EmployeeEditorSheet({
    required this.parentLocalId,
    required this.roleOptions,
    required this.staffRelationOptions,
    required this.fields,
    this.existing,
    this.preselectRoleId,
    this.onVerifyYaqeen,
    this.cityId,
  });

  @override
  State<_EmployeeEditorSheet> createState() => _EmployeeEditorSheetState();
}

class _EmployeeEditorSheetState extends State<_EmployeeEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  String? _dobGreg;     // yyyy-MM-dd shown in the control and saved to Hive
  String? _dobHijriYM;
  List<ComboItem> _staffOpts = const [];
  // Loaded from assets for dependent selectors
  List<Map<String, dynamic>> _jobFamilies = const [];
  List<Map<String, dynamic>> _jobPositions = const [];
  Key _nameArKey = UniqueKey();
  Key _nameEnKey = UniqueKey();

  // keep phone rule
  final _rePhone = RegExp(r'^966\d{9}$');
  // simple NID rule (ASCII digits only)
  final _reNID   = RegExp(r'^\d{10}$');

  // model fields
  late String _localId;
  late String _parentId;
  List<int>   _categoryIds = <int>[8];
  String?     _nameAr;
  String?     _nameEn;

  // 👇 CHANGED: date-only string (yyyy-MM-dd)
  //String?     _birthdayStr;

  String? _nid;
  String? _relType;
  int? _jobFamilyId;
  int? _jobPositionId;
  int? _jobNumberId;                    // selected job number id
  String? _jobNumberName;                    // selected job number id
  List<ComboItem> _jobNumberOptions = const [];
  bool _jobNumberLoading = false;

  // Yakeen-derived extras
  String? _statusDescAr;
  String? _occupationCode;
  String? _preSamisIssueDate;  // yyyy-MM-dd or ISO
  String? _idExpired;          // yyyy-MM-dd or ISO
  String? _cityOfBirth;
  String? _gender;             // 'male' | 'female' | raw
  String? _hijriBirthday;      // from Yakeen convertDate.dateString

  // ----- Small helpers to avoid repetition -----
  bool _hasJobIdPrereqs() {
    return widget.cityId != null && (_relType ?? '').isNotEmpty && _jobFamilyId != null && _jobPositionId != null;
  }

  void _clearJobId({bool setLoading = false}) {
    _jobNumberId = null;
    _jobNumberName = null;
    _jobNumberOptions = const [];
    if (setLoading) _jobNumberLoading = true;
  }

  void _onRelationChangedInternal(String? v) {
    setState(() {
      _relType = (v ?? '').toString();
      _jobFamilyId = null;

    });
    setState(() {

      _relWarn = false;
      _jobFamilyId = null;
      _jobPositionId = null;
      _clearJobId(setLoading: true);
    });
    // if (_hasJobIdPrereqs()) _fetchJobNumbers();
    // Wait a short moment so the UI can rebuild before continuing
    Future.delayed(const Duration(milliseconds: 100), () {

    });

  }

  void _onFamilyChangedInternal(int? v) {
    final id = int.tryParse((v ?? '').toString());
    setState(() {
      _jobFamilyId = id;
      _jobPositionId = null;
      _clearJobId(setLoading: true);
    });
    // if (_hasJobIdPrereqs()) _fetchJobNumbers();
  }

  void _onPositionChangedInternal(int? v) {
    final id = int.tryParse((v ?? '').toString());
    setState(() {
      _jobPositionId = id;
      _clearJobId(setLoading: true);
    });
    // if (_hasJobIdPrereqs()) _fetchJobNumbers();
  }
  String? _email;
  String? _phone;
  bool _verified = false;

  // local error flags
  bool _roleWarn = false;
  bool _relWarn = false;
  bool _dobWarn = false;

  // keep these with your other fields
  bool _verifying = false;

  // String? _dobGreg;   // yyyy-MM-dd (Gregorian)
  // String? _dobHijri;  // yyyy-MM-dd (Hijri)

  // Utility: fmt a DateTime to yyyy-MM-dd
  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';

  // simple G->H using hijri_calendar
  String _gregorianToHijriYMD(String ymd) {
    final p = ymd.split('-');
    final g = DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
    final h = HijriCalendar.fromDate(g);
    return '${h.hYear.toString().padLeft(4, '0')}-'
        '${h.hMonth.toString().padLeft(2, '0')}-'
        '${h.hDay.toString().padLeft(2, '0')}';
  }

  /// Convert a Gregorian yyyy-MM-dd to Hijri yyyy-MM (for Yakeen)
  String _gregorianToHijriYM(String ymd) {
    final p = ymd.split('-');
    final g = DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
    final h = HijriCalendar.fromDate(g);
    final ym = '${h.hYear.toString().padLeft(4, '0')}-${h.hMonth.toString().padLeft(2, '0')}';
    return ym;
  }

  /// Normalize *any* Hijri string we captured to yyyy-MM (Yakeen format)
  String _hijriToYM(String s) {
    // If already yyyy-MM
    final m0 = RegExp(r'^(\d{4})-(\d{2})$').firstMatch(s);
    if (m0 != null) return m0.group(0)!;

    // If yyyy-MM-dd  -> yyyy-MM
    final m1 = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(s);
    if (m1 != null) return '${m1.group(1)}-${m1.group(2)}';

    // If dd-MM-yyyy  -> yyyy-MM
    final m2 = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$').firstMatch(s);
    if (m2 != null) return '${m2.group(3)}-${m2.group(2)}';

    // last resort: return as-is (server will reject if format is wrong)
    return s;
  }

  @override
  void initState() {
    super.initState();
    // 1) caller-provided options
    _staffOpts = List<ComboItem>.from(widget.staffRelationOptions);

    // 2) fallback from FieldListData (parsed list)
    if (_staffOpts.isEmpty) {
      final fld = widget.fields.getField('staff_relation_type');
      _staffOpts = fld?.list ?? const <ComboItem>[];
    }

    _seedStaffRelationOptions();
    _loadJobFamilies();
    _loadJobPositions();
    _parentId = widget.parentLocalId;

    final ex = widget.existing;
    if (ex == null) {
      _localId = 'emp_${DateTime.now().microsecondsSinceEpoch}';
      _categoryIds = <int>[widget.preselectRoleId ?? 8];
    } else {
      _localId = ex.localId;
      _categoryIds = List<int>.from(ex.categoryIds);
      _nameAr = ex.nameAr;
      _nameEn = ex.nameEn;
      // 👇 CHANGED: convert stored DateTime -> yyyy-MM-dd string for UI
      if (ex.birthday != null) {
        // CHANGED: keep greg date for the control
        _dobGreg = _fmt(ex.birthday!);            // e.g. 1991-05-27
        // CHANGED: also compute Hijri YM so Verify works after reopening
        _dobHijriYM = _gregorianToHijriYM(_dobGreg!);  // e.g. 1411-11
      }
      _nid = ex.identificationId;
      _relType = ex.staffRelationType;
      _email = ex.workEmail;
      _phone = ex.workPhone;
      _verified = ex.verified;
    }
  }

  Future<List<ComboItem>> _loadStaffRelationFallback() async {
    try {
      final raw = await rootBundle.loadString(
        'assets/data/mosque/staff_relation_type.json',
      );
      final decoded = jsonDecode(raw);
      final sel = (decoded is Map) ? decoded['selection'] as List? : null;
      if (sel == null) return const <ComboItem>[];

      return sel
          .whereType<List>()
          .where((row) => row.length >= 2)
          .map((row) => ComboItem(key: '${row[0]}', value: '${row[1]}'.tr()))
          .toList();
    } catch (e) {
      debugPrint('⚠️ staff_relation_type fallback load failed: $e');
      return const <ComboItem>[];
    }
  }

  Future<void> _loadJobFamilies() async {
    try {
      final s = await rootBundle.loadString('assets/data/mosque/job_family.json');
      final List js = jsonDecode(s) as List;
      setState(() {
        _jobFamilies = js.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map)).toList();
      });
    } catch (e) {
      debugPrint('⚠️ job_family.json load failed: $e');
      setState(() { _jobFamilies = const []; });
    }
  }

  Future<void> _loadJobPositions() async {
    try {
      final s = await rootBundle.loadString('assets/data/mosque/job_position.json');
      final List js = jsonDecode(s) as List;
      setState(() {
        _jobPositions = js.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map)).toList();
      });
    } catch (e) {
      debugPrint('⚠️ job_position load failed: $e');
      setState(() { _jobPositions = const []; });
    }
  }

  // Future<void> _fetchJobNumbers() async {
  //   if (widget.cityId == null || _jobFamilyId == null || _jobPositionId == null || (_relType ?? '').isEmpty) {
  //     return;
  //   }
  //   try {
  //     if (mounted) {
  //       setState(() { _jobNumberLoading = true; });
  //     }
  //     final client = CustomOdooClient();
  //     final resp = await client.get('/get/crm/job/numbers', {
  //       'city_id': widget.cityId,
  //       'job_family_id': _jobFamilyId,
  //       'job_position_id': _jobPositionId,
  //       'staff_relation_type': _relType,
  //       'page': 1,
  //       'limit': 10,
  //     });
  //     final List data = (resp is Map && resp['data'] is List) ? resp['data'] as List : const [];
  //     final options = data
  //         .whereType<Map<String, dynamic>>()
  //         .map((e) => ComboItem.fromJsonObject(e))
  //         .toList();
  //     setState(() {
  //       _jobNumberOptions = options;
  //       if (_jobNumberId != null && !_jobNumberOptions.any((o) => o.key == _jobNumberId)) {
  //         _jobNumberId = null;
  //         _jobNumberName = null;
  //       }
  //       _jobNumberLoading = false;
  //     });
  //     if (mounted && options.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('No Job ID available for the selected combination'.tr())),
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint('Failed to fetch job numbers: $e');
  //     setState(() {
  //       _jobNumberOptions = const [];
  //       _jobNumberId = null;
  //       _jobNumberName = null;
  //       _jobNumberLoading = false;
  //     });
  //   }
  // }

  Future<List<ComboItem>> _fetchJobNumbersNew() async {
    if (widget.cityId == null || _jobFamilyId == null || _jobPositionId == null || (_relType ?? '').isEmpty) {
      return [];
    }
    try {
      // if (mounted) {
      //   setState(() { _jobNumberLoading = true; });
      // }
      final client = CustomOdooClient();
      final resp = await client.get('/get/crm/job/numbers', {
        'city_id': widget.cityId,
        'job_family_id': _jobFamilyId,
        'job_position_id': _jobPositionId,
        'staff_relation_type': _relType,
        'page': 1,
        'limit': 10,
      });
      final List data = (resp is Map && resp['data'] is List) ? resp['data'] as List : const [];
      final options = data
          .whereType<Map<String, dynamic>>()
          .map((e) => ComboItem.fromJsonObject(e))
          .toList();

        _jobNumberOptions = options;
        if (_jobNumberId != null && !_jobNumberOptions.any((o) => o.key == _jobNumberId)) {
          _jobNumberId = null;
          _jobNumberName = null;
        }
        _jobNumberLoading = false;

      return _jobNumberOptions;
    } catch (e) {
      debugPrint('Failed to fetch job numbers: $e');
      setState(() {
        _jobNumberOptions = const [];
        _jobNumberId = null;
        _jobNumberName = null;
        _jobNumberLoading = false;
      });
      return [];
    }
  }

  // ---------- Helpers (keep dropdown code small) ----------
  List<Map<String, dynamic>> _uniqueById(List<Map<String, dynamic>> list) {
    final seen = <dynamic>{};
    return list.where((m) => seen.add(m['id'])).toList();
  }

  List<ComboItem> _familyOptions() {
    if (_relType == null || _relType!.isEmpty || _categoryIds.isEmpty) return const <ComboItem>[];
    final catId = _categoryIds.first;
    final filtered = _jobFamilies.where((f) {
      final rel = (f['staff_relation_type'] ?? '').toString();
      final cid = (f['category_id'] is List && (f['category_id'] as List).isNotEmpty)
          ? (f['category_id'] as List).first
          : null;
      return rel == _relType && cid == catId;
    }).toList();
    return _uniqueById(filtered)
        .map((f) => ComboItem(key: f['id'], value: f['name']?.toString()))
        .toList();
  }

  List<ComboItem> _positionOptions() {
    if (_jobFamilyId == null) return const <ComboItem>[];
    final filtered = _jobPositions.where((p) {
      final fam = (p['job_family_id'] is List && (p['job_family_id'] as List).isNotEmpty)
          ? (p['job_family_id'] as List).first
          : null;
      return fam == _jobFamilyId;
    }).toList();
    return _uniqueById(filtered)
        .map((p) => ComboItem(key: p['id'], value: p['name']?.toString()))
        .toList();
  }

  String? _safeFamilyValue() {
    if (_jobFamilyId == null) return null;
    final ids = _familyOptions().map((e) => (e.key).toString()).toSet();
    final current = _jobFamilyId?.toString() ?? '';
    return ids.contains(current) ? current : null;
  }

  String? _safePositionValue() {
    if (_jobPositionId == null) return null;
    final ids = _positionOptions().map((e) => (e.key).toString()).toSet();
    final current = _jobPositionId?.toString() ?? '';
    return ids.contains(current) ? current : null;
  }

  List<ComboItem> _staffOptionsForSelectedCategory() {
    if (_categoryIds.isEmpty) return const <ComboItem>[];
    // collect allowed relation codes from job families for this category
    final int catId = _categoryIds.first;
    final Set<String> allowed = _jobFamilies.where((f) {
      final cid = (f['category_id'] is List && (f['category_id'] as List).isNotEmpty)
          ? (f['category_id'] as List).first
          : null;
      return cid == catId;
    }).map((f) => (f['staff_relation_type'] ?? '').toString())
      .where((s) => s.isNotEmpty)
      .toSet();
    // intersect with available staff options
    return _staffOpts.where((o) => allowed.contains((o.key ?? '').toString())).toList();
  }

  String? _safeRelationValue() {
    final allowed = _staffOptionsForSelectedCategory().map((e) => (e.key ?? '').toString()).toSet();
    final current = (_relType ?? '').toString();
    return allowed.contains(current) ? current : null;
  }

  Future<void> _seedStaffRelationOptions() async {
    // 1) what caller passed
    var opts = List<ComboItem>.from(widget.staffRelationOptions);
    if (opts.isNotEmpty) {
      setState(() => _staffOpts = opts.map((e) => ComboItem(key: e.key, value: e.value?.tr())).toList());
      debugPrint('👔 StaffRelation from caller: ${_staffOpts.length}');
      return;
    }

    // 2) parsed combo list from FieldListData
    opts = widget.fields.getComboList('staff_relation_type') ?? const <ComboItem>[];
    if (opts.isNotEmpty) {
      setState(() => _staffOpts = opts.map((e) => ComboItem(key: e.key, value: e.value?.tr())).toList());
      debugPrint('👔 StaffRelation from FieldListData: ${_staffOpts.length}');
      return;
    }

    // 3) fallback JSON (this file)
    opts = await _loadStaffRelationFallback();
    setState(() => _staffOpts = opts);
    debugPrint('👔 StaffRelation from fallback JSON: ${_staffOpts.length}');
  }

  //  Normalize any date payload to yyyy-MM-dd string (no time)
  void _setDOB(dynamic v) {
    String? g; // yyyy-MM-dd (Gregorian)
    String? h; // yyyy-MM-dd (Hijri, full Y-M-D)

    if (v is DateTime) {
      g = _fmt(v);                                // 1986-06-05
    } else if (v is String) {
      final m = RegExp(r'^\d{4}-\d{2}-\d{2}').firstMatch(v);
      if (m != null) g = m.group(0);
    } else if (v is Map) {
      // Try common keys your control may emit
      String? pick(List<String> ks) {
        for (final k in ks) {
          final val = v[k];
          if (val is String && RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(val)) {
            return val;
          }
        }
        return null;
      }
      g = pick(['gregorian', 'gregorian_date', 'gDate', 'date', 'value', 'dt']);
      h = pick(['hijri', 'hijri_date', 'hDate', 'hijriYMD']);

      // Split hijri like {h_year, h_month, h_day}
      if (h == null && v['h_year'] != null && v['h_month'] != null && v['h_day'] != null) {
        final y = int.tryParse('${v['h_year']}') ?? 0;
        final m = int.tryParse('${v['h_month']}') ?? 0;
        final d = int.tryParse('${v['h_day']}') ?? 0;
        if (y > 0 && m > 0 && d > 0) {
          h = '${y.toString().padLeft(4, '0')}-'
              '${m.toString().padLeft(2, '0')}-'
              '${d.toString().padLeft(2, '0')}';
        }
      }
    } else {
      // v is likely your DateConversion – access dynamically, safely
      try {
        final dc = v as dynamic;
        final gy = dc.gYear, gm = dc.gMonth, gd = dc.gDay;
        final hy = dc.hYear, hm = dc.hMonth, hd = dc.hDay;

        if (gy != null && gm != null && gd != null) {
          g = '${gy.toString().padLeft(4, '0')}-'
              '${gm.toString().padLeft(2, '0')}-'
              '${gd.toString().padLeft(2, '0')}';
        }
        if (hy != null && hm != null && hd != null) {
          h = '${hy.toString().padLeft(4, '0')}-'
              '${hm.toString().padLeft(2, '0')}-'
              '${hd.toString().padLeft(2, '0')}';
        }

        // Some implementations expose ready-made strings:
        if (g == null && dc.gregorian is String &&
            RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(dc.gregorian)) {
          g = dc.gregorian as String;
        }
        if (h == null && dc.hijri is String &&
            RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(dc.hijri)) {
          h = dc.hijri as String;
        }
      } catch (_) { /* swallow – fall through */ }
    }

    // If only Gregorian available, derive Hijri for Yakeen fallback
    if (g != null && h == null) {
      h = _gregorianToHijriYMD(g); // your converter
    }

    setState(() {
      _dobGreg = g;
      _dobHijriYM = h;
      _dobWarn = (_dobGreg == null && _dobHijriYM == null);
      _verified = false;   // DOB changed – force re-verify
      _nameAr = null;      // clear previous verified name
    });

    debugPrint('📅 DOB -> greg=$_dobGreg  hijri=$_dobHijriYM');
  }

  // String _fmt(DateTime d) =>
  //     '${d.year.toString().padLeft(4,'0')}-'
  //         '${d.month.toString().padLeft(2,'0')}-'
  //         '${d.day.toString().padLeft(2,'0')}';

  // Future<void> _handleVerify() async {
  //   final nid = (_nid ?? '').trim();
  //   final nidOk = RegExp(r'^\d{10}$').hasMatch(nid);
  //   final hasG = (_dobGreg?.isNotEmpty ?? false);
  //   final hasHym = (_dobHijriYM?.isNotEmpty ?? false);
  //
  //   debugPrint('Verify tapped nidOk=$nidOk g=$_dobGreg hYM=$_dobHijriYM');
  //   if (!nidOk || (!hasG && !hasHym)) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Enter National ID and Date of Birth')),
  //     );
  //     return;
  //   }
  //
  //   setState(() => _verifying = true);
  //   try {
  //     // Yakeen wants hijri yyyy-MM. We expect it from DateConversion.
  //     final hym = _dobHijriYM;
  //     if (hym == null) {
  //       // If you *must* support no-Hijri case, put your converter here,
  //       // otherwise just block and ask user to pick again.
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Please pick DOB again (Hijri is missing)')),
  //       );
  //       return;
  //     }
  //
  //     final svc = YakeenService();
  //     final name = await svc.getUserName(nid, hym);  // yyyy-MM
  //
  //     if (!mounted) return;
  //     if (name != null && name.trim().isNotEmpty) {
  //       setState(() {
  //         _nameAr = name.trim();                         // Arabic from Yakeen
  //         _nameEn = (_nameEn?.trim().isNotEmpty ?? false) ? _nameEn : _nameAr;
  //         _verified = true;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Verified')),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Yakeen not verified')),
  //       );
  //     }
  //   } catch (e) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Yakeen verification failed: $e'), backgroundColor: Colors.red),
  //     );
  //   } finally {
  //     if (mounted) setState(() => _verifying = false);
  //   }
  // }
  Future<void> _handleVerify() async {
    final nid = (_nid ?? '').trim();
    final nidOk = RegExp(r'^\d{10}$').hasMatch(nid);
    final hasG = (_dobGreg?.isNotEmpty ?? false);
    final hasHym = (_dobHijriYM?.isNotEmpty ?? false);

    debugPrint('Verify tapped nidOk=$nidOk g=$_dobGreg hYM=$_dobHijriYM');
    if (!nidOk || (!hasG && !hasHym)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter National ID and Date of Birth'.tr())),
      );
      return;
    }

    setState(() => _verifying = true);
    try {
      // Yakeen wants hijri yyyy-MM. We expect it from DateConversion.
      final hym = _dobHijriYM;
      if (hym == null) {
        // If you *must* support no-Hijri case, put your converter here,
        // otherwise just block and ask user to pick again.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please pick DOB again (Hijri is missing)'.tr())),
        );
        return;
      }

      final svc = YakeenService();
      // Fetch full response so we can populate extra fields
      final raw = await svc.getCitizenDataRaw(nid, hym);  // yyyy-MM
      ({String name, String nameEn})? names;
      if (raw != null && raw['personBasicInfo'] != null) {
        final basic = Map<String, dynamic>.from(raw['personBasicInfo'] as Map);
        final nameAr = [basic['firstName'], basic['fatherName'], basic['grandFatherName'], basic['familyName']]
            .whereType<String>()
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .join(' ');
        final nameEn = [basic['firstNameT'], basic['fatherNameT'], basic['grandFatherNameT'], basic['familyNameT']]
            .whereType<String>()
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .join(' ');
        names = (name: nameAr, nameEn: nameEn);

        // Parse extras
        final idInfo = (raw['personIdInfo'] is Map) ? Map<String, dynamic>.from(raw['personIdInfo']) : const <String, dynamic>{};
        final sexDescAr = (basic['sexDescAr'] ?? '').toString().trim();
        String? g;
        if (sexDescAr == 'ذكر') g = 'male';
        else if (sexDescAr == 'أنثى') g = 'female';
        else if (sexDescAr.isNotEmpty) g = sexDescAr; // fallback

        _statusDescAr = (basic['statusDescAR'] ?? '').toString();
        _occupationCode = (basic['occupationCode'] ?? '').toString();
        _preSamisIssueDate = (idInfo['preSamisIssueDate'] ?? '').toString();
        _idExpired = (idInfo['idExpirationDate'] ?? '').toString();
        _cityOfBirth = (basic['birthCity'] ?? '').toString();
        _gender = g;
        final convert = (basic['convertDate'] is Map) ? Map<String, dynamic>.from(basic['convertDate']) : const <String, dynamic>{};
        _hijriBirthday = (convert['dateString'] ?? '').toString();
      }


      if (!mounted) return;

      if (names != null) {
        final String ar = names.name.trim();
        final String en = names.nameEn.trim();

        debugPrint('[Yakeen] Arabic="$ar" | English="$en"');

        final bool hasAr = ar.isNotEmpty;
        final bool hasEn = en.isNotEmpty;

        if (hasAr || hasEn) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() {
              _nameAr = hasAr ? ar : en; // Prefer Arabic; else use English
              _nameEn = hasEn ? en : _nameAr; // Prefer English; else fallback to Arabic we just set
              _verified = true;

              _nameArKey = UniqueKey();
              _nameEnKey = UniqueKey();

              _verifying = false;
            });
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Verified'.tr()),backgroundColor: Colors.green,));
        } else {
          // Both empty -> treat as not verified
          setState(() => _verifying = false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Yakeen not verified'.tr())));
        }
      } else {
        // Null record -> not verified
        setState(() => _verifying = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Yakeen not verified'.tr())));
      }


    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yakeen verification failed: $e'.tr()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }


  Widget _warn(String msg) => Padding(
    padding: const EdgeInsets.only(top: 6, left: 4),
    child: Row(
      children: [
        const Icon(Icons.error_outline, size: 14, color: Colors.red),
        const SizedBox(width: 6),
        Flexible(child: Text(msg.tr(), style: const TextStyle(color: Colors.red, fontSize: 12))),
      ],
    ),
  );

  void _validateNonTextControls() {
    _roleWarn = _categoryIds.isEmpty;
    _relWarn = (_relType ?? '').isEmpty;
    _dobWarn = (_dobGreg == null || _dobGreg!.isEmpty);
  }

  void _save() {
    final ok = _formKey.currentState?.validate() ?? false;
    _validateNonTextControls();
    setState(() {}); // show any warnings
    if (!ok || _roleWarn || _relWarn || _dobGreg == null) return;

    DateTime? dob;
    try { dob = DateTime.parse(_dobGreg!); } catch (_) {}

    final emp = EmployeeLocal(
      localId: _localId,
      parentLocalId: _parentId,
      categoryIds: _categoryIds,
      nameAr: _nameAr,
      nameEn: _nameEn,
      birthday: dob,                  // ⟵ DateTime built from yyyy-MM-dd
      identificationId: _nid,
      staffRelationType: _relType,
      workEmail: _email,
      workPhone: _phone,
      classificationId: 22,
      verified: _verified,
      // Job mapping
      jobFamilyId: _jobFamilyId,
      jobId: _jobPositionId,
      jobNumberId: _jobNumberId,
      // Yakeen extras
      gender: _gender,
      statusDescAr: _statusDescAr,
      occupationCode: _occupationCode,
      preSamisIssueDate: _preSamisIssueDate,
      idExpired: _idExpired,
      cityOfBirth: _cityOfBirth,
      hijriBirthday: _hijriBirthday,
    );

    debugPrint('SAVE employee -> ${emp.toApiRecord()}');
    Navigator.pop(context, emp);
  }


  @override
  Widget build(BuildContext context) {
    final roleValue = _categoryIds.isNotEmpty ? _categoryIds.first.toString() : '';

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16, right: 16, top: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 1) Date of Birth  (same logic, just moved to top)
                AppDateField(
                  title: 'Date of Birth'.tr(),
                  value: _dobGreg,                  // yyyy-MM-dd
                  maxDate: DateTime.now(),
                  isRequired: true,
                  onChanged: (val) {
                    String? g;
                    if (val is DateTime) g = _fmt(val);
                    else if (val is String) g = val;
                    setState(() {
                      _dobGreg = g;
                      _dobHijriYM = null;  // until detail callback sets it
                      _verified = false;
                      _nameAr = null;
                      _nameEn = null;      // optional: clear too when DOB changes
                    });
                    debugPrint('DOB(onChanged) -> g=$_dobGreg');
                  },
                  onChangedDetail: (val, DateConversion? dc) {
                    String? g;
                    if (val is DateTime) g = _fmt(val);
                    else if (val is String) g = val;

                    String? ym;
                    if (dc != null) {
                      dc.triggerValue();
                      final y = dc.yearHijri ?? '';
                      final m = (dc.monthHijri ?? '').padLeft(2, '0');
                      ym = (y.isEmpty || m.isEmpty) ? null : '$y-$m';
                    }

                    setState(() {
                      _dobGreg = g;
                      _dobHijriYM = ym;    // yyyy-MM for Yakeen
                      _verified = false;
                      _nameAr = null;
                      _nameEn = null;      // optional: clear too when DOB changes
                    });

                    debugPrint('DOB(detail) -> g=$_dobGreg  hYM=$_dobHijriYM');
                  },
                ),
                //if (_dobWarn) _warn('Date of birth is required'),
                if (_dobWarn) _warn('Date_of_birth_is_required'.tr()),
                const SizedBox(height: 10),

                // 2) National ID + Verify
                Row(
                  children: [
                    Expanded(
                      child: AppInputField(
                        title: 'National ID'.tr(),
                        value: _nid ?? '',
                        isRequired: true,
                        validationRegex: RegExp(r'^\d{10}$'),
                        validationError: 'Must be 10 digits'.tr(),
                        onChanged: (v) {
                          setState(() {
                            _nid = v.trim();
                            _verified = false;
                            _nameAr = null;
                            _nameEn = null; // optional: clear too when NID changes
                          });
                          debugPrint('NID => $_nid');
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 40,
                      child: OutlinedButton.icon(
                        icon: _verifying
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.verified_outlined, size: 18),
                        label: Text('Verify'.tr()),
                        onPressed: _verifying ? null : _handleVerify,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // 3) Full Name (Arabic) – readonly; filled by Yakeen
                AppInputField(
                  key: _nameArKey,
                  title: 'Full Name (Arabic)'.tr(),
                  value: _nameAr ?? '',
                  isReadonly: true,
                  isDisable: true,
                ),

                // If you show English field:
                AppInputField(
                  key: _nameEnKey,
                  title: 'Full Name (English)'.tr(),
                  value: _nameEn ?? '',
                  isDisable: true,
                  onChanged: (v) => setState(() => _nameEn = v),
                ),

                const SizedBox(height: 10),

                // 4) Full Name (English) – auto-fill from Arabic if empty on verify, editable
                // AppInputField(
                //   title: 'Full Name (English)',
                //   value: _nameEn ?? '',
                //   isRequired: true,
                //   //onChanged: (v) => setState(() => _nameEn = v),
                // ),
                //const SizedBox(height: 10),

                // 5) Employee Tag
                AppSelectionField(
                  title: 'Employee Tag'.tr(),
                  value: (_categoryIds.isNotEmpty ? _categoryIds.first.toString() : ''),
                  type: SingleSelectionFieldType.selection,
                  options: widget.roleOptions,
                  isDisable: true,
                  onChanged: (v) {
                    final id = int.tryParse((v ?? '').toString());
                    if (id != null) setState(() {
                      _categoryIds = <int>[id];
                      _roleWarn = false;

                    });
                  },
                ),
                if (_roleWarn) _warn('Please choose a tag'.tr()),
                const SizedBox(height: 10),
                // 6) Staff Relation Type
                AppSelectionField(
                  title: 'Staff Relation Type'.tr(),
                  value: _safeRelationValue(),
                  type: SingleSelectionFieldType.radio,
                  options: _staffOptionsForSelectedCategory(),
                  onChanged: _onRelationChangedInternal,
                ),

                if (_relWarn) _warn('Please_choose_relation_type'.tr()),
                const SizedBox(height: 10),

                // 6.1) Job Family
                if ((_relType != null && _relType!.isNotEmpty) && _categoryIds.isNotEmpty)
                Builder(
                  builder: (context) {
                    return AppSelectionField(
                      key: ValueKey('jobFamily:${_relType ?? ''}:${_categoryIds.isNotEmpty ? _categoryIds.first : 'nil'}'),
                      title: 'Job_Family'.tr(),
                      value: _jobFamilyId??0,
                      type: SingleSelectionFieldType.radio,
                      isDisable: (_relType == null || _relType!.isEmpty || _categoryIds.isEmpty),
                      options: _familyOptions(),
                      onChanged: _onFamilyChangedInternal,
                    );
                  }
                ),

                if ((_relType != null && _relType!.isNotEmpty) && _categoryIds.isNotEmpty)
                  const SizedBox(height: 10),

                // 6.2) Job Position
                if (_jobFamilyId != null)
                AppSelectionField(
                  key: ValueKey('jobPosition:${_jobFamilyId ?? 'nil'}'),
                  title: 'job_position'.tr(),
                  value: _jobPositionId,
                  type: SingleSelectionFieldType.radio,
                  isDisable: (_jobFamilyId == null),
                  options: _positionOptions(),
                  onChanged: _onPositionChangedInternal,
                ),

                // 6.3) Job ID (from API) — only show after Job Position is selected
                if (_jobPositionId != null) ...[
                  const SizedBox(height: 10),
                  AppInputField(
                    title: 'Job_ID'.tr(),
                    value: _jobNumberName,
                    onTab: () async{
                      showItemBottomSheet(
                          title: 'Job_ID'.tr(),
                          context: context,
                          emptyLabel: 'No_Job_ID_available'.tr(),
                          // items: result,
                          onLoadItems: () async {
                            return await _fetchJobNumbersNew();
                          },
                          onChange: (ComboItem item){
                            _jobNumberId = item.key;
                            _jobNumberName = item.value;
                            setState(() {

                            });
                          }
                      );
                    },

                  ),

                  // AppSelectionField(
                  //   key: ValueKey('jobNumber:${widget.cityId ?? 'nil'}:${_relType ?? 'nil'}:${_jobFamilyId ?? 'nil'}:${_jobPositionId ?? 'nil'}'),
                  //   title: 'Job_ID'.tr(),
                  //   value: _jobNumberId?.toString(),
                  //   type: SingleSelectionFieldType.selection,
                  //   isDisable: (widget.cityId == null || _relType == null || _relType!.isEmpty || _jobFamilyId == null || _jobNumberOptions.isEmpty),
                  //   options: _jobNumberOptions,
                  //   onChanged: (v) {
                  //     setState(() {
                  //       _jobNumberId = int.tryParse((v ?? '').toString());
                  //     });
                  //   },
                  // ),
                  // if (widget.cityId != null && _relType != null && _relType!.isNotEmpty && _jobFamilyId != null && !_jobNumberLoading && _jobNumberOptions.isEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 6, left: 4),
                  //     child: Text(
                  //       'No Job ID available for the selected position, family and relation'.tr(),
                  //       style: const TextStyle(color: Colors.red, fontSize: 12),
                  //     ),
                  //   ),
                ],

                // 7) Work Email
                AppInputField(
                  title: 'Work Email'.tr(),
                  value: _email ?? '',
                  onChanged: (v) => setState(() => _email = v),
                ),
                const SizedBox(height: 10),

                // 8) Work Phone
                AppInputField(
                  title: 'Work Phone'.tr(),
                  value: _phone ?? '',
                  isRequired: true,
                  validationRegex: _rePhone, // ^966\d{9}$
                  validationError: 'Must start with 966 and be 12 digits'.tr(),
                  onChanged: (v) => setState(() => _phone = v),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    FilledButton(onPressed: _save, child: Text('save'.tr())),
                    const Spacer(),
                    TextButton(onPressed: () => Navigator.pop(context), child: Text('cancel'.tr())),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}