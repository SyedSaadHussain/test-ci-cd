import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/utils/paginated_list.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_edit_request_model.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';
import 'package:mosque_management_system/features/mosque/core/data/mosque_service.dart';
import 'package:mosque_management_system/features/mosque/core/data/mosque_repository.dart';
import 'package:mosque_management_system/data/services/custom_odoo_client.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_screen.dart';
import 'package:mosque_management_system/features/mosque/edit_request/form/create_mosque_edit_screen.dart';
import 'package:mosque_management_system/features/mosque/edit_request/form/create_mosque_edit_view_model.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/widgets/modal_sheet/show_item_bottom_sheet.dart';
import 'package:mosque_management_system/shared/widgets/modal_sheet/show_pagginated_bottom_sheet.dart';
import 'package:provider/provider.dart';




class SelectMosqueScreen extends StatefulWidget {
  final VoidCallback? onCallback;
  final int? RequestId ;
  const SelectMosqueScreen({this.RequestId, super.key, this.onCallback});

  @override
  State<SelectMosqueScreen> createState() => _SelectMosqueScreenState();
}

class _SelectMosqueScreenState extends State<SelectMosqueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mosqueCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  bool _isSaving = false;
  bool _isPickingMosque = false;

  late final MosqueRepository _mosqueService;
  int? _selectedMosqueId;
  String? _selectedMosqueName;

  @override
  void initState() {
    super.initState();
    final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);
    _mosqueService = MosqueRepository();
  }

  @override
  void dispose() {
    _mosqueCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }
  PaginatedList<ComboItem>  list=PaginatedList<ComboItem>();
  Future<void> _pickMosque() async {
    if (_isPickingMosque || _isSaving) return; // <-- ignore re-entry
    _isPickingMosque = true;

    try {
      showItemBottomSheet(
          context: context,
          // items: result,
          onLoadItems: () async {
            return await _mosqueService.fetchUserMosques();
          },
          onChange: (ComboItem item){
            _selectedMosqueId = item.key;
            _selectedMosqueName = item.value;
            _mosqueCtrl.text = item.value??"";
          }
      );
      // // showPaginatedBottomSheet<ComboItem>(
      // //   title: 'List',
      // //   context: context,
      // //   itemBuilder: (ComboItem item) => Text(item.value??""),
      // //   onChange: (ComboItem item){
      // //
      // //   },
      // //   list: list,
      // //   onLoadMore:  (isReload) async {
      // //       _mosqueService.fetchUserMosques();
      // //   },
      // // );
      //
       return;

      final items = await _mosqueService.fetchEditableMosques();
      if (!mounted) return;

      final picked = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => SafeArea(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final m = items[i];
              return ListTile(
                title: Text('${m['name'] ?? ''}'),
                onTap: () => Navigator.pop(context, m),
              );
            },
          ),
        ),
      );

      if (picked == null) return;

      _selectedMosqueId = picked['id'] as int?;
      _selectedMosqueName = (picked['name'] ?? '').toString();
      _mosqueCtrl.text = _selectedMosqueName ?? '';
      if (mounted) setState(() {}); // reflect selection
    } finally {
      _isPickingMosque = false; // <-- release guard
    }
  }

  void _resetSelection() {
    setState(() {
      _selectedMosqueId = null;
      _selectedMosqueName = null;
      _mosqueCtrl.clear();
      // If you want to clear other fields too:
      //_descCtrl.clear();
      //_formKey.currentState?.reset();
    });
  }

  // [ADDED]
  Future<void> _startEditRequestFlow() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMosqueId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_select_mosque_first'.tr())),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      var userProvider=context.read<UserProvider>();
      final route = MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<CreateMosqueBaseViewModel>(
          create: (ctx) => CreateMosqueEditViewModel(
            mosqueId: _selectedMosqueId ?? 0,
            mosqueObj: MosqueEditRequestModel(localId: '', serverId: _selectedMosqueId),
            service: MosqueRepository(),
            profile: userProvider.userProfile
          ),
          child: const CreateMosqueEditScreen(createIfMissing: true),
        ),
      );

      // ⬇️ Wait for the edit screen to finish, then clear selection
      await Navigator.push(context, route);
      if (!mounted) return;
      _resetSelection();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Arabic-first; remove if not needed
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: Stack(
            children: [
              Column(
                children: [
                  // Header (same vibe as your other screens)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context, false),
                          child: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(.5),
                            size: 25,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'create_edit_request'.tr(),
                          style: TextStyle(
                            color: AppColors.onPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Body
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 8),

                              // Mosque (picker-like readonly)
                              GestureDetector(
                                onTap: _pickMosque,
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _mosqueCtrl,
                                    decoration: InputDecoration(
                                      labelText: 'mosque'.tr(),
                                      hintText: 'tap_to_select'.tr(),
                                      suffixIcon: const Icon(Icons.unfold_more),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      isDense: true,
                                    ),
                                    validator: (v) =>
                                    (v == null || v.trim().isEmpty) ? 'required'.tr() : null,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Request title
                              // TextFormField(
                              //   controller: _titleCtrl,
                              //   decoration: InputDecoration(
                              //     labelText: 'title'.tr(),
                              //     hintText: 'e.g., تعديل بيانات المسجد'.tr(),
                              //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              //     isDense: true,
                              //   ),
                              //   validator: (v) =>
                              //   (v == null || v.trim().isEmpty) ? 'required'.tr() : null,
                              // ),
                              const SizedBox(height: 12),

                              // Description
                              // TextFormField(
                              //   controller: _descCtrl,
                              //   minLines: 3,
                              //   maxLines: 6,
                              //   decoration: InputDecoration(
                              //     labelText: 'description'.tr(),
                              //     //hintText: 'brief_reason_or_details'.tr(),
                              //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              //   ),
                              //   validator: (v) =>
                              //   (v == null || v.trim().isEmpty) ? 'required'.tr() : null,
                              // ),
                              const SizedBox(height: 16),

                              // Create button
                              // [CHANGED] label and handler
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isSaving ? null : _startEditRequestFlow,  // [CHANGED]
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('create_request'.tr()), // [CHANGED]
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              if (_isSaving)
                const Center(
                  child: ColoredBox(
                    color: Color(0x33000000),
                    child: SizedBox.expand(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
