import 'package:flutter/foundation.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/user_service.dart';

import '../data/repositories/electricity_repository.dart';
import '../data/services/location_service.dart';

class MosqueDetailsViewModel with ChangeNotifier {
  final ElectricityRepository repository;
  
  // Regions cache
  static final Map<int, String> _regionsCache = {};
  static bool _regionsCacheInitialized = false;

  MosqueDetailsViewModel(this.repository);

  // State
  bool isLoading = false;
  bool hasError = false;

  // Location data
  String mosqueName = '';
  String mosqueNumber = '';
  String cityName = '';
  String regionName = '';
  String centerName = '';
  String fullLocationString = '';

  /// Load mosque details by meter ID
  Future<void> loadByMeterId(int meterId) async {
    if (isLoading) return;
    
    isLoading = true;
    hasError = false;
    notifyListeners();
    
    try {
      // Initialize regions cache if needed
      await _ensureRegionsCacheInitialized();
      
      // Fetch mosque details from API
      final response = await repository.getMosqueMeterDetails(meterId: meterId);
      final data = _extractDataFromResponse(response);
      
      if (data != null) {
        await _processMosqueData(data);
      }
    } catch (e) {
      debugPrint('❌ Error loading mosque details: $e');
      hasError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Ensure regions are loaded from user profile
  Future<void> _ensureRegionsCacheInitialized() async {
    if (_regionsCacheInitialized) return;
    
    try {
      final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);
      final userService = UserService(client);
      final profile = await userService.getCachedCrmUserInfo();
      
      if (profile?.stateIds != null) {
        _regionsCache.clear();
        for (final state in profile!.stateIds!) {
          final id = state.key as int;
          final name = state.value ?? '';
          _regionsCache[id] = name;
        }
        debugPrint('✅ Loaded ${_regionsCache.length} regions to cache');
        _regionsCacheInitialized = true;
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load regions: $e');
    }
  }

  /// Extract data from API response
  Map<String, dynamic>? _extractDataFromResponse(Map<String, dynamic>? response) {
    if (response == null) return null;
    
    if (response['data'] is List && (response['data'] as List).isNotEmpty) {
      return (response['data'] as List)[0] as Map<String, dynamic>;
    } else if (response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    
    return response;
  }

  /// Process mosque data and build location string
  Future<void> _processMosqueData(Map<String, dynamic> data) async {
    mosqueName = data['mosque_name']?.toString() ?? '';
    mosqueNumber = data['mosque_number']?.toString() ?? '';
    
    // Extract location IDs and names from API
    final regionId = data['region_id'] as int?;
    final cityId = data['city_id'] as int?;
    final centerId = data['moia_center_id'] as int?;
    final districtName = data['district_name']?.toString() ?? '';
    
    // Delegate full location building to LocationService
    fullLocationString = await LocationService.instance.getFullLocation(
      regionId: regionId,
      cityId: cityId,
      centerId: centerId,
      districtName: districtName,
    );
    
    debugPrint('📍 Location: $fullLocationString');
  }

  // No longer need direct lookup helpers; using LocationService.getFullLocation()
}
