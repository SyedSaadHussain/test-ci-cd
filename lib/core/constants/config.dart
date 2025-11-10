import 'package:mosque_management_system/core/constants/environment.dart';

class Config {
  static const bool isEnableSS =
      true; //this will enable Screenshot Default=false

  static const bool enableSentry = false; //  Set to false to disable Sentry

  static const bool disableValidation =
      true; //This bypass all validation default=false

  static const bool isProxyEnable =
      false; //enable proxy for burp suite testing default=false

  static const String playStoreLink =
      'https://emasajid.moia.gov.sa/publicfolder/MosqueAppLive.apk'; //it is used while updating android app

  static const String appleStoreLink =
      'itms-services://?action=download-manifest&url=https://services.moia.gov.sa/mosques2/mosques.plist'; //it is used while updating ios app

  static const String discoveryApiToken =
      'eb2253d3-5e18-4adc-b1db-3fd8e2e2d8fa'; // This will use in every request header except login API

  // static const String discoveryUrl = 'http://172.20.21.162:8085'; // API use for fetching multiple databases
  static const String discoveryUrl = 'https://emasajid.moia.gov.sa/';

  static const String bannerUrl =
      'http://emasajid.moia.gov.sa/MoiaEventData/api/MOIAEvent/data'; // Show banner image in production

  static const String defaultFlutterEnv = 'staging';
}


class Language {
  static const String english = "en_US";
  static const String arabic = "ar_001";
}

class TestDatabase {
  // Staging Link
  // static const String baseUrl = 'http://172.20.10.76:8069';
  // static const String dbValue="moiastage2";

  // UAT Link
  static  String baseUrl = EnvironmentConfig.baseUrl;
  static  String dbValue = EnvironmentConfig.dbValue;

  // Local DB
  // static const String baseUrl = 'http://10.0.2.2:5140';
  // static const String dbValue="moia_live";

  // Pre Production Link
  // static const String baseUrl = 'http://172.20.21.172:8069';
  // static const String dbValue = "moia_live";

  //  Production Link
  //  static const String baseUrl = 'https://discovery.moia.gov.sa';
  //  static const String dbValue="moiaLive20240423";
}

class EnvironmentConfig {
  static late String baseUrl;
  static late String dbValue;
  static late Environment envName;

  static void init(Environment env) {
    switch (env) {
      case Environment.staging:
        baseUrl = 'http://172.20.10.76:8069';
        dbValue = 'moia_live';
        envName = Environment.staging;
        break;

      case Environment.uat:
        baseUrl = 'http://172.20.10.75:8069';
        dbValue = 'moia_live';
        envName = Environment.uat;
        break;
      case Environment.preprod:
        baseUrl = 'http://172.20.21.172:8069';
        dbValue = 'moia_live';
        envName = Environment.preprod;
        break;
      case Environment.prod:
        baseUrl = 'https://discovery.moia.gov.sa';
        dbValue = 'moiaLive20240423';
        envName =  Environment.prod;
        break;
    }
  }
}


