import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/electricity_response.dart';
import '../models/search_result_model.dart';

class ElectricityRepository {
  final CustomOdooClient _client;

  ElectricityRepository(this._client);

  Future<Map<String, dynamic>?> getMosqueMeterDetail(
      {required int meterId}) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/meter/detail',
        {'meter_id': meterId},
      );
      return response['data'] is Map ? response['data'] : null;
    } catch (e) {
      print(e);
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'electricity',
              'method': 'getMosqueMeterDetail',
              'endpoint': '/get/crm/mosque/meter/detail'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return null;
    }
  }

  Future<ElectricitySummaryResponse> getMosqueMeterSummary({
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/electricity/meter/ytd',
        queryParams ?? const {},
      );

      return ElectricitySummaryResponse.fromJson(response);
    } catch (e) {
      print(e);
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'electricity',
              'method': 'getMosqueMeterSummary',
              'endpoint': '/get/crm/mosque/electricity/meter/ytd'
            });
            scope.setExtra('queryParams', queryParams);
            scope.level = SentryLevel.error;
          },
        );
      }
      return ElectricitySummaryResponse.error();
    }
  }

  Future<Map<String, dynamic>?> getMosqueMeterDetails({
    required int meterId,
  }) async {
    try {
      // Try the basic info endpoint first
      final response = await _client.get(
        '/get/crm/mosque/meter/basic/info',
        {'meter_id': meterId},
      );
      return response;
    } catch (e) {
      // Fallback to the detail endpoint
      print('Error fetching mosque meter details: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'electricity',
              'method': 'getMosqueMeterDetails',
              'endpoint': '/get/crm/mosque/meter/basic/info'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
    }
    return null;
  }

  Future<MosqueSearchResponse> searchMosqueElectricityMeters({
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
        // Try the most common parameter name for mosque name search
        // Based on your observation that mosque_number search works with mosque names,
        // let's test if the API uses a different parameter name
        queryParams['mosque_name'] = mosqueName;
      }

      // Scope search by user's allowed location if provided
      if (centerId != null) {
        queryParams['moia_center_id'] = centerId;
      } else if (cityId != null) {
        queryParams['city_id'] = cityId;
      } else if (regionId != null) {
        queryParams['region_id'] = regionId;
      }

      print('🔍 Search API called with params: $queryParams');
      final response = await _client.get(
        '/get/crm/mosque/electricity/meter/ytd',
        queryParams,
      );
      print(
          '🔍 Search API response status: ${response['status']}, data count: ${response['data']?.length ?? 0}');

      final searchResponse = MosqueSearchResponse.fromJson(response);

      // If mosque name search returns no results, try alternative parameter names
      if (mosqueName != null &&
          mosqueName.isNotEmpty &&
          searchResponse.data.isEmpty) {
        print(
            '🔍 Mosque name search returned no results, trying alternative parameter names...');

        // Try with 'name' parameter
        final altParams1 = {'name': mosqueName};
        print('🔍 Trying with name parameter: $altParams1');
        final altResponse1 = await _client.get(
          '/get/crm/mosque/electricity/meter/ytd',
          altParams1,
        );

        if (altResponse1['data']?.isNotEmpty == true) {
          print('🔍 Found results with "name" parameter!');
          return MosqueSearchResponse.fromJson(altResponse1);
        }

        // Try with 'mosque' parameter
        final altParams2 = {'mosque': mosqueName};
        print('🔍 Trying with mosque parameter: $altParams2');
        final altResponse2 = await _client.get(
          '/get/crm/mosque/electricity/meter/ytd',
          altParams2,
        );

        if (altResponse2['data']?.isNotEmpty == true) {
          print('🔍 Found results with "mosque" parameter!');
          return MosqueSearchResponse.fromJson(altResponse2);
        }
      }

      return searchResponse;
    } catch (e) {
      print('Error searching mosque electricity meters: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'electricity',
              'method': 'searchMosqueElectricityMeters',
              'endpoint': '/get/crm/mosque/electricity/meter/ytd'
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
      return MosqueSearchResponse.error();
    }
  }
}
