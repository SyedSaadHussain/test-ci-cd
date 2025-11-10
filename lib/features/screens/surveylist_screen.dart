// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:mosque_management_system/core/constants/app_colors.dart';
// import 'package:mosque_management_system/data/services/survey_service.dart';
// import 'package:mosque_management_system/core/providers/user_provider.dart';
// import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
// import 'package:mosque_management_system/shared/widgets/list_item.dart';
// import 'package:mosque_management_system/features/screens/webview_screen.dart';
// import 'package:mosque_management_system/core/utils/gps_permission.dart';
// import '../../core/models/visit_type.dart';
// import '../../core/styles/text_styles.dart';
// import '../../shared/widgets/service_button.dart';
// import '../../shared/widgets/tag_button.dart';
// import '../../shared/widgets/ui_widgets.dart';
// import 'package:mosque_management_system/core/models/combo_list.dart';
//
//
// extension StringCasingExtension on String {
//   String capitalizeFirstLetter() {
//     if (isEmpty) return '';
//     return this[0].toUpperCase() + substring(1);
//   }
// }
//
// class SurveyListScreen extends StatefulWidget {
//   //final String visitType;
//   final int surveyId;
//   final String? surveyLabel;
//   final String? initialStageId;
//   SurveyListScreen({required this.surveyId, this.surveyLabel,this.initialStageId});
//
//   @override
//   _SurveyListScreenState createState() => _SurveyListScreenState();
// }
//
//
// class _SurveyListScreenState extends State<SurveyListScreen> {
//   List<Map<String, dynamic>> allVisits = [];
//   List<Map<String, dynamic>> filteredVisits = [];
//   bool isLoading = true;
//
//   final TextEditingController _searchController = TextEditingController();
//   String activeStage = 'All';
//   List<ComboItem> stageItems = [ComboItem(key: 'All', value: 'الكل')];
//
//
//   @override
//   void initState() {
//     super.initState();
//     fetchSurveyVisits();
//
//   }
//
//
//   Future<void> fetchSurveyStages(List<Map<String, dynamic>> visits) async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final surveyService = SurveyService(userProvider.client!);
//     final loggedInEmployeeId = userProvider.userProfile.userId;
//
//
//
//     try {
//       List<VisitType> visitTypes = await surveyService.fetchVisitTypesWithStages();
//
//       // ✅ Match current surveyId
//       VisitType? selectedType = visitTypes.firstWhere(
//             (v) => v.surveyId == widget.surveyId,
//         orElse: () => VisitType(label: '', value: 0, surveyId: 0, stages: []),
//       );
//
//       print("🧩 Found ${selectedType.stages.length} stages for surveyId ${widget.surveyId}");
//
//       // ✅ Build tab items
//       List<ComboItem> filtered = selectedType.stages.map((stage) {
//         print("🔹 Adding stage tab: ${stage.label}");
//         return ComboItem(key: stage.stageId.toString(), value: stage.label);
//       }).toList();
//
//       // ✅ Find the default stage (if any)
//       final defaultStage = selectedType.stages.firstWhere(
//             (stage) => stage.isDefault == true,
//         orElse: () => Stage(label: 'All', value: 0, sequence: 0, stageId: 0),
//       );
//
//       setState(() {
//         stageItems = [ComboItem(key: 'All', value: 'الكل'), ...filtered];
//
//         if (widget.initialStageId != null) {
//           activeStage = widget.initialStageId!;
//         } else {
//           activeStage = defaultStage.stageId.toString();
//         }
//       });
//
//       // ✅ Apply local filter immediately after tab is selected
//       applyFilters();
//     } catch (e) {
//       print("❌ Error loading stage items: $e");
//     }
//   }
//
//
//
//
//
//   void fetchSurveyVisits() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final surveyService = SurveyService(userProvider.client!);
//     var query = _searchController.text;
//     var filterField = activeStage == 'All' ? null : 'stage_id';
//     var filterValue = activeStage == 'All' ? null : activeStage;
//
//     // List<Map<String, dynamic>> visits = await surveyService.getSurveyVisits(
//     //   null, // Pass null if employeeId is not mandatory
//     //   query: query,
//     //   filterField: filterField,
//     //   filterValue: filterValue,
//     // );
//
//     allVisits = visits.where((visit) {
//       final rawSurveyId = visit['survey_id'];
//       final sid = rawSurveyId is int
//           ? rawSurveyId
//           : (rawSurveyId is List && rawSurveyId.isNotEmpty ? rawSurveyId[0] : null);
//
//       if (sid is int && widget.surveyId == sid) {
//         return true;
//       }
//       return false;
//     }).toList();
//
//     applyFilters();
//     fetchSurveyStages(allVisits);
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//
//   void applyFilters() {
//     String query = _searchController.text.trim().toLowerCase();
//
//     try {
//       final filtered = allVisits.where((visit) {
//        // print("🔍 Visit keys: ${visit.keys}");
//
//         // ✅ Extract survey_id safely from a List like [1, "Label"]
//         final rawSurveyId = visit['survey_id'];
//         final sid = rawSurveyId is int
//             ? rawSurveyId
//             : (rawSurveyId is List && rawSurveyId.isNotEmpty ? rawSurveyId[0] : null);
//
//         //print("🔍 Raw survey_id field: $sid");
//
//         // ✅ Ensure sid is int and matches widget.surveyId
//         if (sid is! int || sid != widget.surveyId) {
//           print("⛔ Visit skipped due to invalid or unmatched survey_id: $sid");
//           return false;
//         }
//
//         print("✅ Matched visit with survey_id: $sid");
//
//         // ✅ Match by stage
//         String? stageId;
//
//         final stageRaw = visit['stage_id'];
//         if (stageRaw is Map && stageRaw.containsKey('id')) {
//           stageId = stageRaw['id'].toString();
//         } else {
//           stageId = null;
//         }
//
//         final matchesStage = activeStage == 'All' || stageId == activeStage;
//         print("active_test stage:$activeStage");
//
//         // ✅ Match by search
//         final mosqueName = (visit['mosque_name']?.toString().toLowerCase() ?? '');
//         final sequenceNo = (visit['sequence_no']?.toString().toLowerCase() ?? '');
//         final matchesSearch = mosqueName.contains(query) || sequenceNo.contains(query);
//
//         return matchesStage && matchesSearch;
//       }).toList();
//
//       print("📦 Filtered by surveyId = ${widget.surveyId}, total visits = ${filtered.length}");
//
//       setState(() {
//         filteredVisits = filtered;
//       });
//     } catch (e, stack) {
//       print("❌ Filter error: $e");
//       print(stack);
//       setState(() {
//         filteredVisits = [];
//       });
//     }
//   }
//
//   void validateLocationAndStartVisit(String visitUrl, double mosqueLat, double mosqueLng) async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text("location_permission".tr()),
//           backgroundColor: Colors.red,
//         ));
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("location_permission".tr()),
//         backgroundColor: Colors.red,
//       ));
//       return;
//     }
//
//     Position? currentPosition = await Geolocator.getLastKnownPosition();
//     if (currentPosition == null) {
//       currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
//     }
//
//     double distanceInMeters = Geolocator.distanceBetween(
//       currentPosition.latitude,
//       currentPosition.longitude,
//       mosqueLat,
//       mosqueLng,
//     );
//
//     if (distanceInMeters <= 100) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => WebViewScreen(url: visitUrl)),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("location_range".tr()),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }
//
//
//   Widget buildFilterTabs() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ...stageItems.map((stage) {
//               bool isActive = activeStage == stage.key.toString();
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 0), // slightly more breathing space
//                 child: AppNewTagButton(
//                   index: stage.key.hashCode,
//                   activeButtonIndex: activeStage.hashCode,
//                   title: stage.value ?? '',
//                   onChange: () {
//                     setState(() {
//                       activeStage = stage.key.toString();
//                     });
//                     applyFilters();
//                   },
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final surveyService = SurveyService(userProvider.client!);
//     final loggedInEmployeeId = userProvider.userProfile.employeeId;
//
//     print("📥 SurveyListScreen opened with surveyId: ${widget.surveyId}, activeStage: $activeStage");
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.primary,
//         body: Column(
//           children: [
//             AppCustomBar(title: widget.surveyLabel?.isNotEmpty == true ? widget.surveyLabel! : 'Survey List'),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               child: TextField(
//                 controller: _searchController,
//                 onChanged: (value) => applyFilters(),
//                 decoration: InputDecoration(
//                   hintText: 'البحث باسم المسجد أو رقم التسلسل...',
//                   prefixIcon: Icon(Icons.search),
//                   fillColor: Colors.white,
//                   filled: true,
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//             ),
//             buildFilterTabs(),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(15.0),
//                     topRight: Radius.circular(15.0),
//                   ),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 5),
//                 child: isLoading
//                     ? Center(child: ProgressBar(opacity: 1))
//                     : filteredVisits.isEmpty
//                     ? Center(child: Text("no_survey_visits_available".tr()))
//                     : ListView.builder(
//                   itemCount: filteredVisits.length,
//                   itemBuilder: (context, index) {
//                     var visit = filteredVisits[index];
//                     var visitUrl = visit['url'] ?? '';
//                     var mosqueLat = visit['mosque_latitude'] ?? 0.0;
//                     var mosqueLng = visit['mosque_longitude'] ?? 0.0;
//                     var priority = visit['priority_value'];
//                     var sequenceNo = visit['sequence_no'];
//
//                     Color? priorityColor = getPriorityColor(priority)?.withOpacity(0.1);
//
//                     return AppListItem(
//                       onTap: () {},
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: priorityColor,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         padding: EdgeInsets.all(8),
//                         margin: EdgeInsets.symmetric(vertical: 4),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(horizontal: 5),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       visit['mosque_name'] ?? 'Unnamed Mosque',
//                                       style: AppTextStyles.cardTitle,
//                                     ),
//                                     Text(
//                                       visit['sequence_no'] ?? 'Unknown Sequence',
//                                       style: AppTextStyles.cardSubTitle,
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.only(top: 4),
//                                       child: Text(
//                                         "${'priority'.tr()}: $priority",
//                                         style: AppTextStyles.cardSubTitle.copyWith(
//                                           fontStyle: FontStyle.italic,
//                                         ),
//                                       ),
//                                     ),
//                                     if ((visit['date_of_survey'] ?? '').isNotEmpty)
//                                       Padding(
//                                         padding: EdgeInsets.only(top: 4),
//                                         child: Text(
//                                           "${'visit_date'.tr()}: ${visit['date_of_survey']}",
//                                           style: AppTextStyles.cardSubTitle.copyWith(
//                                             fontStyle: FontStyle.italic,
//                                           ),
//                                         ),
//                                       ),
//                                     if ((visit['workflow_state'] ?? '').toString().isNotEmpty)
//                                       Padding(
//                                         padding: EdgeInsets.only(top: 4),
//                                         child: Text(
//                                           "${visit['workflow_state'].toString().capitalizeFirstLetter()}",
//                                           style: AppTextStyles.cardSubTitle.copyWith(
//                                             fontStyle: FontStyle.italic,
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             // visitUrl.isNotEmpty
//                             //     ? ElevatedButton(
//                             //   onPressed: () {
//                             //     validateLocationAndStartVisit(visitUrl, mosqueLat, mosqueLng);
//                             //   },
//                             //   style: ElevatedButton.styleFrom(
//                             //     backgroundColor: AppColors.primary,
//                             //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                             //   ),
//                             //   child: Text('Start Visit', style: TextStyle(color: Colors.white)),
//                             // )
//                             //     : Container(),
//                             Builder(
//                               builder: (context) {
//                                 final stageRaw = (visit['stage_id'] ?? {}) as Map<String, dynamic>;
//                                 final printUrl = visit['print_url']?.toString() ?? '';
//                                 final visitUrl = visit['url']?.toString() ?? '';
//                                 final mosqueLat = (visit['mosque_latitude'] is double)
//                                     ? (visit['mosque_latitude'] as double)
//                                     : double.tryParse(visit['mosque_latitude']?.toString() ?? '0.0') ?? 0.0;
//                                 final mosqueLng = (visit['mosque_longitude'] is double)
//                                     ? (visit['mosque_longitude'] as double)
//                                     : double.tryParse(visit['mosque_longitude']?.toString() ?? '0.0') ?? 0.0;
//                                 final workflowState = visit['workflow_state']?.toString().toLowerCase() ?? '';
//
//                                 final bool showViewButton = workflowState != 'draft' && printUrl.isNotEmpty;
//                                 final rawEmployee = visit['employee_id'];
//                                 final employeeId = (rawEmployee is List && rawEmployee.isNotEmpty) ? rawEmployee[0] : null;
//                                 print("🔍 Visit Employee ID: $employeeId");
//                                 print("🧑 Logged In Employee ID: $loggedInEmployeeId");
//
//                                 if (showViewButton) {
//                                   return AppMediumButton(
//                                     title: "view".tr(),
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(builder: (context) => WebViewScreen(url: printUrl,  showDecisionButtons: true,)),
//
//                                       );
//                                     },
//                                   );
//                                 } else if (visitUrl.isNotEmpty && employeeId != null && employeeId == loggedInEmployeeId) {
//                                   return AppMediumButton(
//                                     title: "start_visit".tr(),
//                                     onPressed: () {
//                                       validateLocationAndStartVisit(visitUrl, mosqueLat, mosqueLng);
//                                     },
//                                   );
//                                 } else {
//                                   return SizedBox(); // ✅ return empty widget if nothing
//                                 }
//                               },
//                             )
//
//
//
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Color? getPriorityColor(String? priority) {
//     switch (priority?.toLowerCase()) {
//       case 'high':
//         return AppColors.danger;
//       case 'medium':
//         return AppColors.yellow;
//       case 'low':
//         return AppColors.low;
//       default:
//         return Colors.grey.shade300;
//     }
//   }
// }
