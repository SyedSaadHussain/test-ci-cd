import 'dart:convert';

import 'package:flutter/services.dart';

class LocationService {
  static LocationService? _instance;
  static LocationService get instance => _instance ??= LocationService._();
  LocationService._();

  Map<int, String>? _regions;
  Map<int, String>? _cities;
  Map<int, String>? _centers;
  // Raw lists to enable filtering
  List<Map<String, dynamic>>? _citiesList;
  List<Map<String, dynamic>>? _centersList;

  Future<void> _loadRegions() async {
    if (_regions != null) return;

    try {
      final String jsonString = await rootBundle.loadString('assets/data/mosque/regions.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      _regions = {
        for (final item in jsonData)
          (item["id"] as int): (item["name"] as String)
      };
    } catch (e) {
      print('Error loading regions: $e');
      _regions = {};
    }
  }
  
  /// Set regions from user profile (called from outside)
  void setRegionsFromProfile(Map<int, String> regions) {
    _regions = regions;
  }
  
  /// Get full location string from IDs
  /// Returns: "حي X / مركز Y / محافظة Z / منطقة W"
  Future<String> getFullLocation({
    required int? regionId,
    required int? cityId,
    required int? centerId,
    required String districtName,
  }) async {
    // Ensure data is loaded
    await initialize();
    
    final locationParts = <String>[];
    
    // 1. District/Neighborhood (حي)
    if (districtName.isNotEmpty) {
      locationParts.add(districtName);
    }
    
    // 2. Center (مركز)
    if (centerId != null) {
      final centerName = getCenterName(centerId);
      if (centerName != null && centerName.isNotEmpty) {
        locationParts.add(centerName);
      }
    }
    
    // 3. City (محافظة)
    if (cityId != null) {
      final cityName = getCityName(cityId);
      if (cityName != null && cityName.isNotEmpty) {
        locationParts.add(cityName);
      }
    }
    
    // 4. Region (منطقة)
    if (regionId != null) {
      final regionName = getRegionName(regionId);
      if (regionName != null && regionName.isNotEmpty) {
        locationParts.add(regionName);
      }
    }
    
    return locationParts.join('/ ');
  }

  Future<void> _loadCities() async {
    if (_cities != null) return;
    
    try {
      final String jsonString = await rootBundle.loadString('assets/data/mosque/cities.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      _citiesList = jsonData.cast<Map<String, dynamic>>();
      _cities = {
        for (final item in _citiesList!)
          item["city_id"] as int: item["city_name"] as String
      };
    } catch (e) {
      print('Error loading cities: $e');
      _citiesList = <Map<String, dynamic>>[];
      _cities = {};
    }
  }

  Future<void> _loadCenters() async {
    if (_centers != null) return;
    
    try {
      final String jsonString = await rootBundle.loadString('assets/data/mosque/centers.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      _centersList = jsonData.cast<Map<String, dynamic>>();
      _centers = {
        for (final item in _centersList!)
          item["center_id"] as int: item["center_name"] as String
      };
    } catch (e) {
      print('Error loading centers: $e');
      _centersList = <Map<String, dynamic>>[];
      _centers = {};
    }
  }

  Future<void> initialize() async {
    await Future.wait([
      _loadRegions(),
      _loadCities(),
      _loadCenters(),
    ]);
  }

  String? getRegionName(int regionId) {
    return _regions?[regionId];
  }

  String? getCityName(int cityId) {
    return _cities?[cityId];
  }

  String? getCenterName(int centerId) {
    return _centers?[centerId];
  }

  /// Expose all regions from regions.json as id->name map
  Map<int, String> getAllRegionsMap() {
    return _regions ?? <int, String>{};
  }

  /// Get cities for region from local list
  List<Map<String, dynamic>> getCitiesByRegionRaw(int regionId) {
    final List<Map<String, dynamic>> source = _citiesList ?? <Map<String, dynamic>>[];
    return source
        .where((c) => (c['region_id'] as int?) == regionId)
        .map((c) => {
              'id': c['city_id'],
              'name': c['city_name'],
            })
        .toList();
  }

  /// Get centers for city from local list
  List<Map<String, dynamic>> getCentersByCityRaw(int cityId) {
    final List<Map<String, dynamic>> source = _centersList ?? <Map<String, dynamic>>[];
    return source
        .where((c) => (c['city_id'] as int?) == cityId)
        .map((c) => {
              'id': c['center_id'],
              'name': c['center_name'],
            })
        .toList();
  }

  /// Parse full_address format: "1496/2553/36936/حي عكاظ"
  /// Returns: {regionId, cityId, centerId, neighborhood}
  Map<String, dynamic> parseFullAddress(String fullAddress) {
    final parts = fullAddress.split('/');
    if (parts.length < 3) {
      return {};
    }

    try {
      final regionId = int.tryParse(parts[0]);
      final cityId = int.tryParse(parts[1]);
      final centerId = int.tryParse(parts[2]);
      final neighborhood = parts.length > 3 ? parts[3] : '';

      return {
        'regionId': regionId,
        'cityId': cityId,
        'centerId': centerId,
        'neighborhood': neighborhood,
      };
    } catch (e) {
      print('Error parsing full address: $e');
      return {};
    }
  }

  /// Get formatted location string from full_address
  Future<String> getFormattedLocation(String fullAddress) async {
    await initialize();
    
    final parsed = parseFullAddress(fullAddress);
    if (parsed.isEmpty) return fullAddress;

    final regionId = parsed['regionId'] as int?;
    final cityId = parsed['cityId'] as int?;
    final centerId = parsed['centerId'] as int?;
    final neighborhood = parsed['neighborhood'] as String? ?? '';

    final List<String> locationParts = [];

    if (neighborhood.isNotEmpty) {
      locationParts.add(neighborhood);
    }

    if (centerId != null) {
      final centerName = getCenterName(centerId);
      if (centerName != null) {
        locationParts.add(centerName);
      }
    }

    if (cityId != null) {
      final cityName = getCityName(cityId);
      if (cityName != null) {
        locationParts.add(cityName);
      }
    }

    if (regionId != null) {
      final regionName = getRegionName(regionId);
      if (regionName != null) {
        locationParts.add(regionName);
      }
    }

    return locationParts.isNotEmpty ? locationParts.join('/ ') : fullAddress;
  }
}
