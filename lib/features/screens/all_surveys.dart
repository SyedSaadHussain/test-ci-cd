import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mosque_management_system/core/models/base_state.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/survey_user_input.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/shared/widgets/modal/survey_filter_modal.dart';
import 'package:mosque_management_system/features/screens/survey_detail.dart';
import 'package:mosque_management_system/features/screens/survey_view.dart';
import 'package:mosque_management_system/core/utils/app_icons.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/gps_permission.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/shared/widgets/app_form_field.dart';
import 'package:provider/provider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/data/services/survey_service.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/list_item.dart';
import 'package:mosque_management_system/features/screens/webview_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../core/models/visit_type.dart';
import '../../core/styles/text_styles.dart';
import '../../shared/widgets/app_list_title.dart';
import '../../shared/widgets/fetchgps_bottomsheet.dart';
import '../../shared/widgets/service_button.dart';
import '../../shared/widgets/tag_button.dart';
import '../../shared/widgets/ui_widgets.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';



extension StringCasingExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return '';
    return this[0].toUpperCase() + substring(1);
  }
}

class AllSurveys extends StatefulWidget {
  //final String visitType;
  final int surveyId;
  final String? surveyLabel;
  final dynamic initialStageId;


  AllSurveys({required this.surveyId, this.surveyLabel,this.initialStageId}
    );



  @override
  _AllSurveysState createState() => _AllSurveysState();
}


class _AllSurveysState extends BaseState<AllSurveys> {


  //region for variables

  List<GlobalKey> stageTabKeys = [];
  int? initialStageId;
  final TextEditingController _searchController = TextEditingController();
  SurveyUserInputData _surveyInputData =SurveyUserInputData();
  SurveyUserInput surveyFilter=SurveyUserInput();
  String activeStage = 'All';
  List<ComboItem> stageItems = [ComboItem(key: 'All', value: 'الكل')];
  late SurveyService _surveyService;
  dynamic filterValue;
  bool hasScrolledToDefaultStage = false;
  FieldListData fields=FieldListData();

  //endregion
  GPSPermission? permission;
  bool isVisiablePermission = false;


  //region for events
  @override
  void initState() {
    super.initState();

    filterValue=widget.initialStageId;
    // fetchSurveyVisits(true);
    initialStageId = widget.initialStageId; // ← Make sure this is passed to the widget


    List<GlobalKey> stageTabKeys = [];
    // if (!_hasAutoScrolled) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     int defaultIndex = stageItems.indexWhere((stage) => stage.key == initialStageId);
    //     if (defaultIndex >= 0 && defaultIndex < stageTabKeys.length) {
    //       final ctx = stageTabKeys[defaultIndex].currentContext;
    //       if (ctx != null) {
    //         Scrollable.ensureVisible(
    //           ctx,
    //           duration: Duration(milliseconds: 300),
    //           alignment: 0.5,
    //         );
    //       }
    //     }
    //     _hasAutoScrolled = true; // ✅ prevent future auto-scrolls
    //   });
    // }



  }


  @override
  void widgetInitialized() {
    super.widgetInitialized();
    // userProvider = Provider.of<UserProvider>(context);


    _surveyService = SurveyService(appUserProvider.client!,userProfile: appUserProvider.userProfile);

    // getStages();

    fetchSurveyStages();
    loadView();


    // fetchSurveyVisits(true);

  }

  //endregion

  //region for methods
  Future<void> fetchSurveyStages() async {

    final loggedInEmployeeId = appUserProvider.userProfile.employeeId;

    try {
      List<VisitType> visitTypes = await _surveyService.fetchVisitTypesWithStages();

      // ✅ Match current surveyId
      VisitType? selectedType = visitTypes.firstWhere(
            (v) => v.surveyId == widget.surveyId,
        orElse: () => VisitType(label: '', value: 0, surveyId: 0, stages: []),
      );

      print("🧩 Found ${selectedType.stages.length} stages for surveyId ${widget.surveyId}");
     // print("surveyTest:${widget.surveyId}");

      // ✅ Build tab items
      List<ComboItem> filtered = selectedType.stages.map((stage) {
        print("🔹 Adding stage tab: ${stage.label}");
        return ComboItem(key: stage.stageId, value: stage.label);
      }).toList();

      // ✅ Find the default stage (if any)
      // final defaultStage = selectedType.stages.firstWhere(
      //       (stage) => stage.isDefault == true,
      //   orElse: () => Stage(label: 'All', value: 0, sequence: 0, stageId: 0),
      // );

      setState(() {
        stageItems = [ComboItem(key: 0, value: 'الكل'), ...filtered];
        activeStage = widget.initialStageId!.toString();
      });

      // ✅ Apply local filter immediately after tab is selected
      // applyFilters();
    } catch (e) {
      print("❌ Error loading stage items: $e");
    }
  }
  var query = '';
  void fetchSurveyVisits(bool isReload) async {
    print('fetchSurveyVisits');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {

      });
    });

    if(isReload){
      _surveyInputData.reset();
    }
    _surveyInputData.init();

    // query = _searchController.text;
    var filterField = activeStage == 'All' ? null : 'stage_id';
    print("all_check:$filterField");
    _surveyService.getAllSurveyVisits(
        null, // Pass null if employeeId is not mandatory
        pageSize: _surveyInputData.pageSize,
        pageIndex: _surveyInputData.pageIndex,
        query: query,
        filterField: filterField,
        filterValue: (filterValue??0)==0?null:filterValue,
        surveyId: widget.surveyId,
        filter: surveyFilter
    ).then((response){
      _surveyInputData.isloading=false;
      if(response.list.isEmpty)
        _surveyInputData.hasMore=false;
      else {
        _surveyInputData.list!.addAll(response.list!.toList());
      }

      setState((){});

    }).catchError((e){

      _surveyInputData.hasMore=false;
      _surveyInputData.isloading=false;
      Flushbar(
        icon: Icon(Icons.warning,color: Colors.white,),
        backgroundColor: AppColors.danger,
        message: e.toString().replaceFirst('Exception: ', ''),
        duration: Duration(seconds: 3),
      ).show(context);

    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {

      });
    });
  }

  // void validateLocationAndStartVisit(String visitUrl, double mosqueLat, double mosqueLng) async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text("location_permission".tr()),
  //         backgroundColor: Colors.red,
  //       ));
  //       return;
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("location_permission".tr()),
  //       backgroundColor: Colors.red,
  //     ));
  //     return;
  //   }
  //
  //   Position? currentPosition = await Geolocator.getLastKnownPosition();
  //   if (currentPosition == null) {
  //     currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  //   }
  //
  //   double distanceInMeters = Geolocator.distanceBetween(
  //     currentPosition.latitude,
  //     currentPosition.longitude,
  //     mosqueLat,
  //     mosqueLng,
  //   );
  //
  //   if (distanceInMeters <= 100) {
  //
  //     final matchedSurvey = _surveyInputData.list.firstWhere(
  //           (element) => element.url == visitUrl,
  //       orElse: () => SurveyUserInput(url: visitUrl),
  //     );
  //     //final testurl = "http://172.20.10.76:8069/survey#id=443499&menu_id=1034&action=1216&model=survey.user_input&view_type=form";
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => SurveyDetail(
  //             surveyInput: matchedSurvey,
  //             onCallback: () {
  //               print("🌀 Survey Accept/Refuse callback triggered");
  //               fetchSurveyVisits(true); // Optional: refresh list
  //             },
  //           ),
  //         )
  //     );
  //     // Navigator.push(
  //     //   context,
  //     //     MaterialPageRoute(
  //     //         builder: (context) => WebViewScreen(
  //     //         url: visitUrl,
  //     //         showDecisionButtons: true,
  //     //         surveyInput: matchedSurvey,
  //     //         onCallback: () {
  //     //           print("🌀 Survey Accept/Refuse callback triggered");
  //     //           fetchSurveyVisits(true); // Optional: refresh list
  //     //         },
  //     //       ),
  //     //     )
  //     // );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("location_range".tr()),
  //       backgroundColor: Colors.red,
  //     ));
  //   }
  // }

  loadView(){
    _surveyService!.loadSurveyInputView().then((list){
      fields.list=list;
      print(fields.getField("region_id").list);
      setState(() {
      });
    }).catchError((e){
    });
  }

  void showFilterModal(){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SurveyFilterModal(client: appUserProvider.client!,
            filter: surveyFilter,
            fields: fields,
            onClick: (SurveyUserInput filter){
              surveyFilter=SurveyUserInput.shallowCopy(filter);
              Navigator.of(context).pop();
              fetchSurveyVisits(true);
            });
      },
    );
  }

  //endregion

  Widget buildFilterTabs() {
    // ✅ Ensure stageTabKeys are initialized
    stageTabKeys = List.generate(stageItems.length, (_) => GlobalKey());

    // ✅ Auto-scroll to default stage tab only once
    if (!hasScrolledToDefaultStage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        int defaultIndex = stageItems.indexWhere((stage) => stage.key == initialStageId);
        if (defaultIndex >= 0 && defaultIndex < stageTabKeys.length) {
          final ctx = stageTabKeys[defaultIndex].currentContext;
          if (ctx != null) {
            Scrollable.ensureVisible(
              ctx,
              duration: Duration(milliseconds: 300),
              alignment: 0.5,
            );
            hasScrolledToDefaultStage = true;
          }
        }
      });
    }


    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(stageItems.length, (index) {
            final stage = stageItems[index];
            bool isActive = activeStage == stage.key.toString();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: AppNewTagButton(
                key: stageTabKeys[index],
                index: stage.key.toString().hashCode,
                activeButtonIndex: activeStage.toString().hashCode,
                title: stage.value ?? '',
                onChange: () {
                  setState(() {
                    activeStage = stage.key.toString();
                    filterValue = stage.key;
                  });

                  // ✅ Optional: Scroll to the selected tab
                  final ctx = stageTabKeys[index].currentContext;
                  if (ctx != null) {
                    Scrollable.ensureVisible(
                      ctx,
                      duration: Duration(milliseconds: 250),
                      alignment: 0.5,
                    );
                  }

                  fetchSurveyVisits(true);
                },
              ),
            );
          }),
        ),
      ),
    );
  }
  bool isLoading=false;
  void openSurveyDetailPage(SurveyUserInput survey){
    print('survey.state');
    print(survey.state);

    if(survey.state!='new'){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SurveyDetail(
            surveyInput: survey,
            onCallback: () {
              fetchSurveyVisits(true);
            },
          ),
        ),
      );
    }else{
      setState(() {
        isLoading=true;
      });
      _surveyService.startSurvey(survey!.submitToken).then((respnse){
        setState(() {
          isLoading=false;
        });
        if(respnse['success']==true){
          survey.state="in_progress";
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurveyDetail(
                surveyInput: survey,
                onCallback: () {
                  fetchSurveyVisits(true);
                },
              ),
            ),
          );
        }
        else if (respnse['error'] != null) {
          Flushbar(
            icon: Icon(Icons.warning,color: Colors.white,),
            backgroundColor: AppColors.danger,
            message:respnse['error'],
            duration: Duration(seconds: 3),
          ).show(context);
        }
      }).catchError((e){
        setState(() {
          isLoading=false;
        });
        Flushbar(
          icon: Icon(Icons.warning,color: Colors.white,),
          backgroundColor: AppColors.danger,
          message: e.message,
          duration: Duration(seconds: 3),
        ).show(context);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final loggedInEmployeeId = userProvider.userProfile.employeeId;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            Column(
              children: [
                AppCustomBar(title: widget.surveyLabel?.isNotEmpty == true ? widget.surveyLabel! : 'Survey List',
                actions: [
                IconButton(onPressed: (){

                  }, icon:GestureDetector(
                        onTap:(){
                          showFilterModal();
                        },
                        child: Row(
                          children: [
                            Text('filter'.tr(),style: TextStyle(color: Colors.white),),Icon(Icons.filter_alt_outlined,)],

                        ),
                    )
                  ,)
                  ]
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child:
                  SearchInputField(onSearch: (val){
                    query=val;
                    fetchSurveyVisits(true);
                  },hint: 'البحث حسب اسم المسجد أو المدينة...',)

                  // TextField(
                  //   controller: _searchController,
                  //   onChanged: (value) => fetchSurveyVisits(true),
                  //   decoration: InputDecoration(
                  //     hintText: 'البحث حسب اسم المسجد أو المدينة...',
                  //     prefixIcon: Icon(Icons.search),
                  //     fillColor: Colors.white,
                  //     filled: true,
                  //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  //   ),
                  // ),
                ),
                buildFilterTabs(),
                // Container(
                //   padding: EdgeInsets.symmetric(vertical: 8),
                //
                //   child: SingleChildScrollView(
                //     scrollDirection: Axis.horizontal,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children:  [
                //         ...(stageItems??[])!.map((stage) {
                //           return AppNewTagButton(
                //             index: stage.key,
                //             activeButtonIndex: initialStageId,
                //             title: (stage.value??""),
                //             onChange: () {
                //               setState(() {
                //                 filterValue=stage.key;
                //                 initialStageId = stage.key;
                //               });
                //               // Call your function here
                //               fetchSurveyVisits(true);
                //             },
                //           );
                //         }).toList()],
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: (_surveyInputData.hasMore==false && _surveyInputData.list!.length==0)?Center(child: Text('no_record_found'.tr(),style: TextStyle(color: Colors.grey),)):
                    ListView.builder(
                          itemCount: _surveyInputData.list!.length+((_surveyInputData.hasMore)?1:0),
                          itemBuilder: (context, index) {
                          if(index >= _surveyInputData.list!.length)
                          {
                          if(_surveyInputData.isloading==false) {
                            _surveyInputData.pageIndex = _surveyInputData.pageIndex + 1;
                            fetchSurveyVisits(false);
                          }
                          return Container(
                          height: 100,
                          child: ProgressBar(opacity: 0));
                          }else {

                            return AppListItem(

                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _surveyInputData.list[index].priorityColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                             Text(
                                              _surveyInputData.list[index].mosqueName??"",
                                              style: AppTextStyles.cardTitle,
                                            ),

                                            Text(
                                              _surveyInputData.list[index].sequenceNo??"",
                                              style: AppTextStyles.cardSubTitle,
                                            ),
                                            if (_surveyInputData.list[index].visitfor?.toLowerCase() == 'land' &&
                                                AppUtils.isNotNullOrEmpty(_surveyInputData.list[index].landAddress))
                                              Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: Text(
                                                  "${_surveyInputData.list[index].landAddress}",
                                                  style: AppTextStyles.cardTitle.copyWith(
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            if (AppUtils.isNotNullOrEmpty(_surveyInputData.list[index].priorityValue))
                                              Padding(
                                              padding: EdgeInsets.only(top: 4),
                                              child: Text(
                                                "${'priority'.tr()}: "+(_surveyInputData.list[index].priorityValue??"").tr(),

                                                style: AppTextStyles.cardSubTitle.copyWith(
                                                  //fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),

                                            if (AppUtils.isNotNullOrEmpty(_surveyInputData.list[index].cityName))
                                              Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: Text(
                                                  _surveyInputData.list[index].cityName ?? "",
                                                  style: AppTextStyles.cardSubTitle.copyWith(
                                                   // fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),

                                            if (_surveyInputData.list[index].startDatetime != null)                                          Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: Text(
                                                  "${'start_date'.tr()}: ${DateFormat('yyyy-MM-dd HH:mm').format(_surveyInputData.list[index].startDatetime!)}",
                                                  style: AppTextStyles.cardSubTitle.copyWith(
                                                    //fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            if (_surveyInputData.list[index].visitDate != null)
                                              Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: AppListTitle2(
                                                  title: 'visit_date'.tr(),
                                                  subTitle: _surveyInputData.list[index].dateOfVisitGreg,
                                                  isDate: true,
                                                ),
                                              ),

                                            if (AppUtils.isNotNullOrEmpty(_surveyInputData.list[index].workflowState))
                                              Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: Text(
                                                  "${'stage'.tr()}:${_surveyInputData.list[index].stageName
                                                      .toString()
                                                      .capitalizeFirstLetter()}",
                                                  style: AppTextStyles.cardSubTitle.copyWith(
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Builder(
                                      builder: (context) {
                                        final survey = _surveyInputData.list[index];
                                        final bool showViewButton = (survey.workflowState ?? '').toLowerCase() != 'draft';

                                        final loggedInId = int.tryParse(loggedInEmployeeId.toString());
                                        final surveyEmployeeId = int.tryParse(survey.employeeId.toString());

                                        print("Logged-in Employee ID: $loggedInEmployeeId");

                                        List<Widget> actionButtons = [];

                                        // 🌍 View Map Button (only for land)
                                        if (survey.visitfor == 'land' &&
                                            survey.latitude != null &&
                                            survey.longitude != null) {
                                          actionButtons.add(
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 4.0),
                                              child: SecondaryOutlineButton(
                                                text: "view_map".tr(),
                                                icon: AppIcons.mosqueLocation,
                                                onTab: () async {
                                                  double latitude = survey.latitude!;
                                                  double longitude = survey.longitude!;

                                                  final googleMapsUrl = 'https://www.google.com/maps?q=$latitude,$longitude';
                                                  final appleMapsUrl = 'http://maps.apple.com/?q=$latitude,$longitude';

                                                  if (await canLaunchUrlString(googleMapsUrl)) {
                                                    await launchUrlString(googleMapsUrl);
                                                  } else if (await canLaunchUrlString(appleMapsUrl)) {
                                                    await launchUrlString(appleMapsUrl);
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text("Could not open map application")),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          );
                                        }

                                        // 👁️ View Button
                                        if (showViewButton) {
                                          actionButtons.add(
                                            AppMediumButton(
                                              title: "view".tr(),
                                              onPressed: () {
                                                final survey = _surveyInputData.list[index];


                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => SurveyView(
                                                      visitId: survey.id!,
                                                      surveyInput: survey, // assuming `survey` is of type SurveyUserInput
                                                      showDecisionButtons: true,
                                                      onCallback: () {
                                                        // Optional: add callback logic if needed
                                                        print("SurveyView callback triggered");
                                                      },
                                                    ),
                                                  ),
                                                );


                                                // Navigator.push(
                                                //   context,
                                                //   MaterialPageRoute(
                                                //     builder: (context) => WebViewScreen(
                                                //       url: survey.printUrl ?? '',
                                                //       showDecisionButtons: true,
                                                //       surveyInput: survey,
                                                //       onCallback: () => fetchSurveyVisits(true),
                                                //     ),
                                                //   ),
                                                // ).then((value) => fetchSurveyVisits(true));
                                              },
                                            ),
                                          );
                                        }
                                        // ▶️ Start Visit Button
                                        else if (surveyEmployeeId != null && surveyEmployeeId == loggedInId) {
                                          actionButtons.add(
                                            AppMediumButton(
                                              title: "start_visit".tr(),
                                              onPressed: () {
                                                final visitUrl = _surveyInputData.list[index].url ?? "";

                                                permission = GPSPermission(
                                                  allowDistance: 100,
                                                  latitude: _surveyInputData.list[index].latitude ?? 0.0,
                                                  longitude: _surveyInputData.list[index].longitude ?? 0.0,
                                                );


                                                showModalBottomSheet<bool>(
                                                  context: context,
                                                  isDismissible: false,
                                                  enableDrag: false,
                                                  builder: (context) {
                                                    return GPSPermissionBottomSheet(
                                                      permission: permission!,
                                                      onAuthorized: () {
                                                       Navigator.pop(context,true);// Close the bottom sheet
                                                      },
                                                    );
                                                  },
                                                ).then((res){
                                                    if(res==true){
                                                      openSurveyDetailPage(_surveyInputData.list[index]);
                                                    }
                                                });

                                              //  permission!.checkPermission();
                                              },


                                            ),
                                          );
                                        }

                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: actionButtons,
                                        );
                                      },
                                    )



                                  ],
                                ),
                              ),
                            );
                          }
                      },
                    ),
                  ),
                ),
              ],
            ),
            isLoading
                ? ProgressBar()
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
