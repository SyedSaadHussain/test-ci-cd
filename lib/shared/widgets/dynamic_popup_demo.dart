import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/config.dart';

class DynamicPopUpDemo extends StatefulWidget {
  @override
  _DynamicPopUpDemoState createState() => _DynamicPopUpDemoState();
}

class _DynamicPopUpDemoState extends State<DynamicPopUpDemo> {
  String? imageUrl;
  int countdown = 9;
  Timer? _timer;
  late ValueNotifier<double> _scaleNotifier;
  late ValueNotifier<Offset> _offsetNotifier;

  @override
  void initState() {
    super.initState();
    _fetchEventData();
    // Initialize the value notifiers for scale and offset
    _scaleNotifier = ValueNotifier<double>(1.0);
    _offsetNotifier = ValueNotifier<Offset>(Offset(0, 0));

  }

  Future<void> _fetchEventData() async {
    final String apiUrl =
        Config.bannerUrl;

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'User-Agent':
          'Mozilla/5.0 (Linux; Android 12; Emulator) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.87 Mobile Safari/537.36',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> dataList = responseData['data'];

          if (dataList.isNotEmpty && dataList[0].containsKey('imageURL')) {
            final String url = dataList[0]['imageURL'];

            if (url.isNotEmpty) {
              if (mounted) {
                setState(() {
                  imageUrl = url;
                });
                Future.delayed(Duration(milliseconds: 300), () {
                  if (mounted) _showPopUp();
                });
              }
              return;
            }
          }
        }
      }
    } catch (error) {
      print('Error fetching data: $error');
    }

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(
          '/dashboard');
    }
  }

  void _showPopUp() {
    if (imageUrl == null || imageUrl!.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            if (_timer == null || !_timer!.isActive) {
              _startCountdown(setDialogState); // Start countdown only once
            }

            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: Text('Error loading image'),
                          );
                        },
                      ),
                      TextButton(
                        onPressed: _closePopUp,
                        child: Text(
                          'close'.tr(),
                          style: TextStyle(color: Colors.green,
                           fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // "X" Close Button on Top-Left
                  Positioned(
                    top: 5,
                    left: 5,
                    child: GestureDetector(
                      onTap: _closePopUp,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // Countdown Timer on Top-Right
                  // Countdown Timer on Top-Right
                  // Countdown Timer on Top-Right
                  Positioned(
                    top: 5,
                    right: 10,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500), // Animation duration for smooth transition
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          scale: animation, // Zoom effect
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, -0.5), // Move down slightly
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        '$countdown', // Only numbers
                        key: ValueKey<int>(countdown), // Ensure animation runs on countdown change
                        style: TextStyle(
                          color: Colors.green, // Green color for text
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // Font size 16
                        ),
                      ),
                    ),
                  ),



                ],
              ),
            );
          },
        );
      },
    );
  }

  void _startCountdown(Function setDialogState) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setDialogState(() {
          countdown--;
        });
        _scaleNotifier.value = 1.0 + (countdown * 0.1); // Zoom in
        _offsetNotifier.value = Offset(0, countdown % 2 == 0 ? 5.0 : -5.0);
      } else {
        _closePopUp();
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      }
    });
  }

  void _closePopUp() {
    _timer?.cancel();
    _timer = null;
    if (mounted) {
      Navigator.of(context).pop(); // Close the pop-up
      Navigator.of(context).pushReplacementNamed('/dashboard'); // Navigate to the dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      Future.microtask(() => Navigator.of(context).pushNamed('/dashboard'));
      return Scaffold(); // Return an empty scaffold to prevent errors
    }
    return Scaffold(
      appBar: AppBar(title: Text('Mosque Management App')),
      body: SafeArea(
        child: Center(
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Text('Error loading image');
            },
          )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
