import 'dart:async';

import 'package:dio/dio.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NetworkErrorHandler {
  static String? getMessage(dynamic e,{bool hideTimeOut=false}) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return hideTimeOut?null:"no_internet".tr();
        default:
          if (e.error != null) {
            return e.error.toString();
          }
          return e.toString();
      }
    } else if (e is TimeoutException) {
      return  "no_internet".tr();
    } else {
      // 👇 Try to read .message if available, else fallback
      try {
        final msg = (e as dynamic).message;
        if (msg != null) {
          return msg.toString();
        }
      } catch (_) {}
      return "$e";
    }
  }
}