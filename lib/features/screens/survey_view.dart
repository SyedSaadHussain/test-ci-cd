import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/base_state.dart';
import 'package:mosque_management_system/core/services/session_manager.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:mosque_management_system/data/services/survey_service.dart';
import 'package:mosque_management_system/shared/widgets/modal/survey_configuration.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/utils/download_and_openfile.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/utils/survey_display_helper.dart';
import 'package:mosque_management_system/shared/widgets/app_list_title.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


import '../../core/models/survey_user_input.dart';
import '../../core/models/yakeen_data.dart';
import '../../shared/widgets/dialogs/disclaimer_dialog.dart';
import '../../shared/widgets/app_form_field.dart';
import '../../shared/widgets/matrix_field_answer.dart';
import '../../shared/widgets/ui_widgets.dart';
import '../../shared/widgets/yakeen_data_table.dart';

class SurveyView extends StatefulWidget {
  final int visitId;
  final SurveyUserInput? surveyInput;
  final bool showDecisionButtons;
  final Function? onCallback;



  const SurveyView({Key? key, required this.visitId, this.surveyInput, required this.showDecisionButtons,this.onCallback}) : super(key: key);


  @override
  _SurveyViewState createState() => _SurveyViewState();
}

class _SurveyViewState extends BaseState<SurveyView> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late SurveyService _surveyService;
  //final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? _sessionId;

  List<VisitConfigurationData> visitSections = [];
  late TabController _tabController = TabController(length: 0, vsync: this);
  bool isLoading = true;
  Set<int> loadingTabs = {};

  TextStyle? labelStyle1;
  dynamic _headersMap;
  Future<void> refreshSurveyInput() async {
    final id = widget.surveyInput?.id ?? 0;
    if (id == 0) return;

    try {
      final refreshed = await _surveyService.getSurveyUserInputDetail(id);
      setState(() {
        widget.surveyInput?.updateFrom(refreshed); // you must implement this method in your model
      });
    } catch (e) {
      print("❌ Failed to refresh survey input: $e");
    }
  }

  Future<http.Response> _getImageWithSession(String url) async {
    final sessionId = await _getSessionId(); // Secure logic or from appUserProvider
    if (sessionId == null) {
      throw Exception("Session ID is null");
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Cookie': 'session_id=$sessionId',
        'X-Platform-Source': 'mobile',
      },
    );
    return response;
  }


  void confirmSendSurvey() {
    final surveyId = widget.surveyInput?.id ?? 0;
    print("📩 Sending survey with ID: $surveyId");

    setState(() {
      isLoading = true;
    });

    _surveyService.getSurveyDisclaimer(surveyId).then((result) {
      final disclaimerText = result["value"]["text"];
      print("🔍 Disclaimer payload: $result");

      showDisclaimerDialog(
        context,
        text: (disclaimerText is String && disclaimerText.isNotEmpty)
            ? disclaimerText
            : "No disclaimer available",
        onApproved: () async {
          try {
            await _surveyService.acceptTermsSurvey(surveyId);
            setState(() {
              isLoading = false;
            });

            if (widget.onCallback != null) {
              widget.onCallback!(); // ✅ Trigger the callback
            }
            Navigator.pop(context);
          } catch (e) {
            setState(() {
              isLoading = false;
            });
            Flushbar(
              icon: Icon(Icons.warning, color: Colors.white),
              backgroundColor: AppColors.danger,
              message: e.toString(),
              duration: Duration(seconds: 3),
            ).show(context);
          }
        },
      );
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      Flushbar(
        icon: Icon(Icons.warning, color: Colors.white),
        backgroundColor: AppColors.danger,
        message: e.toString(),
        duration: Duration(seconds: 3),
      ).show(context);
    });
  }

  @override
  void initState() {
    super.initState();
    labelStyle1 = TextStyle(
      color: Colors.black.withOpacity(.7),
      fontSize: 13,
      fontWeight: FontWeight.bold,
    );
    //_loadSessionId();
  }


  @override
  void widgetInitialized() async{
    super.widgetInitialized();
    _surveyService = SurveyService(appUserProvider.client!, userProfile: appUserProvider.userProfile);
    _sessionId =await SessionManager.instance.getSessionId();
    print("🟢 Loaded session ID from appUserProvider: $_sessionId");
    loadSurveyAnswers();
  }

  Future<String?> _getSessionId() async {
    final secureStorage = FlutterSecureStorage();
    String? sessionId = await secureStorage.read(key: 'sessionId');

    // Fallback to appUserProvider if not found
    sessionId ??= await SessionManager.instance.getSessionId();

    if (sessionId == null) {
      print("❌ No sessionId found in storage or appUserProvider");
    } else {
      print("🔐 sessionId loaded: $sessionId");
    }
    return sessionId;
  }



  Future<void> loadSurveyAnswers() async {
    try {
      setState(() => isLoading = true);
      print("🔵 Calling getSurveyAnswers for visitId: ${widget.visitId}");

      final rawSections = await _surveyService.getSurveyAnswers(widget.visitId);

      visitSections = rawSections.map((sec) {
        final answeredQuestions = sec.list?.where((q) => hasUserAnswer(q)).toList();

        print("➡️ Section: ${sec.sectionName}, Answered Questions: ${answeredQuestions?.length ?? 0}");

        // Keep empty sections so user can tap the tab and trigger API
        return VisitConfigurationData(
          sectionName: sec.sectionName,
          pageId: sec.pageId,
          list: answeredQuestions ?? [],
        );
      }).toList();

      print("✅ Filtered sections with answers: ${visitSections.length}");
      _tabController = TabController(length: visitSections.length+1, vsync: this);

      // Listen for tab switch
      _tabController.addListener(() {
        if (_tabController.indexIsChanging == false) {
          final currentTab = _tabController.index;
          final config = visitSections[currentTab];

          if ((config.list ?? []).isEmpty && config.pageId != null) {
            print("📥 Lazy loading pageId: ${config.pageId} for tab $currentTab...");
            loadSurveyAnswersByPageId(config.pageId.toString(), currentTab);
          }
        }
      });

    } catch (e) {
      print("❌ Error in loadSurveyAnswers: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }




  Future<void> loadSurveyAnswersByPageId(String pageId, int tabIndex) async {
    if (loadingTabs.contains(tabIndex)) return;
    loadingTabs.add(tabIndex);
    try {
     // setState(() => isLoading = true);

      final resultList = await _surveyService.getSurveyViewByPageId(widget.visitId, pageId);

      if (resultList.isNotEmpty) {
        final result = resultList.first;
        final filteredList = result.list?.where((q) => hasUserAnswer(q)).toList();



        if (filteredList != null && filteredList.isNotEmpty) {
          setState(() {
            visitSections[tabIndex] = VisitConfigurationData(
              sectionName: result.sectionName,
              pageId: result.pageId,
              list: filteredList,
            );
          });

          print("✅ Updated tab ${tabIndex} with ${filteredList.length} answered questions");
         // setState(() {}); // <-- Force rebuild
        } else {
          print("⚠️ No answered questions returned for tab $tabIndex (pageId: $pageId)");
        }
      } else {
        print("⚠️ Empty resultList from getSurveyViewByPageId()");
      }
    } catch (e) {
      print("❌ Error loading survey view by pageId: $e");
    } finally {
      if (mounted) {
        loadingTabs.remove(tabIndex); // ✅ ← HERE
        //setState(() {}); // ✅ ← Triggers tab rebuild
      }
    }
  }


  void nextTab() async {
    if (_tabController.index + 1 >= visitSections.length) return;

    int nextIndex = _tabController.index + 1;
    var currentConfig = visitSections[nextIndex];

    // Always try loading via page_id if data is empty
    if ((currentConfig.list ?? []).isEmpty && currentConfig.pageId != null) {
      print('📡 Fetching section data on demand via pageId: ${currentConfig.pageId}');
      await loadSurveyAnswersByPageId(currentConfig.pageId.toString(), nextIndex);
    }

    if ((visitSections[nextIndex].list ?? []).isNotEmpty) {
      _tabController.animateTo(nextIndex);
    } else {
      print("⚠️ No answers found for section/tab ${currentConfig.sectionName}");
    }
  }





  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        key: _scaffoldKey,
        body: isLoading
            ? ProgressBar()
            : Column(
          children: [
            // App Bar Section
            AppCustomBar(
              title: 'Survey',
              actions: (widget.showDecisionButtons && (widget.surveyInput?.isActionButton ?? false))
                  ? [
                if (widget.surveyInput?.displayButtonAccept ?? false)
                  TextButton(
                    onPressed: () async {
                      print("✅ Accept clicked");
                      setState(() => isLoading = true);
                      try {
                        await _surveyService.acceptSurvey(widget.surveyInput?.id ?? 0);
                        confirmSendSurvey();
                        await refreshSurveyInput();
                        widget.onCallback?.call();
                      } catch (e) {
                        Flushbar(
                          icon: Icon(Icons.warning, color: Colors.white),
                          backgroundColor: AppColors.danger,
                          message: e.toString(),
                          duration: Duration(seconds: 3),
                        ).show(context);
                      } finally {
                        setState(() => isLoading = false);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("accept".tr(), style: TextStyle(color: Colors.white)),
                  ),

                if (widget.surveyInput?.displayButtonUnderProgress ?? false)
                  TextButton(
                    onPressed: () async {
                      print("⏳ Under Progress clicked");
                      setState(() => isLoading = true);
                      try {
                        await _surveyService.markUnderProgress(widget.surveyInput!.id!);
                        await refreshSurveyInput();
                        widget.onCallback?.call();
                      } catch (e) {
                        Flushbar(
                          message: e.toString(),
                          backgroundColor: AppColors.danger,
                          duration: Duration(seconds: 3),
                        ).show(context);
                      } finally {
                        setState(() => isLoading = false);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.actionButtons,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("under_progress".tr(), style: TextStyle(color: Colors.white)),
                  ),
                SizedBox(width: 8),
                if (widget.surveyInput?.displayButtonAction ?? false)
                  TextButton(
                    onPressed: () async {
                      final id = widget.surveyInput?.id ?? 0;
                      if (id == 0) {
                        Flushbar(
                          message: "Invalid survey ID",
                          backgroundColor: AppColors.danger,
                          duration: Duration(seconds: 3),
                        ).show(context);
                        return;
                      }

                      setState(() => isLoading = true);

                      try {
                        final result = await _surveyService.getSurveyDisclaimer(id);
                        final rawText = result["value"]["text"];
                        final disclaimerText = rawText is String ? rawText : "No disclaimer available";

                        showDisclaimerWithInputAndToggle(
                          context,
                          disclaimerText: disclaimerText,
                          fieldLabel: "action_text".tr(),
                          validationText: "please_enter_action_taken_reason".tr(),
                          onApproved: (actionText, acceptTerms) async {
                            try {
                              final surveyId = widget.surveyInput?.id ?? 0;

                              final wizardId = await _surveyService.createWizard(
                                surveyId,
                                actionText,
                                acceptTerms,
                              );

                              await _surveyService.performWizardAction(wizardId, surveyId);
                              await refreshSurveyInput();
                              widget.onCallback?.call();
                            } catch (e) {
                              Flushbar(
                                message: e.toString(),
                                backgroundColor: AppColors.danger,
                                duration: Duration(seconds: 3),
                              ).show(context);
                            }
                          },
                        );
                      } catch (e) {
                        Flushbar(
                          message: e.toString(),
                          backgroundColor: AppColors.danger,
                          duration: Duration(seconds: 3),
                        ).show(context);
                      } finally {
                        setState(() => isLoading = false);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.actionButtons,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("action_taken".tr(), style: TextStyle(color: Colors.white)),
                  ),
                SizedBox(width: 12),
              ]
                  : [],
            ),

            // Content Section
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      isScrollable: visitSections.length > 4,
                      //isScrollable: true, // very important!
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Colors.grey,
                      indicator: BoxDecoration(
                        color: AppColors.primary.withOpacity(.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tabs: [
                        ...visitSections.map((section) => Tab(text: section.sectionName)).toList(),
                        Tab(text: "visitor_info".tr()), // ✅ Add this manually
                      ],                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // 🟢 Regular tab views
                          ...visitSections.asMap().entries.map((entry) {
                            final index = entry.key;
                            final config = entry.value;

                            if (loadingTabs.contains(index)) {
                              return Center(child: CircularProgressIndicator());
                            }

                            return ListView.builder(
                              itemCount: config.list?.length ?? 0,
                              itemBuilder: (context, index) {
                                final question = config.list![index];
                                print("🧩 Section: ${config.sectionName}");
                                print("🧪 Question: ${question.name}");
                                print("📦 Value: ${question.value}");

                                print("🚨 FINAL DEBUG: ${question.name} → isVisible: ${config.isVisibleView(question)}");


                                if (!config.isVisibleView(question)) return const SizedBox.shrink();

                                final isImageField = question.fieldType == FieldType.image;
                                final isMatrixField = question.fieldType == FieldType.matrix;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isMatrixField)
                                      Builder(
                                        builder: (context) {
                                          final values = (question.value is List &&
                                              question.value.every((e) => e is List && e.length == 2))
                                              ? List<List<dynamic>>.from(question.value)
                                              : [];

                                          return MatrixFieldAnswers(
                                            title: question.name,
                                            labelStyle: labelStyle1,
                                            horizontalOptions: question.options ?? [],
                                            verticalOptions: question.matrixOptions ?? [],
                                            values: values,
                                          );
                                        },
                                      )
                                    else if (isImageField)
                                      Builder(
                                        builder: (context) {
                                          final value = question.value;
                                          if (value is Map && value['download_url'] is String) {
                                            String url = value['download_url'];
                                            url = url.replaceAll(RegExp(r'(?<!:)//'), '/');
                                            final fileName = "file_${question.id}.jpg";

                                            return Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(question.name ?? '📷 Image'),
                                                  IconButton(
                                                    icon: const Icon(Icons.download_rounded, color: Colors.green),
                                                    onPressed: () async {
                                                      final sessionId = await _getSessionId();
                                                      if (sessionId != null) {
                                                        await downloadFileUsingHttpAndOpen(
                                                          url,
                                                          fileName: fileName,
                                                          sessionId: sessionId,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          return const SizedBox.shrink();
                                        },
                                      )
                                    else if ((question.isYakeen ?? false) &&
                                          (question.value is YakeenData || question.value is Map))
                                        Builder(
                                          builder: (context) {
                                            late final YakeenData parsedYakeen;
                                            if (question.value is YakeenData) {
                                              parsedYakeen = question.value as YakeenData;
                                            } else {
                                              final map = question.value as Map<String, dynamic>;
                                              parsedYakeen = YakeenData(
                                                nameArabic: map['nameArabic']?.toString(),
                                                nameEnglish: map['nameEnglish']?.toString(),
                                                json: map['json'] is String
                                                    ? map['json']
                                                    : jsonEncode(map['json']),
                                              );
                                            }

                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(question.name ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                const SizedBox(height: 10),
                                                YakeenDataTable(data: parsedYakeen),
                                                if ((question.isComments ?? false) &&
                                                    question.comments != null &&
                                                    question.comments.toString().isNotEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                                    child: Text(
                                                      question.comments.toString(),
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontStyle: FontStyle.italic,
                                                      ),
                                                    ),
                                                  ),
                                                const Divider(),
                                              ],
                                            );
                                          },
                                        )
                                      else
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AppListTitle2(
                                              title: question.name ?? '',
                                              subTitle: SurveyDisplayHelper.getSubtitle(question),

                                              selection: question.options,
                                            ),
                                            if ((question.isComments ?? false) &&
                                                question.comments != null &&
                                                question.comments.toString().isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                                child: Text(
                                                  question.comments.toString(),
                                                  style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            const Divider(),
                                          ],
                                        ),
                                  ],
                                );
                              },
                            );
                          }),

                          // 🟩 Append visitor info tab at the end
                          Builder(
                            builder: (_) {
                              final visitor = _surveyService.visitorInfo;

                              if (visitor.isEmpty) {
                                return Center(child: Text('no_visitor_info'.tr()));
                              }

                              return SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppListTitle2(title: "visitor_name".tr(), subTitle: visitor['Visitor'] ?? ''),
                                    AppListTitle2(title: "national_id".tr(), subTitle: visitor['nid'] ?? ''),
                                    AppListTitle2(title: "visit_end_datetime".tr(), subTitle: visitor['visit_end_datetime'] ?? ''),
                                    //AppListTitle2(title: "state".tr(), subTitle: visitor['state'] ?? ''),
                                    const SizedBox(height: 20),
                                    if ((visitor['action_text'] ?? '').toString().isNotEmpty)
                                      Text(
                                        "${'action_taken_text'.tr()}:\n${visitor['action_text']}",
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],


                    //  )     .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}