import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/current_mosque_step_widget.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/documents_step_widget.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/employee_info_step_widget.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/incoming_tab_widget.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/navigation_buttons_widget.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/new_mosque_step_widget.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/request_type.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/sent_tab_widget.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/step_tabs_widget.dart';

class EmployeeTransfersFormScreen extends StatefulWidget {
  const EmployeeTransfersFormScreen({super.key});

  @override
  State<EmployeeTransfersFormScreen> createState() =>
      _EmployeeTransfersFormScreenState();
}

class _EmployeeTransfersFormScreenState
    extends State<EmployeeTransfersFormScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Step navigation variables
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Employee
  String? selectedEmployee;

  // Employee Roles
  String? selectedCurrentRole;
  String? selectedNewRole;

  // Mosque (Current & New)
  String? selectedCurrentMosque;
  String? selectedNewMosque;

  // Additional Fields
  String? trasulTransactionNumber;
  String? transferLetterFile;
  String? evacuationProofOption;
  String? evacuationProofFile;

  // Step navigation methods

  void _onStepChanged(int step) {
    setState(() {
      currentStep = step;
    });
  }

  void _onPreviousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void _onNextStep() {
    if (currentStep < 3) {
      setState(() {
        currentStep++;
      });
    }
  }


  // Demo data for mosques
  final Map<String, Map<String, String>> mosqueData = const {
    "جامع الملك خالد": {
      "code": "MK-001",
      "region": "الرياض",
      "city": "الرياض",
      "classification": "جامع",
    },
    "مسجد النور": {
      "code": "NR-112",
      "region": "الشرقية",
      "city": "الدمام",
      "classification": "مسجد",
    },
    "مسجد السلام": {
      "code": "SL-209",
      "region": "مكة المكرمة",
      "city": "جدة",
      "classification": "مسجد",
    },
  };

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return EmployeeInfoStepWidget(
          selectedEmployee: selectedEmployee,
          onEmployeeChanged: (val) {
            setState(() => selectedEmployee = val);
          },
        );
      case 1:
        return CurrentMosqueStepWidget(
          selectedCurrentMosque: selectedCurrentMosque,
          selectedCurrentRole: selectedCurrentRole,
          mosqueData: mosqueData,
          onCurrentMosqueChanged: (val) {
            setState(() => selectedCurrentMosque = val);
          },
          onCurrentRoleChanged: (val) {
            setState(() => selectedCurrentRole = val);
          },
        );
      case 2:
        return NewMosqueStepWidget(
          selectedNewMosque: selectedNewMosque,
          selectedNewRole: selectedNewRole,
          mosqueData: mosqueData,
          onNewMosqueChanged: (val) {
            setState(() => selectedNewMosque = val);
          },
          onNewRoleChanged: (val) {
            setState(() => selectedNewRole = val);
          },
        );
      case 3:
        return DocumentsStepWidget(
          trasulTransactionNumber: trasulTransactionNumber,
          transferLetterFile: transferLetterFile,
          evacuationProofOption: evacuationProofOption,
          evacuationProofFile: evacuationProofFile,
          onTrasulNumberChanged: (value) {
            setState(() => trasulTransactionNumber = value);
          },
          onTransferLetterChanged: (value) {
            setState(() => transferLetterFile = value);
          },
          onEvacuationProofOptionChanged: (value) {
            setState(() => evacuationProofOption = value);
          },
          onEvacuationProofFileChanged: (value) {
            setState(() => evacuationProofFile = value);
          },
          onCancel: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("cancelled".tr()),
                duration: Duration(milliseconds: 200),
              ),
            );
          },
          onSave: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("saved".tr()),
                duration: Duration(milliseconds: 200),
              ),
            );
          },
        );
      default:
        return Container();
    }
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
          'employee_transfer'.tr(),
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
        children: [
          // Create tab with step navigation
          Column(
            children: [
              // Step tabs
              StepTabsWidget(
                currentStep: currentStep,
                onStepChanged: _onStepChanged,
              ),
              
              // Step content
              Expanded(
                child: _buildStepContent(),
              ),
              
              // Navigation buttons (only show previous button in last step)
              if (currentStep == 3)
                NavigationButtonsWidget(
                  showPrevious: true,
                  showNext: false,
                  onPrevious: _onPreviousStep,
                )
              else
                NavigationButtonsWidget(
                  showPrevious: currentStep > 0,
                  showNext: currentStep < 3,
                  onPrevious: _onPreviousStep,
                  onNext: _onNextStep,
                ),
            ],
          ),
          const IncomingTab(isEmployeeTransferScreen: true, requestType: RequestType.employeeTransfer),
          const SentTab(isEmployeeTransferScreen: true, requestType: RequestType.employeeTransfer)
        ],
      ),
    );
  }
}


