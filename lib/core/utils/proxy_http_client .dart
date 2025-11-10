import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class CustomHttpClient {
  final String _proxy;

  CustomHttpClient(this._proxy);

  http.BaseClient createClient() {
    // Create an HttpClient with proxy settings
    HttpClient proxyClient = HttpClient();
    proxyClient.findProxy = (uri) {
      return "PROXY $_proxy";
    };
    proxyClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Allow all certificates

    // Create an IOClient using the HttpClient
    IOClient ioClient = IOClient(proxyClient);

    // Return the IOClient as a http.BaseClient
    return ioClient;
  }
}