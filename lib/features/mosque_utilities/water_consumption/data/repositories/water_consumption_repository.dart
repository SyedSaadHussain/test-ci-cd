import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/water_basic_info.dart';
import '../models/water_change_ratio.dart';
import '../models/water_consumption.dart';
import '../models/water_total_consumption.dart';

class WaterConsumptionRepository {
  final CustomOdooClient _client;
  WaterConsumptionRepository(this._client);

  Future<WaterConsumptionResponse> getLastMonthConsumption({required int meterId}) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/water/meter/lastmonth/consumption',
        {'meter_id': meterId},
      );
      return WaterConsumptionResponse.fromJson(response);
    } catch (e) {
      print('Error fetching water last month consumption: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'water',
              'method': 'getLastMonthConsumption',
              'endpoint': '/get/crm/mosque/water/meter/lastmonth/consumption'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return WaterConsumptionResponse.error();
    }
  }

  Future<WaterConsumptionResponse> getThisMonthConsumption({required int meterId}) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/water/meter/thismonth/consumption',
        {'meter_id': meterId},
      );
      return WaterConsumptionResponse.fromJson(response);
    } catch (e) {
      print('Error fetching water this month consumption: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'water',
              'method': 'getThisMonthConsumption',
              'endpoint': '/get/crm/mosque/water/meter/thismonth/consumption'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return WaterConsumptionResponse.error();
    }
  }

  Future<WaterChangeRatioResponse> getMonthlyChangeRatio({required int meterId}) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/water/meter/monthly/change/ratio',
        {'meter_id': meterId},
      );
      return WaterChangeRatioResponse.fromJson(response);
    } catch (e) {
      print('Error fetching water monthly change ratio: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'water',
              'method': 'getMonthlyChangeRatio',
              'endpoint': '/get/crm/mosque/water/meter/monthly/change/ratio'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return WaterChangeRatioResponse.error();
    }
  }

  Future<WaterConsumptionResponse> getMonthlyConsumptionGraph({required int meterId}) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/water/meter/monthly/consumption/graph',
        {'meter_id': meterId},
      );
      return WaterConsumptionResponse.fromJson(response);
    } catch (e) {
      print('Error fetching water monthly consumption graph: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'water',
              'method': 'getMonthlyConsumptionGraph',
              'endpoint': '/get/crm/mosque/water/meter/monthly/consumption/graph'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return WaterConsumptionResponse.error();
    }
  }

  Future<WaterTotalConsumptionResponse> getTotalConsumption({required int meterId}) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/water/meter/total/consumption',
        {'meter_id': meterId},
      );
      return WaterTotalConsumptionResponse.fromJson(response);
    } catch (e) {
      print('Error fetching water total consumption: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'water',
              'method': 'getTotalConsumption',
              'endpoint': '/get/crm/mosque/water/meter/total/consumption'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return WaterTotalConsumptionResponse.error();
    }
  }

  Future<WaterBasicInfoResponse> getBasicInfo({required int meterId}) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/water/meter/basicinfo',
        {'meter_id': meterId},
      );
      return WaterBasicInfoResponse.fromJson(response);
    } catch (e) {
      print('Error fetching water basic info: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'water',
              'method': 'getBasicInfo',
              'endpoint': '/get/crm/mosque/water/meter/basicinfo'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return WaterBasicInfoResponse.error();
    }
  }
}
