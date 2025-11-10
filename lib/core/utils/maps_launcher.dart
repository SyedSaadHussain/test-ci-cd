import 'dart:io';
import 'package:url_launcher/url_launcher_string.dart';

class MapsLauncher {
  static Future<void> openMap(double? latitude, double? longitude) async {
    final lat = latitude;
    final lng = longitude;

    String url = '';
    String fallbackUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

    if (Platform.isAndroid) {
      url = 'geo:$lat,$lng?q=$lat,$lng'; // open Google Maps app
    } else if (Platform.isIOS) {
      url = 'http://maps.apple.com/?ll=$lat,$lng'; // open Apple Maps
    }

    try {
      // Directly launch without canLaunch
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error launching primary map: $e');
      try {
        await launchUrlString(fallbackUrl, mode: LaunchMode.externalApplication);
      } catch (e) {
        print('Error launching fallback map: $e');
      }
    }
  }
}