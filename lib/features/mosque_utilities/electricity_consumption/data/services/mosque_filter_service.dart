import 'package:flutter/foundation.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';

import '../models/mosque_meter_summary.dart';
import 'location_service.dart';

class MosqueFilterService {
  final CustomOdooClient _client;

  MosqueFilterService(this._client);

  /// Fetch mosque data from API with pagination support
  Future<MosqueMeterSummaryResponse> getMosqueData({
    int? regionId,
    int? cityId,
    int? centerId,
    int pageNo = 1,
    int pageSize = 50,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page_no': pageNo,
      };
      
      if (regionId != null) queryParams['region_id'] = regionId;
      if (cityId != null) queryParams['city_id'] = cityId;
      if (centerId != null) queryParams['moia_center_id'] = centerId;

      debugPrint('📄 [Pagination] Loading page $pageNo with filters: region=$regionId, city=$cityId, center=$centerId');

      final response = await _client.get(
        '/get/crm/mosque/electricity/meter/ytd',
        queryParams,
      );

      final result = MosqueMeterSummaryResponse.fromJson(response);
      
      debugPrint('📄 [Pagination] Page $pageNo loaded: ${result.data.data.length} items, Total: ${result.data.totalCount}, Pages: ${result.data.pageCount}');
      
      return result;
    } catch (e) {
      debugPrint('❌ [Pagination] API call error: $e');
      return MosqueMeterSummaryResponse(
        status: 500,
        message: 'API call failed: $e',
        data: MosqueMeterSummaryData(data: [], pageCount: 0, totalCount: 0),
      );
    }
  }

  /// Get available regions from API (via CustomOdooClient)
  Future<List<FilterOption>> getAvailableRegions() async {
    try {
      // Call the API to get all regions
      final response = await _client.get('/get/crm/regions', {});
      
      if (response['status'] == 200) {
        final List<dynamic> regions = response['data'] ?? [];
        return regions
            .map((r) => FilterOption(
                  id: r['id'] as int,
                  name: r['name'] as String,
                ))
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
      } else {
        debugPrint('⚠️ Failed to load regions from API, returning empty list');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Error getting regions from API: $e');
      // Return empty list instead of rethrowing to prevent crashes
      return [];
    }
  }

  /// Get available cities for region
  Future<List<FilterOption>> getAvailableCities(int regionId) async {
    try {
      // Initialize location service to load names
      await LocationService.instance.initialize();
      // Use local cities.json filtered by region
      final raw = LocationService.instance.getCitiesByRegionRaw(regionId);
      final options = raw
          .map((c) => FilterOption(id: c['id'] as int, name: c['name'] as String))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      return options;
    } catch (e) {
      debugPrint('❌ Error getting cities: $e');
      rethrow;
    }
  }

  /// Get available centers for city
  Future<List<FilterOption>> getAvailableCenters(int regionId, int cityId) async {
    try {
      // Initialize location service to load names
      await LocationService.instance.initialize();
      // Use local centers.json filtered by city
      final raw = LocationService.instance.getCentersByCityRaw(cityId);
      final options = raw
          .map((c) => FilterOption(id: c['id'] as int, name: c['name'] as String))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      return options;
    } catch (e) {
      debugPrint('❌ Error getting centers: $e');
      rethrow;
    }
  }
}
