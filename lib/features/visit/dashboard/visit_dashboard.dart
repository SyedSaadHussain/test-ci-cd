import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/features/visit/dashboard/visit_dashboard_view_model.dart';
import 'package:mosque_management_system/shared/widgets/buttons/service_button.dart';

 class VisitDashboardView extends StatefulWidget {
  @override
  _VisitDashboardViewState createState() => _VisitDashboardViewState();
}

 class _VisitDashboardViewState extends State<VisitDashboardView> {

  final vm = VisitDashboardViewModel();
  @override
  void initState() {
    super.initState();
    vm.init();
    setState(() { });
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          /// 🔹 Header + Search Bar
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(.5),
                          size: 25,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'survey_visits'.tr(),
                        style: TextStyle(
                          fontSize: 22,
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(.8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),

          /// 🔹 Body Grid
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                      padding: EdgeInsets.zero, // 👈 Removes the unwanted top gap
                      children: vm.filteredVisitTypes.map((visit) {
                        return ServiceButton(
                          text: visit.label,
                          icon: vm.getSurveyIcon(visit.surveyId),
                          // color: AppColors.primary,
                          onTab: () {
                            vm.onVisitSelected(context, visit);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}