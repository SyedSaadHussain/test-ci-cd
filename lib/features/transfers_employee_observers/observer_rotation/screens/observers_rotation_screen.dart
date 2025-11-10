import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/incoming_tab_widget.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/request_type.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/rotation_form_body.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/sent_tab_widget.dart';

class ObserversRotationScreen extends StatefulWidget {
  const ObserversRotationScreen({super.key});

  @override
  State<ObserversRotationScreen> createState() =>
      _ObserversRotationScreenState();
}

class _ObserversRotationScreenState extends State<ObserversRotationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: 0); // Set Create tab as default (index 0)
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 25,
          ),
        ),
        title: Text(
          'observers_rotation'.tr(),
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            color: AppColors.primary,
            child: TabBar(
              controller: _tabController,
              labelPadding: const EdgeInsets.symmetric(horizontal: 20),
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(text: 'create'.tr()),
                Tab(text: 'incoming'.tr()),
                Tab(text: 'sent'.tr()),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          RotationFormBody(),
          IncomingTab(requestType: RequestType.observersRotation),
          SentTab(requestType: RequestType.observersRotation),
        ],
      ),
    );
  }
}
