import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/visit/core/constants/system_default.dart';
import 'package:mosque_management_system/core/hive/extensions/visit_model_hive_extensions.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/utils/app_icons.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_female_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_jumma_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_ondemand_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_type.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_type_code.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/features/visit/eid/list/visit_eid_list_screen.dart';
import 'package:mosque_management_system/features/visit/eid/list/visit_eid_list_view_model.dart';
import 'package:mosque_management_system/features/visit/female/list/visit_female_list_screen.dart';
import 'package:mosque_management_system/features/visit/female/list/visit_female_list_view_model.dart';
import 'package:mosque_management_system/features/visit/jumma/list/visit_jumma_list_screen.dart';
import 'package:mosque_management_system/features/visit/jumma/list/visit_jumma_list_view_model.dart';
import 'package:mosque_management_system/features/visit/land/list/visit_land_list_screen.dart';
import 'package:mosque_management_system/features/visit/land/list/visit_land_list_view_model.dart';
import 'package:mosque_management_system/features/visit/ondemand/list/visit_ondemand_list_screen.dart';
import 'package:mosque_management_system/features/visit/ondemand/list/visit_ondemand_list_view_model.dart';
import 'package:mosque_management_system/features/visit/regular/list/visit_regular_list_screen.dart';
import 'package:mosque_management_system/features/visit/regular/list/visit_regular_list_view_model.dart';
import 'package:provider/provider.dart';

class VisitDashboardViewModel {
  List<VisitType> visitTypes = [];
  List<VisitType> filteredVisitTypes = [];

  /// Load menu
  void init() {
    visitTypes = [
      VisitType(label: VisitMessages.regularVisit, code: VisitTypeCode.regularVisit, value: 1, stages: [], surveyId: 1),
      VisitType(label: VisitMessages.onDemandVisit, code: VisitTypeCode.onDemandVisit, value: 2, stages: [], surveyId: 1),
      VisitType(label: VisitMessages.jummahVisit, code: VisitTypeCode.jummaVisit, value: 3, stages: [], surveyId: 1),
      VisitType(label: VisitMessages.femaleVisit, code: VisitTypeCode.femaleVisit, value: 4, stages: [], surveyId: 1),
      VisitType(label: VisitMessages.landVisit, code: VisitTypeCode.landVisit, value: 5, stages: [], surveyId: 1),
      VisitType(label: VisitMessages.eidVisit, code: VisitTypeCode.eidVisit, value: 6, stages: [], surveyId: 1),
    ];
    filteredVisitTypes = List.from(visitTypes);
    deleteAllOldVisit();
  }

  /// Click on Visit button
  void onVisitSelected(BuildContext context, VisitType visit) {
    if (visit.code == VisitTypeCode.regularVisit) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            final vm = VisitRegularListViewModel(
                currentStageId: VisitDefaults.defaultIdVisitRegular);
            vm.loadAPI();
            vm.showDialogCallback = (dialogMessage) {
              AppNotifier.showDialog(context, dialogMessage);
            };
            return ChangeNotifierProvider<VisitListViewModel<RegularVisitModel>>.value(
              value: vm,
              child: VisitRegularListScreen(title: visit.label),
            );
          },
        ),
      );
    } else if (visit.code == VisitTypeCode.femaleVisit) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            // Create the ViewModel instance
            final vm = VisitFemaleListViewModel(
              currentStageId: VisitDefaults.defaultIdVisitFemale,
            );

            // Assign the dialog callback safely
            vm.showDialogCallback = (DialogMessage dialogMessage) {
              if (!context.mounted) return;
              AppNotifier.showDialog(context, dialogMessage);
            };

            // Load the data
            vm.loadAPI();

            // Provide the ViewModel to the screen
            return ChangeNotifierProvider<VisitListViewModel<VisitFemaleModel>>.value(
              value: vm,
              child: VisitFemaleListScreen(title: visit.label),
            );
          },
        ),
      );
    } else if (visit.code == VisitTypeCode.jummaVisit) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            // Create the ViewModel instance
            final vm = VisitJummaListViewModel(
              currentStageId: VisitDefaults.defaultIdVisitJumma,
            );

            // Assign dialog callback safely
            vm.showDialogCallback = (DialogMessage dialogMessage) {
              if (!context.mounted) return;
              AppNotifier.showDialog(context, dialogMessage);
            };

            // Load the data
            vm.loadAPI();

            // Provide the ViewModel to the screen
            return ChangeNotifierProvider<VisitListViewModel<VisitJummaModel>>.value(
              value: vm,
              child: VisitJummaListScreen(title: visit.label),
            );
          },
        ),
      );
    } else if (visit.code == VisitTypeCode.onDemandVisit) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            // Create the ViewModel instance
            final vm = VisitOndemandListViewModel(
              classificationId: userProvider.userProfile?.classificationId,
              currentStageId: VisitDefaults.defaultIdVisitOndemand,
            );

            // Assign the dialog callback safely
            vm.showDialogCallback = (DialogMessage dialogMessage) {
              if (!context.mounted) return;
              AppNotifier.showDialog(context, dialogMessage);
            };
            vm.userProfile=userProvider.userProfile;
            // Load the data
            vm.loadAPI();

            // Provide the ViewModel to the screen
            return ChangeNotifierProvider<VisitListViewModel<VisitOndemandModel>>.value(
              value: vm,
              child: VisitOndemandListScreen(title: visit.label),
            );
          },
        ),
      );
    } else if (visit.code == VisitTypeCode.landVisit) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            // Create the ViewModel instance
            final vm = VisitLandListViewModel(
              currentStageId: VisitDefaults.defaultIdVisitLand,
            );

            // Assign the dialog callback safely
            vm.showDialogCallback = (DialogMessage dialogMessage) {
              if (!context.mounted) return;
              AppNotifier.showDialog(context, dialogMessage);
            };

            // Load the data
            vm.loadAPI();

            // Provide the ViewModel to the screen
            return ChangeNotifierProvider<VisitListViewModel<VisitLandModel>>.value(
              value: vm,
              child: VisitLandListScreen(title: visit.label),
            );
          },
        ),
      );
    } else if (visit.code == VisitTypeCode.eidVisit) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            // Create the ViewModel instance
            final vm = VisitEidListViewModel(
              currentStageId: VisitDefaults.defaultIdVisitEid,
            );

            // Assign the dialog callback safely
            vm.showDialogCallback = (DialogMessage dialogMessage) {
              if (!context.mounted) return;
              AppNotifier.showDialog(context, dialogMessage);
            };

            // Load the data
            vm.loadAPI();

            // Provide the ViewModel to the screen
            return ChangeNotifierProvider<VisitListViewModel<VisitEidModel>>.value(
              value: vm,
              child: VisitEidListScreen(title: visit.label),
            );
          },
        ),
      );
    }
  }

  /// Change the icon of Visit button
  IconData getSurveyIcon(int surveyId) {
    switch (surveyId) {
      case 1:
        return AppIcons.groupUsers;
      case 2:
        return AppIcons.mosque;
      case 3:
        return AppIcons.mosque;
      case 4:
        return AppIcons.userReload;
      case 5:
        return AppIcons.moonStar;
      default:
        return AppIcons.draft;
    }
  }

  deleteAllOldVisit(){
    HiveRegistry.regularVisit.deleteOldRecords();
    HiveRegistry.ondemandVisit.deleteOldRecords();
    HiveRegistry.jummaVisit.deleteOldRecords();
    HiveRegistry.femaleVisit.deleteOldRecords();
    HiveRegistry.landVisit.deleteOldRecords();
    HiveRegistry.eidVisit.deleteOldRecords();
    print('delete_oldRecord');
  }
}