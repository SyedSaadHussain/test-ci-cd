import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/search_result_model.dart';
import '../models/water_basic_info.dart';
import '../models/water_invoice.dart';
import '../models/water_response.dart';

class WaterRepository {
  final CustomOdooClient _client;

  WaterRepository(this._client);
  Future<WaterBasicInfoResponse> getWaterMeterBasicInfo({
    required int meterId,
  }) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/water/meter/basicinfo',
        {'meter_id': meterId},
      );
      return WaterBasicInfoResponse.fromJson(response);
    } catch (e) {
      print('Error fetching water meter basicinfo: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'water',
              'method': 'getWaterMeterBasicInfo',
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

  Future<WaterInvoiceResponse> getWaterLastMonthInvoice({
    required int meterId,
  }) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/water/invoice/lastmonth',
        {'meter_id': meterId},
      );
      return WaterInvoiceResponse.fromJson(response);
    } catch (e) {
      print('Error fetching water last month invoice: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'water',
              'method': 'getWaterLastMonthInvoice',
              'endpoint': '/get/crm/mosque/water/invoice/lastmonth'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return WaterInvoiceResponse.error();
    }
  }

  Future<WaterSummaryResponse> getMosqueWaterSummary({
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/water/ytd',
        queryParams ?? const {},
      );

      return WaterSummaryResponse.fromJson(response);
    } catch (e) {
      print(e);
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'water',
              'method': 'getMosqueWaterSummary',
              'endpoint': '/get/crm/mosque/water/ytd'
            });
            scope.setExtra('queryParams', queryParams);
            scope.level = SentryLevel.error;
          },
        );
      }
      return WaterSummaryResponse.error();
    }
  }

  Future<WaterMosqueSearchResponse> searchMosqueWaterMeters({
    String? meterNumber,
    String? mosqueNumber,
    String? mosqueName,
    int? regionId,
    int? cityId,
    int? centerId,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};

      if (meterNumber != null && meterNumber.isNotEmpty) {
        queryParams['meter_number'] = meterNumber;
      }
      if (mosqueNumber != null && mosqueNumber.isNotEmpty) {
        queryParams['mosque_number'] = mosqueNumber;
      }
      if (mosqueName != null && mosqueName.isNotEmpty) {
        queryParams['mosque_name'] = mosqueName;
      }

      if (regionId != null) queryParams['region_id'] = regionId;
      if (cityId != null) queryParams['city_id'] = cityId;
      if (centerId != null) queryParams['moia_center_id'] = centerId;

      final response = await _client.get(
        '/get/crm/mosque/water/ytd',
        queryParams,
      );

      return WaterMosqueSearchResponse.fromJson(response);
    } catch (e) {
      print('Error searching mosque water meters: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'water',
              'method': 'searchMosqueWaterMeters',
              'endpoint': '/get/crm/mosque/water/ytd'
            });
            scope.setExtra('meterNumber', meterNumber);
            scope.setExtra('mosqueNumber', mosqueNumber);
            scope.setExtra('mosqueName', mosqueName);
            scope.setExtra('regionId', regionId);
            scope.setExtra('cityId', cityId);
            scope.setExtra('centerId', centerId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return WaterMosqueSearchResponse.error();
    }
  }
}


