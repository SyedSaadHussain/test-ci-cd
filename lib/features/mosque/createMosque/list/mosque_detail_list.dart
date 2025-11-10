import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';

import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/mosque_list_items.dart'; // <- ensure this path matches your project
import 'package:mosque_management_system/core/models/tab_model.dart' show TabItem;
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/core/utils/asset_json_utils.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';

import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart'; // <- adjust if your MosqueLocal lives elsewhere

import 'package:mosque_management_system/features/mosque/core/data/mosque_repository.dart';
import 'package:mosque_management_system/data/services/custom_odoo_client.dart';
import 'package:mosque_management_system/features/mosque/core/data/mosque_service.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/core/constants/config.dart';

import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:mosque_management_system/shared/widgets/cards/app_card.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_new_tag_button.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';

// Destinations:
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_screen.dart';       // EDIT screen (legacy_forms)
//import 'package:mosque_management_system/features/mosque/mosque_detail_view.dart';
import 'package:provider/provider.dart';

import '../../../../core/models/combo_list.dart';
import '../../../../core/models/mosque_list_items.dart';
import '../../../../core/models/user_roles.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/utils/json_utils.dart';

class MosqueDetailList extends StatefulWidget {
  final int? stageId;
  const MosqueDetailList({super.key, this.stageId});

  @override
  State<MosqueDetailList> createState() => _MosqueDetailListState();
}

class _MosqueDetailListState extends State<MosqueDetailList>
    with TickerProviderStateMixin {
  // service
  late final MosqueRepository _mosqueService;

  // stages (chips)
  List<TabItem>? stages;
  int? _stageId;
  int activeButtonIndex = 0;

  // online pagination
  final _page = _PaginatedMosques();
  bool _isOfflineView = false;

  // offline
  List<MosqueLocal> _offline = [];

  // hardcoded draft stage; replace with SystemDefault if you have one
  static const int kDraftStageId = 189;



// Try to pull a stage id out of many possible shapes
  int? _readStageId(dynamic v, Map<String, dynamic>? payload) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    if (v is List && v.isNotEmpty) return _readStageId(v.first, payload);
    if (v is Map) {
      return _readStageId(v['id'] ?? v['stage_id'], payload);
    }
    // also check flat payload keys
    if (payload != null) {
      return _readStageId(payload['stage_id'], null);
    }
    return null;
  }

// Try to pull a stage name out of many possible shapes
  String? _readStageName(dynamic v, Map<String, dynamic>? payload) {
    if (v == null) return null;
    if (v is String) return v;
    if (v is List && v.length >= 2) return v[1]?.toString();
    if (v is Map) return (v['name'] ?? v['stage_name'])?.toString();
    if (payload != null) return payload['stage_name']?.toString();
    return null;
  }

// Try to pull a workflow state ('draft', 'in_progress', 'done', 'cancel')
  String? _readStageState(dynamic v, Map<String, dynamic>? payload) {
    if (v is Map && v['state'] != null) return v['state'].toString();
    if (payload != null && payload['state'] != null) return payload['state'].toString();
    return null;
  }

// The policy: allow only DRAFT or NO STAGE (null/empty)
  bool _isDraftOrNoStage(MosqueLocal m) {
    final p = (m.payload is Map<String, dynamic>) ? m.payload as Map<String, dynamic> : null;
    final rawStage = p?['stage']; // could be [id,'name'] or {id,name,state}
    final id    = _readStageId(rawStage, p);
    final name  = _readStageName(rawStage, p)?.toLowerCase().trim();
    final state = _readStageState(rawStage, p)?.toLowerCase().trim();

    final hasAnyStage = (id != null) || (name != null && name.isNotEmpty) || (state != null && state.isNotEmpty);
    if (!hasAnyStage) return true;                 // allow records with no stage at all
    if (id == kDraftStageId) return true;          // 189 → Draft
    if (name == 'draft') return true;
    if (state == 'draft') return true;
    return false;                                  // Supervisor / Checker / Done / Reject, etc.
  }

  @override
  void initState() {
    super.initState();

    _mosqueService =
        MosqueRepository();

    _stageId = widget.stageId ?? kDraftStageId;
    activeButtonIndex = _stageId ?? 0;

    _loadBoot();
  }

  Future<void> _loadBoot() async {
    await _loadStages();
    await _loadOffline();
    await _getMosques(true);
  }

  Future<void> _loadStages() async {
    stages = await AssetJsonUtils.loadList<TabItem>(
      path: 'assets/data/stages/mosque_stages.json',
      fromJson: TabItem.fromJsonObject,
    );
    setState(() {});
  }

  Future<void> _loadOffline() async {
    // 1) pull all from Hive (key -> MosqueLocal)
    final map = await HiveRegistry.mosque.getAllMap();

    // 2) keep only MosqueLocal + filter out empty records
    final entries = map.entries
        .where((e) => e.value is MosqueLocal)
        .map((e) => MapEntry(e.key, e.value as MosqueLocal))
        .where((e) {
      final m = e.value;
      final hasName = (m.name ?? '').trim().isNotEmpty;
      final hasNumber = (m.payload?['number'] ?? '').toString().trim().isNotEmpty;
      final hasClassification = (m.payload?['classification_id'] ?? '').toString().trim().isNotEmpty;
      return hasName || hasNumber || hasClassification;
    })
        .toList();

    // 3) newest first
    entries.sort((a, b) {
      final ad = a.value.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bd = b.value.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bd.compareTo(ad);
    });

    // 3.1) ONLY draft/no-stage when offline
    final filtered = entries
        .map((e) => e.value)
        .where(_isDraftOrNoStage) // <— the new rule
        .toList();

    if (!mounted) return;

    // 4) if user turned Offline on but nothing to show, revert gracefully
    if (_isOfflineView && filtered.isEmpty) {
      setState(() {
        _isOfflineView = false;
        _offline = const [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No offline draft records found'.tr())),
      );
      return;
    }

    // 5) otherwise, show filtered list
    setState(() {
      _offline = filtered;
    });
  }



  Future<void> _getMosques(bool reload) async {
    if (reload) _page.reset();
    _page.init();

    try {
      // use paged variant so we can compute hasMore from total_records
      final result = await _mosqueService.getMosquesPaged(
        stageId: _stageId,
        pageIndex: _page.pageIndex,
        limit: _page.pageSize,
      );

      _page.isLoading = false;
      _page.list.addAll(result.items);
      _page.hasMore = result.hasMore;
      setState(() {});
    } catch (e) {
      _page.isLoading = false;
      _page.hasMore = false;
      setState(() {});
      if (mounted) {
        AppNotifier.showDialog(context,DialogMessage(type: DialogType.errorException, message: e));
      }
    }
  }

  bool _isDraftStage(int? stageId) => stageId == kDraftStageId;

  // --- UI --------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('All Mosques'.tr()),
        actions: [
          Row(
            children: [
              Text('offline_draft'.tr()),
              Transform.scale(
                scale: 0.75,
                child: Switch(
                  inactiveThumbColor: AppColors.gray.withOpacity(.5),
                  inactiveTrackColor: AppColors.gray.withOpacity(.3),
                  value: _isOfflineView,
                  onChanged: (v) async {
                    setState(() => _isOfflineView = v);
                    if (v) await _loadOffline();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isOfflineView ? _buildOfflineBody() : _buildOnlineBody(),
    );
  }

  // --- OFFLINE ---------------------------------------------------------------

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
                final name = m.payload?['name']?.toString() ??
                    m.payload?['mosque_name']?.toString() ??
                    m.localId;

                final stage = m.payload?['stage']?.toString() ?? 'offline_draft'.tr();

                return AppCard(
                  onTap: () {
                    var userProvider=context.read<UserProvider>();
                    // Offline always goes to EDIT (local draft)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChangeNotifierProvider<CreateMosqueBaseViewModel>(
                              create: (ctx) => CreateMosqueViewModel(mosqueObj: MosqueLocal(localId: m.localId,),
                                  service: MosqueRepository(),
                                  profile: userProvider.userProfile
                              ),
                              child: CreateMosqueScreen(createIfMissing: true,),
                            ),
                      ),
                    );
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => MosqueDetail(
                    //       localId: m.localId,
                    //     ),
                    //   ),
                    // ).then((_) => _loadOffline());
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: AppTextStyles.cardTitle, softWrap: true),
                              if ((m.serverId ?? 0) > 0)
                                Text('#${m.serverId}', style: AppTextStyles.cardSubTitle),
                            ],
                          ),
                        ),
                      ),
                      AppTag(title: stage),
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

  // --- ONLINE ---------------------------------------------------------------

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
                    _getMosques(false);
                  }
                  return SizedBox(
                    height: 100,
                    child:  ProgressBar(opacity: 0),
                  );
                } else {
                  final item = _page.list[i];
                  return AppCard(
                    onTap: () {
                      {
                        final mosqueId = item.id ;
                        if (mosqueId == null) {
                          AppNotifier.showError(context, 'Missing mosque id'.tr());
                          return;
                        }

                        // ---------- resolve stage (name + id) from model/payload ----------
                        String? stageName;   // "Draft", "mmc05", ...
                        int?    stageId;     // 498, 499, ...

                        // 1) try model/workflow field first (string)
                        final ws = (item.stageName ?? '').toString().trim();
                        if (ws.isNotEmpty) stageName = ws;

                        // 2) then check payload
                         stageId = item.stageId;



                        //compare the current item's stageId against the draft constant
                        final bool isDraftById = (stageId == kDraftStageId);
                        final bool isDraftByName = ((stageName ?? '').toLowerCase().contains('draft') ||
                            (stageName ?? '').contains('مسودة')); // Arabic “draft”
                        final bool isDraft = isDraftById || isDraftByName; //

                        final userProv = context.read<UserProvider>();
                        final isMMC07 = userProv.hasRole(UserRole.MMC07);

                        // ---------- debug prints ----------
                        debugPrint('[Mosque onTap] mosqueID=$item.id');
                        debugPrint(' payload.stage=$stageId');
                        debugPrint(' resolved -> stageName="$stageName", stageId=$stageId, isDraft=$isDraft');
                        debugPrint(' user has MMC07 = $isMMC07');

                        if (isDraft && isMMC07) {
                          debugPrint(
                              '➡️ Opening EDITABLE host (Draft + MMC07).');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider<
                                      CreateMosqueBaseViewModel>(
                                    create: (ctx) =>
                                        CreateMosqueViewModel(
                                            mosqueObj: MosqueLocal(
                                                localId: '', serverId: item.id,
                                              payload: item.stageId != null ? {
                                                'stage_id': item.stageId
                                              } : null,
                                            ),
                                            service: MosqueRepository(),
                                             profile: userProv.userProfile,
                                            onActionCompleted : () {
                                              _getMosques(true);
                                              Navigator.pop(context);
                                            }
                                        ),
                                    child: CreateMosqueScreen(
                                      createIfMissing: true,),
                                  ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ChangeNotifierProvider<MosqueBaseViewModel>(
                                    create: (_) {
                                      final vm = MosqueViewViewModel(
                                        mosqueObj: MosqueLocal(
                                          localId: '',
                                          serverId: item.id,
                                          payload: item.stageId != null ? {
                                            'stage_id': item.stageId
                                          } : null,
                                        ),
                                      );
                                      // Set the callback to refresh the list when returning
                                      vm.onActionCompleted = () {
                                        _getMosques(true);
                                        Navigator.pop(context);
                                      };
                                      return vm;
                                    },
                                    // we need a new BuildContext that can see the VM we just created
                                    child: MosqueView(
                                      mosqueId: item.id,
                                      title: item.name,
                                    ),
                                  ),
                            ),
                          );
                        }
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: AppTextStyles.cardTitle),
                                if ((item.number ?? '').isNotEmpty)
                                  Text(item.number!, style: AppTextStyles.cardSubTitle),
                                //Text('#${item.id}', style: AppTextStyles.cardSubTitle),
                                if ((item.cityName ?? '').isNotEmpty)
                                  Text(item.cityName!, style: AppTextStyles.cardSubTitle),
                              ],
                            ),
                          ),
                        ),
                        AppTag(title: item.stageName ?? ''),
                      ],
                    ),
                    isLoading: item.isLoading,
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

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
                _getMosques(true);
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
                  _getMosques(true);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

// --- simple pagination holder (like your PaginatedVisits) --------------------
class _PaginatedMosques {
  final List<MosqueListItem> list = [];
  int pageIndex = 1;
  int pageSize = 10; // matches your API example
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
