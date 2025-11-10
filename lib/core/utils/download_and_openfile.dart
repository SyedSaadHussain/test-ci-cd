import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;


Future<void> downloadFileUsingHttpAndOpen(String url, {String? fileName, String? sessionId}) async {
  http.Client client = http.Client();

  try {
    // 1. Ask for storage permission
    if (Platform.isAndroid) {
      if (await _requestStoragePermission() == false) {
        throw Exception("Storage permission not granted");
      }
    }

    // 2. Create request using session
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Cookie': 'session_id=$sessionId',
        'X-Platform-Source': 'mobile',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to download file');
    }

    // 3. Save file
    final dir = await getApplicationDocumentsDirectory();
    final uriSegments = Uri.parse(url).pathSegments;
    final dynamicName = uriSegments.length >= 2
        ? "${uriSegments[uriSegments.length - 2]}_${uriSegments.last}"
        : "downloaded_file";

    final name = fileName ?? dynamicName;
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(response.bodyBytes);

    print("✅ File downloaded: ${file.path}");

    // 4. Open file
    final result = await OpenFilex.open(file.path);
    print("📂 OpenFilex: ${result.message}");
  } catch (e) {
    print("❌ Error in download or open: $e");
  } finally {
    client.close();
  }
}
Future<bool> _requestStoragePermission() async {
  if (Platform.isAndroid) {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    int sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      var photos = await Permission.photos.status;
      if (!photos.isGranted) {
        photos = await Permission.photos.request();
      }
      return photos.isGranted;
    } else {
      var storage = await Permission.storage.status;
      if (!storage.isGranted) {
        storage = await Permission.storage.request();
      }
      return storage.isGranted;
    }
  } else {
    return true; // iOS and others
  }
}
