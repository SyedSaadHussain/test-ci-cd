import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/models/visit_type.dart';
import 'package:mosque_management_system/features/screens/all_surveys.dart';
import 'package:mosque_management_system/features/screens/surveylist_screen.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/data/services/survey_service.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/list_item.dart';
import '../../core/constants/input_decoration_themes.dart';
import '../../core/styles/text_styles.dart';
import '../../core/utils/app_icons.dart';
import '../../shared/widgets/no_data.dart';
import '../../shared/widgets/service_button.dart';
import '../../shared/widgets/ui_widgets.dart';

class SurveyVisitScreen extends StatefulWidget {
  @override
  _SurveyVisitScreenState createState() => _SurveyVisitScreenState();
}

class _SurveyVisitScreenState extends State<SurveyVisitScreen> {
  List<VisitType> visitTypes = [];
  bool isLoading = true;
  SurveyService? _surveyService;

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
  TextEditingController _searchController = TextEditingController();
  // List<Map<String, dynamic>> filteredVisitTypes = [];
  List<VisitType> filteredVisitTypes = [];

  @override
  void initState() {
    super.initState();
    widgetInitialized();
    _searchController.addListener(() {
      filterSurveyList(_searchController.text);
    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  void filterSurveyList(String query) {
    setState(() {
      filteredVisitTypes = visitTypes
          .where((item) =>
          (item.label.toString().toLowerCase() ?? '').contains(query.toLowerCase()))
          .toList();
    });
  }

  void widgetInitialized() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _surveyService = SurveyService(userProvider.client!);

    fetchVisitTypes();
  }

  Future<void> fetchVisitTypes() async {
    try {

      List<VisitType> fetchedVisitTypes = await _surveyService!.getAllVisitTypes();

      setState(() {
        visitTypes = fetchedVisitTypes;
        filteredVisitTypes = fetchedVisitTypes;

        isLoading = false;
      });

      print("✅ Visit Types Loaded: $visitTypes");
    } catch (e) {
      print("❌ Error: $e");
      setState(() {
        visitTypes = [];
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Column(
          children: [
            /// 🔹 Header + Search Bar
            Container(
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
                  TextFormField(
                    controller: _searchController,
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                    decoration: AppInputDecoration.firstInputDecoration(
                      context,
                      label: "search".tr(),
                      icon: Icons.search,
                    ),
                  ),
                ],
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
                child: isLoading
                    ? Center(child: ProgressBar(opacity: .1))
                    : filteredVisitTypes.isEmpty
                    ? NoDataFound()
                    : GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                  children: filteredVisitTypes.map((visit) {
                    // final surveyInfo = visit['survey_id'];
                    // int? surveyId;
                    // String? surveyLabel = visit['label']?.toString();

                    int? initialStageId;
                    // final stages = visit['stages'];
                    // if (stages is List) {

                    print('visit.stages');
                    print(visit.stages.first.label);
                    Stage? defaultStage = visit.stages.where(
                            (stage) => stage.isDefault == true).firstOrNull;
                    if (defaultStage != null) {
                      initialStageId = defaultStage.stageId;
                    }


                    // }

                    // if (surveyInfo is int) {
                    //   surveyId = surveyInfo;
                    // } else if (surveyInfo is List && surveyInfo.isNotEmpty) {
                    //   surveyId = surveyInfo[0];
                    //   if (surveyInfo.length > 1) {
                    //     surveyLabel = surveyInfo[1]?.toString();
                    //   }
                    // }

                    // if (surveyId == null) return const SizedBox.shrink();
                    print("🧩 Visit Type: ${visit.label}, Survey ID: ${visit.surveyId}");

                    return ServiceButton(

                      text: visit.label,
                      icon: getSurveyIcon(visit.surveyId),
                      // color: AppColors.primary,
                      onTab: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllSurveys(

                              surveyId: visit.surveyId!,
                              surveyLabel: visit.label,
                              initialStageId: initialStageId??0, // 👈 must be string
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }






}