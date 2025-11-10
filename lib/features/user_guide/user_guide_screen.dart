import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:no_screenshot/no_screenshot.dart';

// Import iOS-specific WebView settings
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class UserGuideScreen extends StatefulWidget {
  const UserGuideScreen({super.key});

  @override
  State<UserGuideScreen> createState() => _UserGuideScreenState();
}

class _UserGuideScreenState extends State<UserGuideScreen> {
  late final WebViewController _controller;
  final _noScreenshot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    
    // Enable screenshot protection when entering UserGuide
    _enableScreenshotProtection();

    // Create platform-specific parameters with iOS optimizations
    late final PlatformWebViewControllerCreationParams params;
    if (Platform.isIOS) {
      // iOS-specific configuration using WKWebView with all necessary settings
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        limitsNavigationsToAppBoundDomains: false,
      );
    } else {
      // Android and other platforms
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..enableZoom(false)
      // Enable console logging for debugging navigation arrows
      ..setOnConsoleMessage((JavaScriptConsoleMessage message) {
        debugPrint('🌐 WebView Console [${message.level.name}]: ${message.message}');
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            final uri = Uri.parse(request.url);
            
            debugPrint('🔗 Navigation request: ${request.url}');
            
            // Intercept WhatsApp, phone, email, and SMS links
            if (uri.scheme == 'whatsapp' || 
                uri.scheme == 'tel' || 
                uri.scheme == 'mailto' ||
                uri.scheme == 'sms') {
              try {
                if (await canLaunchUrl(uri)) {
                  await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  // When unable to open the link
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          uri.scheme == 'whatsapp' 
                            ? 'whatsapp_not_available'.tr()
                            : 'cannot_open_link'.tr(),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } catch (e) {
                // When an error occurs
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${'error_opening_link'.tr()}: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
              // Prevent WebView from trying to load the link
              return NavigationDecision.prevent;
            }
            
            // Allow all local asset navigation (file://)
            if (uri.scheme == 'file') {
              debugPrint('✅ Allowing file:// navigation');
              return NavigationDecision.navigate;
            }
            
            // Allow all other internal navigation
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            debugPrint('📄 Page started loading: $url');
          },
          onPageFinished: (String url) async {
            debugPrint('✅ Page finished loading: $url');
            
            // iOS-specific: Inject JavaScript to fix touch events
            if (Platform.isIOS) {
              await _controller.runJavaScript('''
                // Fix iOS touch/click issues
                document.addEventListener('click', function(e) {
                  console.log('Click detected on:', e.target.tagName, e.target.href || e.target.textContent);
                }, true);
                
                // Force enable user interaction for all elements
                var style = document.createElement('style');
                style.innerHTML = '* { -webkit-user-select: auto !important; user-select: auto !important; -webkit-touch-callout: default !important; cursor: pointer !important; }';
                document.head.appendChild(style);
                
                // Ensure all links are clickable
                document.querySelectorAll('a').forEach(function(link) {
                  link.style.pointerEvents = 'auto';
                  link.style.cursor = 'pointer';
                });
                
                console.log('✅ iOS touch fixes applied');
              ''');
              debugPrint('✅ iOS JavaScript fixes injected');
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('❌ WebView error: ${error.description}');
          },
        ),
      )
      ..loadFlutterAsset('assets/userguide/index.html');

    // iOS-specific additional configuration
    if (Platform.isIOS) {
      final wkController = _controller.platform as WebKitWebViewController;
      wkController
        ..setAllowsBackForwardNavigationGestures(true)
        ..setInspectable(true); // Enable debugging in Safari
    }
  }

  // Enable screenshot protection
  Future<void> _enableScreenshotProtection() async {
    try {
      await _noScreenshot.screenshotOff();
    } catch (e) {
      debugPrint('Error enabling screenshot protection: $e');
    }
  }

  // Disable screenshot protection when leaving the screen
  Future<void> _disableScreenshotProtection() async {
    try {
      await _noScreenshot.screenshotOn();
    } catch (e) {
      debugPrint('Error disabling screenshot protection: $e');
    }
  }

  @override
  void dispose() {
    // Restore screenshot capability when leaving UserGuide
    _disableScreenshotProtection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'user_guide'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF64995F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        // Remove SafeArea padding for full WebView experience
        top: false,
        bottom: false,
        child: Platform.isIOS
            ? 
            // iOS: Wrap with gesture detector to ensure touch events work
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // This helps iOS register that the widget is interactive
                },
                child: WebViewWidget(controller: _controller),
              )
            : 
            // Android: No wrapper needed
            WebViewWidget(controller: _controller),
      ),
    );
  }
}
