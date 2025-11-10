// lib/features/mosque/MosqueEditRequest/all_mosque_edit_request_screen.dart
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_edit_request_merges.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/asset_json_utils.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/models/tab_model.dart' show TabItem;

import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_edit_request_model.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';

import 'package:mosque_management_system/features/mosque/core/data/mosque_repository.dart';
import 'package:mosque_management_system/data/services/custom_odoo_client.dart';
import 'package:mosque_management_system/features/mosque/core/data/mosque_service.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_screen.dart';
import 'package:mosque_management_system/features/mosque/edit_request/form/create_mosque_edit_screen.dart';
import 'package:mosque_management_system/features/mosque/edit_request/form/create_mosque_edit_view_model.dart';
import 'package:mosque_management_system/core/constants/config.dart';

import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:mosque_management_system/shared/widgets/cards/app_card.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_new_tag_button.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';

import 'package:provider/provider.dart';

import '../../../../core/models/combo_list.dart';
import '../../../../core/models/user_roles.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/utils/app_notifier.dart';

import '../view/mosque_edit_view.dart';
import '../view/mosque_edit_view_model.dart';
import '../../createMosque/view/mosque_view.dart';

/// Returned from the service when paging edit requests
class PagedEditReqResult {
  final List<MosqueEditRequestModel> items;
  final bool hasMore;
  const PagedEditReqResult({required this.items, required this.hasMore});
}

class AllMosqueEditRequestScreen extends StatefulWidget {
  final int? stageId;
  const AllMosqueEditRequestScreen({super.key, this.stageId});

  @override
  State<AllMosqueEditRequestScreen> createState() =>
      _AllMosqueEditRequestScreenState();
}

class _AllMosqueEditRequestScreenState
    extends State<AllMosqueEditRequestScreen> {
  // Service
  late final MosqueRepository _mosqueService;

  // Stages (chips)
  List<TabItem>? stages;
  int? _stageId;
  int activeButtonIndex = 0;

  // Online pagination
  final _page = _PaginatedEditReq();
  bool _isOfflineView = false;

  // Offline drafts (Hive)
  List<MosqueEditRequestModel> _offline = [];

  // Default stage id (adjust to your JSON if needed)
  int? _computedDraftStageId;
  int get kDraftStageId => _computedDraftStageId ?? 556;



// tiny safe-string helper
  String _nz(String? s, [String fallback = '—']) {
    final v = s?.trim();
    return (v == null || v.isEmpty) ? fallback : v;
  }
  /// Returns the id of the stage whose state == 'draft' (or name == 'المسودة').
  /// Works with nullable lists/items safely.
  int? getDraftStageIdFromJson(List<TabItem?>? tabs) {
    if (tabs == null) return null;

    for (final t in tabs) {
      if (t == null) continue;

      // adjust these field names to your TabItem fields
      final state = (t.key ??  t.key ?? t.value ??  '')
          .toString()
          .toLowerCase()
          .trim();

      final name = (t.value ?? '').toString().trim();

      if (state == 'draft' || name == 'المسودة' || name == 'مسودة') {
        return t.key; // assumes TabItem has int? id
      }
    }
    return null;
  }



  /// A request is "draft" if:
  ///  - there's NO stage info at all (pure local draft), OR
  ///  - stage_id == kDraftStageId, OR
  ///  - stage/workflow name says "Draft" (Arabic handled too)
  bool _isDraftReq(MosqueEditRequestModel m) {
    final p = m.payload ?? const {};

    // stage id may be under several shapes
    final rawId = p['stage_id'] ??
        p['stageId'] ??
        (p['stage'] is Map ? (p['stage'] as Map)['id'] : null);

    int? id;
    if (rawId is int) id = rawId;
    if (rawId is String) id = int.tryParse(rawId);

    // stage name fallbacks
    final rawName = p['stage_name'] ??
        (p['stage'] is Map ? (p['stage'] as Map)['name'] : null) ??
        m.workflowState;

    final name = (rawName ?? '').toString().trim().toLowerCase();
    final nameSaysDraft = name == 'draft' || name == 'المسودة' || name == 'مسودة';

    // no stage at all → draft (local edit)
    if (id == null && name.isEmpty) return true;

    if (id != null) return id == kDraftStageId;
    return nameSaysDraft;
  }

  @override
  void initState() {
    super.initState();
    _mosqueService = MosqueRepository();

    _stageId = widget.stageId ?? kDraftStageId;
    activeButtonIndex = _stageId ?? 0;

    _loadBoot();
  }

  Future<void> _loadBoot() async {
    await _loadStages();
    await _loadOffline();
    await _getEditRequests(true);
  }//

  Future<void> _loadStages() async {
    stages = await AssetJsonUtils.loadList<TabItem>(
      path: 'assets/data/stages/mosque_edit_req_stages.json',
      fromJson: TabItem.fromJsonObject,

    );
    if (mounted) setState(() {});
    final draftId = getDraftStageIdFromJson(stages);

    _computedDraftStageId = draftId;
    if (widget.stageId == null && draftId != null) {
      _stageId = draftId;
      activeButtonIndex = _stageId ?? 0;
      if (mounted) setState(() {});
    }


  }



  Future<void> _loadOffline() async {
    final map = await HiveRegistry.mosqueEditReq.getAllMap();

    final entries = map.entries
        .where((e) => e.value is MosqueEditRequestModel)
        .map((e) => MapEntry(e.key, e.value as MosqueEditRequestModel))
    // show ONLY local drafts (no stage) or explicit Draft stage
        .where((e) => _isDraftReq(e.value))
    // keep only rows that have something to show
        .where((e) {
      final m = e.value;
      final mosqueName = (m.mosqueName ?? m.name ?? '').trim();
      final request    = m.requestName;
      final mosqueId   = m.mosqueIdStr;
      return mosqueName.isNotEmpty || /*request.isNotEmpty */  mosqueId.isNotEmpty;
    })
        .toList();

    // newest first
    entries.sort((a, b) {
      final ad = a.value.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bd = b.value.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bd.compareTo(ad);
    });

    final filtered = entries.map((e) => e.value).toList();

    if (!mounted) return;

    if (_isOfflineView && filtered.isEmpty) {
      setState(() {
        _isOfflineView = false;
        _offline = const [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('No offline drafts found'.tr())),
      );
      return;
    }

    setState(() => _offline = filtered);
  }

 Future<void> _getEditRequests(bool reload) async {
    if (reload) _page.reset();
    _page.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });

    try {
      // NOTE: service returns PaginatedEditRequests
      final result = await _mosqueService.getEditRequests(
        stageId: _stageId,
        pageIndex: _page.pageIndex,
        limit: _page.pageSize,
      );

      _page.isLoading = false;
      _page.list.addAll(result.items);
      _page.hasMore = result.hasMore;
      if (mounted) setState(() {});
    } catch (e) {
      _page.isLoading = false;
      if (mounted) setState(() {});
      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to load edit-requests: $e')),
        // );
      }
    }
  }


  // ----------------- UI ------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    print('aaaaaaa');
    return Scaffold(
      appBar: AppBar(
        title: Text('All Mosque Edit Requests'.tr()),
        actions: [
          // Row(
          //   children: [
          //     const Text('Offline'),
          //     Transform.scale(
          //       scale: 0.75,
          //       child: Switch(
          //         inactiveThumbColor: AppColors.gray.withOpacity(.5),
          //         inactiveTrackColor: AppColors.gray.withOpacity(.3),
          //         value: _isOfflineView,
          //         onChanged: (v) async {
          //           setState(() => _isOfflineView = v);
          //           if (v) await _loadOffline();
          //         },
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
      body: _isOfflineView ? _buildOfflineBody() : _buildOnlineBody(),
    );
  }

  // ----------------- OFFLINE -----------------------------------------------

  Widget _buildOfflineBody() {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              itemCount: _offline.length,
              itemBuilder: (_, i) {
                final m = _offline[i];

                final title = _nz(m.mosqueName, m.localId);
                final sub   = _nz(m.mosqueNumber, _nz(m.mosqueIdStr));
                final state = _nz(m.workflowState, 'Draft'.tr());

                return AppCard(
                  onTap: () async {
                    // await Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => EditRequestDetail(editReqLocalId: m.localId),
                    //   ),
                    // );
                    await _loadOffline();
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: AppTextStyles.cardTitle, softWrap: true),
                              Text(sub, style: AppTextStyles.cardSubTitle),
                              if ((m.serverId ?? 0) > 0)
                                Text('#${m.serverId}', style: AppTextStyles.cardSubTitle),
                            ],
                          ),
                        ),
                      ),
                      AppTag(title: state),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }


  // ----------------- ONLINE (paged) -----------------------------------------

  Widget _buildOnlineBody() {
    return Column(
      children: [
        _buildStageChips(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView.builder(
              itemCount: _page.list.length + (_page.hasMore ? 1 : 0),
              itemBuilder: (_, i) {
                if (i >= _page.list.length) {
                  if (_page.isLoading == false) {
                    _page.pageIndex += 1;
                    _getEditRequests(false);
                  }
                  return  SizedBox(
                    height: 96,
                    child: ProgressBar(opacity: 0),
                  );
                }

                final m = _page.list[i];

                return AppCard(

                  onTap: () {
                    final rid = m.requestId ?? JsonUtils.toInt(m.payload?['request_id']);
                    if (rid == null) {
                      AppNotifier.showError(context, 'Missing request id'.tr());
                      return;
                    }

                    // ---------- resolve stage (name + id) from model/payload ----------
                    String? stageName;   // "Draft", "mmc05", ...
                    int?    stageId;     // 498, 499, ...

                    // 1) try model/workflow field first (string)
                    final ws = (m.workflowState ?? '').toString().trim();
                    if (ws.isNotEmpty) stageName = ws;

                    // 2) then check payload
                    final Map<String, dynamic> p = Map<String, dynamic>.from(m.payload ?? const {});
                    dynamic stageNode = p['stage'] ?? p['stage_id'] ?? p['stage_name'] ?? p['state'] ?? p['state_name'];

                    // normalize
                    if (stageNode is List && stageNode.isNotEmpty) {
                      // e.g. [498, "Draft"] or ["Draft"]
                      final first  = stageNode.first;
                      final second = stageNode.length > 1 ? stageNode[1] : null;

                      if (first is int) stageId = first;
                      if (first is String) stageId = int.tryParse(first);
                      if (second != null && (stageName == null || stageName!.isEmpty)) {
                        stageName = second.toString();
                      } else if (stageName == null || stageName!.isEmpty) {
                        stageName = first.toString();
                      }
                    } else if (stageNode is Map) {
                      // e.g. {"id":498,"name":"Draft"}
                      final idRaw = stageNode['id'];
                      if (idRaw is int) stageId = idRaw;
                      if (idRaw is String) stageId = int.tryParse(idRaw);
                      stageName ??= (stageNode['name'] ?? stageNode['state'] ?? stageNode['stage_name'] ?? stageNode['value'])?.toString();
                    } else if (stageNode is int) {
                      stageId = stageNode;
                    } else if (stageNode is String) {
                      stageName ??= stageNode;
                      stageId ??= int.tryParse(stageNode);
                    }

                    // lowercase compare for safety
                    final sn = (stageName ?? '').toLowerCase();
                    final isDraftByName = sn == 'draft' || stageName == 'المسودة';
                    final isDraftById   = stageId == kDraftStageId;
                    final isDraft       = isDraftByName || isDraftById;

                    // ---------- role check ----------
                    final userProv = context.read<UserProvider>();
                   final isMMC07  = userProv.hasRole(UserRole.MMC07);

                    // ---------- debug prints ----------
                    debugPrint('[EditReq onTap] rid=$rid');
                    debugPrint(' payload.stage=${p['stage']}  stage_id=${p['stage_id']}  stage_name=${p['stage_name']}');
                    debugPrint(' resolved -> stageName="$stageName", stageId=$stageId, isDraft=$isDraft');
                    debugPrint(' user has MMC07 = $isMMC07');

                    final svc = _mosqueService;

                    if (isDraft && isMMC07) {
                      debugPrint('➡️ Opening EDITABLE host (Draft + MMC07).');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<CreateMosqueBaseViewModel>(
                                create: (ctx) => CreateMosqueEditViewModel(
                                    reqId: rid??0,
                                    mosqueObj: MosqueEditRequestModel(localId: '',requestId: rid),
                                    service: MosqueRepository(),
                                    profile: userProv.userProfile,

                                ),
                                child: CreateMosqueEditScreen(createIfMissing: true,),
                              ),
                        ),
                      );
                    } else {
                      debugPrint('➡️ Opening READ-ONLY view.');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider(
                            create: (_) {
                              final vm = MosqueEditViewViewModel(
                                mosqueObj: MosqueEditRequestModel(localId: 'editreq-$rid')..requestId = rid,
                              );
                              // Set the callback to refresh the list when returning
                              vm.onActionCompleted = () {
                                _getEditRequests(true);
                                Navigator.pop(context);
                              };
                              return vm;
                            },
                            child: Builder(
                              builder: (ctx) {
                                final vm = ctx.read<MosqueEditViewViewModel>();
                                return ListenableProvider<MosqueBaseViewModel>.value(
                                  value: vm,
                                  child: MosqueEditView(requestId: rid, title: 'Edit Request'.tr()),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  }
                  ,

                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.displayTitle, style: AppTextStyles.cardTitle),
                              if (m.displayNumber.isNotEmpty)
                                Text(m.displayNumber, style: AppTextStyles.cardSubTitle),
                              if (m.displayRequestIdStr.isNotEmpty)
                                Text(m.displayRequestIdStr, style: AppTextStyles.cardSubTitle),
                              if (m.displayCity.isNotEmpty)
                                Text(m.displayCity, style: AppTextStyles.cardSubTitle),
                            ],
                          ),
                        ),
                      ),
                      AppTag(title: m.displayStage),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // Chips
  Widget _buildStageChips() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            AppNewTagButton(
              index: 0,
              activeButtonIndex: activeButtonIndex,
              title: 'All'.tr(),
              onChange: () {
                setState(() {
                  _stageId = null;
                  activeButtonIndex = 0;
                });
                _getEditRequests(true);
              },
            ),
            ...((stages ?? [])).map((s) {
              return AppNewTagButton(
                key: s.globalKey,
                index: s.key,
                activeButtonIndex: activeButtonIndex,
                title: s.value ?? '',
                onChange: () {
                  setState(() {
                    _stageId = s.key;
                    activeButtonIndex = s.key;
                  });
                  _getEditRequests(true);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  // ----------------- helpers (safe reads) -----------------------------------

  // Convert anything → user string (handles String / [id,name] / {id,name} / false/null)
  String _asStr(dynamic v) {
    if (v == null || v == false) return '';
    if (v is String) return v;
    if (v is Map) {
      return JsonUtils.toText(v['name']) ??
          JsonUtils.toText(v['value']) ??
          '';
    }
    if (v is List && v.isNotEmpty) {
      return JsonUtils.convertToString(v.length > 1 ? v[1] : v.first);
    }
    return JsonUtils.convertToString(v);
  }

  String _pStr(Map<String, dynamic>? p, String key) => _asStr(p?[key]);

  Widget? finalIfNotEmpty(String s) =>
      s.isEmpty ? null : Text(s, style: AppTextStyles.cardSubTitle);
}

// ----------------- pagination holder ----------------------------------------

class _PaginatedEditReq {
  final List<MosqueEditRequestModel> list = [];
  int pageIndex = 1;
  int pageSize = 10;
  bool hasMore = true;
  bool isLoading = false;

  void reset() {
    list.clear();
    pageIndex = 1;
    hasMore = true;
    isLoading = false;
  }

  void init() {
    isLoading = true;
  }
}
