import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:html/parser.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/services/session_manager.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:http/http.dart' as http;

class OdooService {
  String _csrfToken="";
  String get csrfToken => _csrfToken;
  late CommonRepository _repository;




  void updateCsrfToken() async{
    dynamic _url="${_repository.client.baseURL}/web";
    final response = await http.get(Uri.parse(_url));
    //final response = await http.get(Uri.parse(_url),headers: headersMap);
    final document = parse(response.body);
    final metaTag = document.querySelector('script[id="web.layout.odooscript"]');
    if (metaTag != null) {
      dynamic a=metaTag!.innerHtml.split("=")[1].trim();
      String jsonString = a.replaceAllMapped(
        RegExp(r'(\w+):'), (match) => '"${match.group(1)}":',
      );
      jsonString=jsonString.replaceAll(';', '').replaceAll(RegExp(r',\s*}$'), '}');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
    
      _csrfToken = jsonMap['csrf_token'];
    } else {
    
    }
  }


  CommonRepository get repository => _repository;

  OdooService(CustomOdooClient client,{UserProfile? userProfile}) {
    _repository = CommonRepository(client,userProfile: userProfile);

  }


  Future<dynamic> getHeadersMap()  async{

    String sessionId = await SessionManager.instance.getSessionId() ?? "";
    return {
      //(Config.isDiscovery?'HEXA_S':'session_id'):  sessionId,
      'Cookie':  'session_id=${sessionId}',
      'APIAccessToken': Config.discoveryApiToken,
    };
  }

  Future<bool> authenticate(String dbName, String username, String password) async {
    return true;
    // return await _repository.authenticate(dbName, username, password);
  }

  // Future<List<dynamic>> fetchData(String modelName, List<String> fields) async {
  //   return await _repository.fetchData(modelName, fields);
  // }
}