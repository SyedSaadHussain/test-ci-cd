import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/shared/widgets/ui_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mosque_management_system/core/models/survey_user_input.dart';
import 'package:mosque_management_system/data/services/survey_service.dart';

import '../../core/models/base_state.dart';
import '../../shared/widgets/dialogs/disclaimer_dialog.dart';
import '../../core/providers/user_provider.dart';



class WebViewScreen extends StatefulWidget {
  final String url;
  final bool showDecisionButtons;
  final SurveyUserInput? surveyInput;
  final Function? onCallback;




  WebViewScreen({required this.url,this.showDecisionButtons = false,this.surveyInput,this.onCallback});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}


Future<void> downloadWithSession(String url, String sessionId) async {
  final headers = {
    "Cookie": "session_id=$sessionId",
    "X-Platform-Source": "mobile",
  };

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
      webViewConfiguration: WebViewConfiguration(
        headers: headers,
      ),
    );
  } else {
    print("❌ Could not launch $url");
  }
}


class _WebViewScreenState extends BaseState<WebViewScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  late InAppWebViewController _webViewController;
  final ImagePicker _picker = ImagePicker();
  late SurveyService _surveyService;
  bool isLoading = false;


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
  void widgetInitialized() {
    super.widgetInitialized();
    _surveyService = SurveyService(appUserProvider.client!, userProfile: appUserProvider.userProfile);
  }





  @override
  void initState() {
    super.initState();
    _requestCameraPermission(); // ✅ Ask at startup
   // _surveyService = SurveyService(appUserProvider.client!, userProfile: appUserProvider.userProfile);

}



  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      if (!result.isGranted) {
        print("❌ Camera permission denied");
      } else {
        print("✅ Camera permission granted");
      }
    } else {
      print("✅ Camera permission already granted");
    }
  }
  void _setupCameraHandler() {
    _webViewController.addJavaScriptHandler(
      handlerName: 'takePhoto',
      callback: (args) async {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.rear,
          imageQuality: 80,
        );

        if (image == null) return null;

        final bytes = await image.readAsBytes();
        return 'data:image/jpeg;base64,${base64Encode(bytes)}';
      },
    );
  }




  @override
  @override
  Widget build(BuildContext context) {

    void _onLoadStop(InAppWebViewController controller, Uri? uri) async {
      final url = uri.toString();
      print("Loaded URL: $url");

      // Close WebView if URL does not contain /survey
      if (!url.contains("/survey")) {
        if (mounted) {
          Navigator.of(context).pop();
        }
        return;
      }

      _webViewController = controller;
    }

    return WillPopScope(
      onWillPop: () async {
        this.widget.onCallback!();
        return true;
        // Return false to block back navigation
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: Stack(
            children: [
              AppBackground(),
              Column(
                children: [
                  AppCustomBar(
                    title: 'visit'.tr(),
                    actions: (widget.showDecisionButtons && (widget.surveyInput?.isActionButton ?? false))
                        ? [
                      if (widget.surveyInput?.displayButtonAccept ?? false)
                        TextButton(
                          onPressed: () async {
                            print("✅ Accept clicked");
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await _surveyService.acceptSurvey(widget.surveyInput?.id ?? 0);
                              print("✅ Survey accepted");
                              confirmSendSurvey();
                              await refreshSurveyInput();
                              if (widget.onCallback != null) widget.onCallback!();
                            } catch (e) {
                              Flushbar(
                                icon: Icon(Icons.warning, color: Colors.white),
                                backgroundColor: AppColors.danger,
                                message: e.toString(),
                                duration: Duration(seconds: 3),
                              ).show(context);
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },  style: TextButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),),),

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
                              if (widget.onCallback != null) widget.onCallback!();
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),),),

                          child: Text("under_progress".tr(), style: TextStyle(color: Colors.white)),
                        ),    SizedBox(width: 12),
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

                                      // Step 1: Create the wizard
                                      final wizardId = await _surveyService.createWizard(
                                        surveyId,
                                        actionText,
                                        acceptTerms,
                                      );

                                      // Step 2: Perform action_taken on the wizard
                                      await _surveyService.performWizardAction(
                                        wizardId,
                                        surveyId,
                                      );

                                      // Step 3: Refresh UI and callback
                                      await refreshSurveyInput();
                                      if (widget.onCallback != null) {
                                        widget.onCallback!();
                                      }
                                    } catch (e) {
                                      Flushbar(
                                        message: e.toString(),
                                        backgroundColor: AppColors.danger,
                                        duration: Duration(seconds: 3),
                                      ).show(context);
                                    }
                                  }
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
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),),),


                          child: Text("action_taken".tr(), style: TextStyle(color: Colors.white)),
                        ),SizedBox(width: 12),
                    ]
                        : [],
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                      ),
                      padding: EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: _secureStorage.read(key: "sessionId"),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                          final sessionId = snapshot.data!;
                          print("🔐 Session ID from storage: $sessionId");

                          final domain = Uri.parse(widget.url).host;
                          print("🌍 Loading URL in WebView: ${widget.url}");
                          print("🌐 Domain extracted: $domain");

                          return InAppWebView(
                            // No initialUrlRequest here – we manually load the URL after cookie is set
                            initialSettings: InAppWebViewSettings(
                              javaScriptEnabled: true,
                              mediaPlaybackRequiresUserGesture: false,
                              supportZoom: false,
                              allowsInlineMediaPlayback: true,
                              useHybridComposition: true,
                              allowFileAccessFromFileURLs: true,
                              allowUniversalAccessFromFileURLs: true,
                              allowFileAccess: true,
                              allowContentAccess: true,
                            ),
                            onWebViewCreated: (controller) async {
                              _webViewController = controller;
                              _setupCameraHandler();

                              // Set session_id cookie before loading the URL
                              await CookieManager.instance().setCookie(
                                url: WebUri(widget.url),
                                name: "session_id",
                                value: sessionId,
                                domain: domain,
                                path: "/",
                                isHttpOnly: true,
                                isSecure: false,
                              );

                              // Delay to ensure cookie is saved
                              await Future.delayed(Duration(milliseconds: 300));

                              // Load the URL manually with custom header (optional)
                              await _webViewController.loadUrl(
                                urlRequest: URLRequest(
                                  url: WebUri(widget.url),
                                  headers: {
                                    'X-Platform-Source': 'mobile',
                                  },
                                ),
                              );
                            },
                            onLoadStop: (controller, url) async {
                              print("✅ Page loaded: $url");

                              // Debug: print cookies
                              final cookies = await CookieManager.instance().getCookies(url: url!);
                              for (var cookie in cookies) {
                                print(" Cookie: ${cookie.name} = ${cookie.value}");
                              }
                            },
                            onDownloadStartRequest: (controller, request) async {
                              print("📥 Download requested: ${request.url}");

                              // Ask for permission
                              final status = await Permission.manageExternalStorage.request();
                              if (!status.isGranted) {
                                print("❌ Manage external storage permission denied");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("storage_permission".tr())),
                                );
                                return;
                              }



                              final url = request.url.toString();
                              String filename = request.suggestedFilename ?? 'downloaded_file';
                              print("Mahfile:$filename");




                              final directory = Directory('/storage/emulated/0/Download');
                              final filePath = '${directory!.path}/$filename';
                              // final result = await OpenFilex.open(filePath);
                              //print("📂 File open result: ${result.message}");

                              try {
                                final client = HttpClient();
                                final httpRequest = await client.getUrl(Uri.parse(url));
                                httpRequest.headers.set('Cookie', 'session_id=$sessionId');
                                httpRequest.headers.set('X-Platform-Source', 'mobile');
                                final httpResponse = await httpRequest.close();

                                final file = File(filePath);
                                final bytes = await consolidateHttpClientResponseBytes(httpResponse);
                                await file.writeAsBytes(bytes);

                                print("✅ File saved to $filePath");
                                final result = await OpenFilex.open(filePath);
                                print("📂 File open result: ${result.message}");

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("${"file_downloaded".tr()}: $filename"),
                                ));
                              } catch (e) {
                                print("❌ Download failed: $e");
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("❌ Failed to download the file."),
                                ));
                              }
                            },
                          
                            onLoadStart: (controller, url) {
                              final currentUrl = url.toString();
                              if (currentUrl.contains('/web')) {
                                print("⚠️ Detected CRM page. Closing webview...");

                                // Show message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Page Not Available"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );

                                //Close the WebView screen
                                Future.delayed(Duration(seconds: 1), () {
                                  if (mounted) Navigator.of(context).pop();
                                });
                              }
                            },
                           // onLoadStop: _onLoadStop,

                            onPermissionRequest: (controller, request) async {
                              print("🔐 Permission requested: ${request.resources}");
                              return PermissionResponse(
                                resources: request.resources,
                                action: PermissionResponseAction.GRANT,
                              );
                            },
                            onConsoleMessage: (controller, consoleMessage) {
                              print("🧭 WebView Console: ${consoleMessage.message}");
                            },
                          );


                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
