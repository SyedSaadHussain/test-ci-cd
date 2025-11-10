import 'package:mosque_management_system/core/constants/config.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../../data/services/custom_odoo_client.dart';
import '../models/meter_change_ratio.dart';
import '../models/meter_consumption.dart';

class MeterConsumptionRepository {
  final CustomOdooClient _client;

  MeterConsumptionRepository(this._client);

  Future<MeterConsumption> getThisMonthConsumption(int meterId) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/meter/this/month/consumption',
        {'meter_id': meterId},
      );

      // Handle successful response with data
      if (response['status'] == 200 &&
          response['data'] is List &&
          response['data'].isNotEmpty &&
          response['data'][0] is Map) {
        return MeterConsumption.fromJson(response['data'][0]);
      }

      // Return empty consumption for no data or error
      return MeterConsumption.empty(meterId);
    } catch (e) {
      print('Error getting this month consumption: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'electricity',
              'method': 'getThisMonthConsumption',
              'endpoint': '/get/crm/mosque/meter/this/month/consumption'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return MeterConsumption.empty(meterId);
    }
  }

  Future<MeterConsumption> getLastMonthConsumption(int meterId) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/meter/last/month/consumption',
      {'meter_id': meterId},
      );

      // Handle successful response with data
      if (response['status'] == 200 &&
          response['data'] is List &&
          response['data'].isNotEmpty &&
          response['data'][0] is Map) {
        return MeterConsumption.fromJson(response['data'][0]);
      }

      // Return empty consumption for no data or error
      return MeterConsumption.empty(meterId);
    } catch (e) {
      print('Error getting last month consumption: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'electricity',
              'method': 'getLastMonthConsumption',
              'endpoint': '/get/crm/mosque/meter/last/month/consumption'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return MeterConsumption.empty(meterId);
    }
  }

  Future<MeterConsumption> getTotalConsumption(int meterId) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/meter/total/consumption',
         {'meter_id': meterId},
      );

      // Handle successful response with data
      if (response['status'] == 200 &&
          response['data'] is List &&
          response['data'].isNotEmpty &&
          response['data'][0] is Map) {
        return MeterConsumption.fromJson(response['data'][0]);
      }

      // Return empty consumption for no data or error
      return MeterConsumption.empty(meterId);
    } catch (e) {
      print('Error getting total consumption: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'electricity',
              'method': 'getTotalConsumption',
              'endpoint': '/get/crm/mosque/meter/total/consumption'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return MeterConsumption.empty(meterId);
    }
  }

  Future<List<MeterConsumption>> getMonthlyConsumptionGraph(int meterId) async {
    try {
      // Temporarily using meter_id=9 for testing
      final response = await _client.get(
        '/get/crm/mosque/meter/monthly/consumption/graph',
        {'meter_id': meterId},
      );

      if (response['status'] == 200 && response['data'] is List) {
        final data = response['data'] as List;
        return data.map((item) => MeterConsumption.fromJson(item)).toList();
      }

      return [];
    } catch (e) {
      print('Error getting monthly consumption graph: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'electricity',
              'method': 'getMonthlyConsumptionGraph',
              'endpoint': '/get/crm/mosque/meter/monthly/consumption/graph'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return [];
    }
  }

  Future<MeterChangeRatio> getMonthlyConsumptionChangeRatio(int meterId) async {
    try {
      // temporarily using meter_id=9 for testing
      final response = await _client.get(
        '/get/crm/mosque/meter/monthly/consumption/change/ratio/graph',
       {'meter_id': meterId},
      );

      // Handle successful response with data
      if (response['status'] == 200 &&
          response['data'] is List &&
          response['data'].isNotEmpty &&
          response['data'][0] is Map) {
        return MeterChangeRatio.fromJson(response['data'][0]);
      }

      // Return empty change ratio for no data or error
      return MeterChangeRatio.empty(meterId);
    } catch (e) {
      print('Error getting monthly consumption change ratio: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'electricity',
              'method': 'getMonthlyConsumptionChangeRatio',
              'endpoint': '/get/crm/mosque/meter/monthly/consumption/change/ratio/graph'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return MeterChangeRatio.empty(meterId);
    }
  }

  Future<MeterChangeRatio> getMonthlyAmountChangeRatio(int meterId) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/meter/monthly/amount/change/ratio/graph',
         {'meter_id': meterId},
      );

      // Handle successful response with data
      if (response['status'] == 200 &&
          response['data'] is List &&
          response['data'].isNotEmpty &&
          response['data'][0] is Map) {
        return MeterChangeRatio.fromJson(response['data'][0]);
      }

      // Return empty change ratio for no data or error
      return MeterChangeRatio.empty(meterId);
    } catch (e) {
      print('Error getting monthly amount change ratio: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'electricity',
              'method': 'getMonthlyAmountChangeRatio',
              'endpoint': '/get/crm/mosque/meter/monthly/amount/change/ratio/graph'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return MeterChangeRatio.empty(meterId);
    }
  }
}
