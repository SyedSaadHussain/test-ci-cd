import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/constants/model.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/khutba_management.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/styles/custom_box_decoration.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/ui_widgets.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'widget/khutba_attachment_button.dart';
import 'widget/khutba_description_tab.dart';
import 'widget/khutba_guideline_tab.dart';
import 'package:mosque_management_system/core/models/base_state.dart';

class KhutbaDetail extends StatefulWidget {
  final int id;
  const KhutbaDetail({required this.id});

  @override
  State<KhutbaDetail> createState() => _KhutbaDetailState();
}

class _KhutbaDetailState extends BaseState<KhutbaDetail>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final FieldListData fields = FieldListData();
  final style = {'color': '#696f72 !important'};

  UserService? _userService;
  KhutbaManagement khutba = KhutbaManagement();
  dynamic _headersMap;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void widgetInitialized() {
    super.widgetInitialized();
    _userService = UserService(appUserProvider.client!,
        userProfile: appUserProvider.userProfile);
    _loadHeaders();
    _getKhutbaDetail();
    _loadFields();
  }

  void _loadHeaders() async {
    _headersMap = await _userService?.getHeadersMap();
    setState(() {});
  }

  void _loadFields() async {
    final list = await _userService?.loadKhutbaView();
    if (list != null) {
      fields.list = list;
      setState(() {});
    }
  }

  void _getKhutbaDetail() {
    setState(() => appLoading = true);
    _userService?.getKhutbaDetail(widget.id).then((value) {
      khutba = value!;
      setState(() => appLoading = false);
    }).catchError((e) {
      setState(() => appLoading = false);
      AppNotifier.showExceptionError(context,e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          AppBackground(),
          Column(
            children: [
              /// 🔹 App Bar + Attachment
              AppCustomBar(
                title: 'all_khutbas'.tr(),
                actions: [
                  KhutbaAttachmentButton(
                    khutba: khutba,
                    headersMap: _headersMap,
                    fields: fields,
                  ),
                ],
              ),

              /// 🔹 Body
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: AppBoxDecoration.mainBody,
                  child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(48),
                        child: AppBar(
                          automaticallyImplyLeading: false,
                          bottom: TabBar(
                            controller: _tabController,
                            unselectedLabelColor: AppColors.gray,
                            tabs: [
                              Tab(text: fields.getField('description').label),
                              Tab(text: "guide_lines".tr())
                            ],
                          ),
                        ),
                      ),
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          /// 🔹 Description Tab
                          KhutbaDescriptionTab(
                            khutba: khutba,
                            fields: fields,
                            style: style,
                          ),

                          /// 🔹 Guidelines Tab
                          KhutbaGuidelineTab(
                            khutba: khutba,
                            style: style,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          appLoading
              ? ProgressBar()
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}