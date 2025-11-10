import 'package:flutter/foundation.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/user_service.dart';

import '../data/models/electricity_meter.dart';
import '../data/models/electricity_response.dart';
// Search now uses the same summary endpoint/response
import '../data/repositories/electricity_repository.dart';
import '../ui/widgets/search_bar_widget.dart';

class ElectricityViewModel with ChangeNotifier {

  final ElectricityRepository repository;
  late final UserService _userService;
  UserProfile? _userProfile;

  // Current filter
  int? regionId;
  int? cityId;
  int? centerId;

  // Results (summary API)
  List<ElectricityMeterSummary> summaries = [];
  int page = 1;
  int pageCount = 0;
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasError = false;
  bool isInitialized = false;

  // Search functionality (unified with summary endpoint)
  bool isSearchMode = false;
  bool isSearching = false;
  String searchQuery = '';
  SearchType searchType = SearchType.mosqueName;
  List<ElectricityMeterSummary> searchResults = [];
  Map<String, dynamic>? _activeSearchParams;

  bool get hasMorePages => page < pageCount;

  ElectricityViewModel(this.repository) {
    _initUserService();
  }

  Future<void> _initUserService() async {
    final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);
    _userService = UserService(client);
    await _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      debugPrint('🔄 [ElectricityVM] Loading user profile from cache...');
      _userProfile = await _userService.getCachedCrmUserInfo().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('⏱️ [ElectricityVM] getCachedCrmUserInfo timed out');
          return null;
        },
      );

      if (_userProfile != null) {
        debugPrint('✅ [ElectricityVM] Profile loaded successfully');
        debugPrint('📍 States: ${_userProfile!.stateIds?.map((s) => "${s.key}:${s.value}").join(", ") ?? "none"}');
        debugPrint('🏙️ Cities: ${_userProfile!.cityIds?.map((c) => "${c.key}:${c.value}").join(", ") ?? "none"}');
        
        // After profile is loaded, fetch meters with user region
        isInitialized = true;
        notifyListeners();
        debugPrint('🔄 [ElectricityVM] Loading meters with user region...');
        await loadMetersWithUserRegion().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            debugPrint('⏱️ [ElectricityVM] loadMetersWithUserRegion timed out');
          },
        );
      } else {
        debugPrint('⚠️ [ElectricityVM] No profile found, loading all meters...');
        isInitialized = true;
        notifyListeners();
        // Try to load all meters without region filter
        await loadMeters().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            debugPrint('⏱️ [ElectricityVM] loadMeters timed out');
          },
        );
      }
    } catch (e) {
      debugPrint('❌ [ElectricityVM] Error loading profile: $e');
      // Don't block - let user see UI even if profile fails
      isInitialized = true;
      notifyListeners();
    }
  }

  // Region filter
  Future<void> fetchByRegion(int id, {bool reset = false}) async {
    regionId = id;
    cityId = null;
    centerId = null;
    await _fetch({'region_id': id, 'page_no': reset ? 1 : page + 1}, reset: reset);
  }

  // City filter
  Future<void> fetchByCity(int id, {bool reset = false}) async {
    cityId = id;
    centerId = null;
    await _fetch({'city_id': id, 'page_no': reset ? 1 : page + 1}, reset: reset);
  }

  // Center filter
  Future<void> fetchByCenter(int id, {bool reset = false}) async {
    centerId = id;
    await _fetch({'moia_center_id': id, 'page_no': reset ? 1 : page + 1}, reset: reset);
  }

  Future<void> _fetch(Map<String, dynamic> queryParam, {required bool reset}) async {
    if (isLoading) return;
    isLoading = true;
    hasError = false;
    
    if (reset) {
      page = 1;
      pageCount = 0;
      summaries = [];
    }

    try {
      Map<String, dynamic> filteredQueryParam = {...queryParam};

      // Only do profile-based logic if profile is available
      if (_userProfile != null) {
        // If no filter set, use first state from user's permissions
        if (!queryParam.containsKey('region_id') && !queryParam.containsKey('city_id')) {
          if ((_userProfile!.stateIds?.isNotEmpty ?? false)) {
            filteredQueryParam['region_id'] = _userProfile!.stateIds!.first.key as int;
            debugPrint('🔍 Using default region: ${_userProfile!.stateIds!.first.key}');
          }
        }

        // Region access validation
        if (filteredQueryParam.containsKey('region_id')) {
          final regionId = filteredQueryParam['region_id'] as int;
          // Empty stateIds means access to all regions
          bool hasAccess = (_userProfile!.stateIds?.isEmpty ?? true) || 
                          (_userProfile!.stateIds?.any((state) => (state.key as int) == regionId) ?? false);
          debugPrint('🔒 Region access check ($regionId): $hasAccess');
          if (!hasAccess) {
            throw Exception('No access to region: $regionId');
          }
        }

        // City access validation
        if (filteredQueryParam.containsKey('city_id')) {
          final cityId = filteredQueryParam['city_id'] as int;
          // Empty cityIds means access to all cities in permitted regions
          bool hasAccess = (_userProfile!.cityIds?.isEmpty ?? true) || 
                          (_userProfile!.cityIds?.any((city) => (city.key as int) == cityId) ?? false);
          debugPrint('🔒 City access check ($cityId): $hasAccess');
          if (!hasAccess) {
            throw Exception('No access to city: $cityId');
          }
        }
      } else {
        debugPrint('⚠️ No user profile available, skipping access validation');
      }

      final ElectricitySummaryResponse res =
          await repository.getMosqueMeterSummary(queryParams: filteredQueryParam);
          
      if (res.isSuccess) {
        // Append items
        final int receivedCount = res.data.length;
        summaries.addAll(res.data);

        // Handle page count
        if (res.pageCount > 0) {
          pageCount = res.pageCount;
        } else {
          // Unknown total: keep a large sentinel until we hit an empty page
          if (receivedCount == 0) {
            pageCount = page; // no more pages
          } else {
            // allow more loads until an empty page signals the end
            pageCount = 10000;
          }
        }

        if (!reset) page += 1;
      }
    } catch (e) {
      hasError = true;
      debugPrint('❌ Error fetching meters: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMeters() async {
    await _fetch({'page_no': 1}, reset: true);
  }

  Future<void> loadMetersWithUserRegion() async {
    // If user has regions in their profile, use the first one as default
    if (_userProfile?.stateIds?.isNotEmpty == true) {
      regionId = _userProfile!.stateIds!.first.key as int;
      await _fetch({'region_id': regionId, 'page_no': 1}, reset: true);
    } else {
      // If no specific regions, load all
      await _fetch({'page_no': 1}, reset: true);
    }
  }

  Future<void> refreshMeters() async {
    await loadMetersWithUserRegion();
  }

  Future<void> loadMoreMeters() async {
    if (isLoadingMore || !hasMorePages) return;
    isLoadingMore = true;
    notifyListeners();
    
    try {
      Map<String, dynamic> queryParams = {'page_no': page + 1};
      if (isSearchMode && _activeSearchParams != null) {
        queryParams.addAll(_activeSearchParams!);
      } else {
        if (centerId != null) {
          queryParams['moia_center_id'] = centerId;
        } else if (cityId != null) {
          queryParams['city_id'] = cityId;
        } else if (regionId != null) {
          queryParams['region_id'] = regionId;
        } else {
          if (_userProfile?.stateIds?.isNotEmpty == true) {
            queryParams['region_id'] = _userProfile!.stateIds!.first.key as int;
          }
        }
      }

      await _fetch(queryParams, reset: false);
      if (isSearchMode) {
        searchResults = List<ElectricityMeterSummary>.from(summaries);
      }
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  // Search methods
  void setSearchMode(bool enabled) {
    isSearchMode = enabled;
    if (!enabled) {
      clearSearch();
    }
    notifyListeners();
  }

  // Convenience for UI: paginate when in search mode
  Future<void> loadMoreSearchResults() async {
    await loadMoreMeters();
  }

  void clearSearch() {
    searchQuery = '';
    searchResults = [];
    isSearchMode = false;
    _activeSearchParams = null;
    notifyListeners();
  }

  void updateSearchType(SearchType type) {
    searchType = type;
    notifyListeners();
  }

  Future<void> searchMosques(String query, {int? regionId, int? cityId, int? centerId}) async {
    // If no access enforced elsewhere, but double-guard via provided scope: require any scope
    if (regionId == null && cityId == null && centerId == null && _userProfile == null) {
      debugPrint('🚫 Search blocked: no access scope');
      return;
    }
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    searchQuery = query.trim();
    isSearching = true;
    isSearchMode = true;
    hasError = false;
    notifyListeners();

    try {
      print('🔍 Searching with type: $searchType, query: "$searchQuery"');
      // Build unified query params for summary endpoint
      final Map<String, dynamic> qp = {'page_no': 1};
      final int? activeCenterId = centerId ?? this.centerId;
      final int? activeCityId = cityId ?? this.cityId;
      final int? activeRegionId = regionId ?? this.regionId ?? (_userProfile?.stateIds?.isNotEmpty == true ? _userProfile!.stateIds!.first.key as int : null);
      if (activeCenterId != null) qp['moia_center_id'] = activeCenterId;
      if (activeCityId != null) qp['city_id'] = activeCityId;
      if (activeRegionId != null) qp['region_id'] = activeRegionId;

      switch (searchType) {
        case SearchType.meterNumber:
          qp['meter_number'] = searchQuery;
          break;
        case SearchType.serialNumber:
          qp['mosque_number'] = searchQuery;
          break;
        case SearchType.mosqueName:
          qp['mosque_name'] = searchQuery;
          break;
      }

      _activeSearchParams = Map<String, dynamic>.from(qp)..remove('page_no');
      await _fetch(qp, reset: true);
      searchResults = List<ElectricityMeterSummary>.from(summaries);
    } catch (e) {
      debugPrint('❌ Error searching mosques: $e');
      hasError = true;
      searchResults = [];
    } finally {
      isSearching = false;
      notifyListeners();
    }
  }

  // Get combined results for display (search results or regular summaries)
  List<ElectricityMeterSummary> get displayResults {
    if (isSearchMode && searchResults.isNotEmpty) {
      return searchResults;
    }
    return summaries;
  }

  // Get search results with consumption and invoice data
  List<ElectricityMeterSummary> get enrichedSearchResults => searchResults;
}