import 'package:flutter/foundation.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/models/user_roles.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';

import '../data/models/mosque_meter_summary.dart';
import '../data/services/mosque_filter_service.dart';

enum AccessLevel {
  noAccess, // No access to any filters
  supervisor, // All regions access
  regionalManager, // One region access
  cityManager, // One city access
}

class FilterProvider with ChangeNotifier {
  final UserProvider _userProvider;
  final MosqueFilterService _filterService;

  FilterProvider(this._userProvider, this._filterService) {
    _initializeUserAccess();
  }

  // User access information
  UserProfile? _userProfile;
  AccessLevel _accessLevel = AccessLevel.supervisor;

  // Filter state
  int? _selectedRegionId;
  int? _selectedCityId;
  int? _selectedCenterId;

  // Available options
  List<FilterOption> _availableRegions = [];
  List<FilterOption> _availableCities = [];
  List<FilterOption> _availableCenters = [];

  // Data with pagination
  List<MosqueMeterSummary> _mosqueData = [];
  int _currentPage = 1;
  int _totalPages = 0;
  int _totalCount = 0;

  // Loading states
  bool _isLoadingRegions = false;
  bool _isLoadingCities = false;
  bool _isLoadingCenters = false;
  bool _isLoadingData = false;
  bool _isLoadingMore = false;
  bool _isInitializing = false;

  String? _errorMessage;

  // Getters
  AccessLevel get accessLevel => _accessLevel;

  int? get selectedRegionId => _selectedRegionId;
  int? get selectedCityId => _selectedCityId;
  int? get selectedCenterId => _selectedCenterId;

  List<FilterOption> get availableRegions => _availableRegions;
  List<FilterOption> get availableCities => _availableCities;
  List<FilterOption> get availableCenters => _availableCenters;

  List<MosqueMeterSummary> get mosqueData => _mosqueData;

  bool get isLoadingRegions => _isLoadingRegions;
  bool get isLoadingCities => _isLoadingCities;
  bool get isLoadingCenters => _isLoadingCenters;
  bool get isLoadingData => _isLoadingData;
  bool get isLoadingMore => _isLoadingMore;
  bool get isInitializing => _isInitializing;

  String? get errorMessage => _errorMessage;

  // Pagination getters
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalCount => _totalCount;
  bool get hasMorePages => _currentPage < _totalPages;

  // Access level checks
  bool get canSelectRegion => _accessLevel == AccessLevel.supervisor;
  bool get canSelectCity =>
      _accessLevel != AccessLevel.noAccess &&
      (_accessLevel == AccessLevel.supervisor ||
          _accessLevel == AccessLevel.regionalManager);
  bool get canSelectCenter => _accessLevel != AccessLevel.noAccess;

  /// Initialize user access and set up initial filters
  Future<void> _initializeUserAccess() async {
    _isInitializing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint('🔄 [FilterProvider] Starting initialization...');

      // Source profile directly from UserProvider
      _userProfile = _userProvider.userProfile;
      debugPrint('👤 UserProvider profile loaded: userId=${_userProfile?.userId}');

      print(_userProfile == null
          ? '❌ No user info available'
          : '✅ User info loaded: Regions=${_userProfile!.stateIds?.length ?? 0}, Cities=${_userProfile!.cityIds?.length ?? 0}, Roles=${_userProfile!.roleNames}');

      debugPrint('🔄 Determining access level...');
      _determineAccessLevel();

      debugPrint('🔄 Setting up initial filters for level: $_accessLevel');
      await _setupInitialFilters().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          debugPrint('⏱️ _setupInitialFilters timed out');
          throw Exception('Failed to load initial filters: timeout');
        },
      );
      // } else {
      //   // Default to supervisor access if no user info
      //   debugPrint(
      //       '⚠️ No user info available, defaulting to supervisor access');
      //   // _accessLevel = AccessLevel.cityManager;

      //   await loadAvailableRegions();
      // }
    } catch (e) {
      _errorMessage = 'Failed to initialize filters: $e';
      debugPrint('❌ Error initializing filters: $e');
      debugPrint('❌ Stack trace: ${StackTrace.current}');

      // Fallback to supervisor access and try to load basic data
      _accessLevel = AccessLevel.noAccess;
      try {
        await loadAvailableRegions();
      } catch (fallbackError) {
        debugPrint('❌ Even fallback failed: $fallbackError');
        // Set a user-friendly error message
        _errorMessage =
            'Unable to load filter data. Please check your connection and try again.';
      }
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  /// Determine access level based on user info
  void _determineAccessLevel() {
    if (_userProfile != null) {
      // Determine no-access
      final hasAnyRole = (_userProfile!.roleNames?.isNotEmpty ?? false);
      final hasAnyState = (_userProfile!.stateIds?.isNotEmpty ?? false);
      final hasAnyCity = (_userProfile!.cityIds?.isNotEmpty ?? false);

      if (!hasAnyRole && !hasAnyState && !hasAnyCity) {
        _accessLevel = AccessLevel.noAccess;
      } else if (_userProfile!.hasLevelC()) {
        _accessLevel = AccessLevel.cityManager;
      } else if (_userProfile!.hasLevelB()) {
        _accessLevel = AccessLevel.regionalManager;
      } else if (_userProfile!.hasLevelA()) {
        _accessLevel = AccessLevel.supervisor;
      } else {
        // Not in A/B/C → treat as no access
        _accessLevel = AccessLevel.noAccess;
        debugPrint('🚫 No matching role (A/B/C). Setting access to noAccess');
      }

      debugPrint('🔄 Access level determined: $_accessLevel');
      debugPrint(
          '🔄 User has ${_userProfile!.stateIds?.length ?? 0} regions, ${_userProfile!.cityIds?.length ?? 0} cities');
      debugPrint('🔄 User roles: ${_userProfile!.roleNames}');
      return;
    }

    // No profile → noAccess
    _accessLevel = AccessLevel.noAccess;
    debugPrint('🚫 No user profile. Setting access to noAccess');
  }

  /// Set up initial filters based on access level
  Future<void> _setupInitialFilters() async {
    switch (_accessLevel) {
      case AccessLevel.noAccess:
        _availableRegions = [];
        _availableCities = [];
        _availableCenters = [];
        _selectedRegionId = null;
        _selectedCityId = null;
        _selectedCenterId = null;
        debugPrint('🚫 No access: filters disabled');
        break;
      case AccessLevel.supervisor:
        await loadAvailableRegions();
        // Don't load data yet - supervisor must select a region first
        // The UI will prompt them to select filters
        debugPrint('✅ Supervisor initialized - awaiting filter selection');
        break;
      case AccessLevel.regionalManager:
        if (_userProfile != null &&
            (_userProfile!.stateIds?.isNotEmpty ?? false)) {
          _selectedRegionId = _userProfile!.stateIds!.first.key as int;
          debugPrint(
              '🔄 Set fixed region ID: $_selectedRegionId for regional manager');
          // Ensure region option exists so UI shows the name
          final region = _userProfile!.stateIds!.first;
          _availableRegions = [
            FilterOption(id: region.key as int, name: region.value ?? '')
          ];
          await loadAvailableCities();
          // Load data constrained by region
          await loadMosqueData();
        } else {
          debugPrint(
              '⚠️ Regional manager has no state IDs, falling back to supervisor mode');
          await loadAvailableRegions();
        }
        break;
      case AccessLevel.cityManager:
        // 1) Determine region from profile
        if (_userProfile != null &&
            (_userProfile!.stateIds?.isNotEmpty ?? false)) {
          _selectedRegionId = _userProfile!.stateIds!.first.key as int;
          final region = _userProfile!.stateIds!.first;
          _availableRegions = [
            FilterOption(id: region.key as int, name: region.value ?? '')
          ];
        }

        if (_selectedRegionId == null) {
          debugPrint(
              '⚠️ City manager has no region; loading regions as fallback');
          await loadAvailableRegions();
          break;
        }

        debugPrint('🔄 Fixed region for city manager: $_selectedRegionId');

        // 2) Load cities for region and set a valid city
        await loadAvailableCities();

        // Prefer city assignment if present and in list
        final crmCityId = (_userProfile?.cityIds?.isNotEmpty ?? false)
            ? _userProfile!.cityIds!.first.key as int
            : null;
        if (crmCityId != null &&
            _availableCities.any((c) => c.id == crmCityId)) {
          _selectedCityId = crmCityId;
          debugPrint(
              '🔄 Using profile city for city manager: $_selectedCityId');
        } else if (_availableCities.isNotEmpty) {
          _selectedCityId = _availableCities.first.id;
          debugPrint(
              '🔄 Using first available city for city manager: $_selectedCityId');
        } else {
          debugPrint(
              '⚠️ No cities available for region=$_selectedRegionId; loading data by region only');
          await loadMosqueData();
          break;
        }

        // 3) Load centers after city is set
        await loadAvailableCenters();
        await loadMosqueData();
        break;
    }
  }

  /// Load available regions from service
  Future<void> loadAvailableRegions() async {
    if (_accessLevel == AccessLevel.noAccess) {
      debugPrint('🚫 Skipping regions load: no access');
      return;
    }
    _isLoadingRegions = true;
    notifyListeners();

    try {
      // Always use profile regions (supervisors have all regions in their profile)
      final profileRegions = _userProfile?.stateIds
              ?.map((s) => FilterOption(id: s.key as int, name: s.value ?? ''))
              .toList() ??
          <FilterOption>[];

      if (profileRegions.isNotEmpty) {
        _availableRegions = profileRegions;
      } else {
        // Fallback: try to load from API if profile has no regions
        debugPrint('⚠️ No regions in profile, trying API fallback...');
        try {
          _availableRegions = await _filterService.getAvailableRegions();
        } catch (apiError) {
          debugPrint('❌ API fallback also failed: $apiError');
          _availableRegions = [];
        }
      }

      // For non-supervisors, pre-select first region
      if (_accessLevel != AccessLevel.supervisor &&
          _availableRegions.isNotEmpty) {
        _selectedRegionId ??= _availableRegions.first.id;
      }

      debugPrint(
          '✅ Loaded ${_availableRegions.length} regions (level=$_accessLevel)');
    } catch (e) {
      _errorMessage = 'Failed to load regions: $e';
      debugPrint('❌ Error loading regions: $e');
    } finally {
      _isLoadingRegions = false;
      notifyListeners();
    }
  }

  /// Load available cities for selected region
  Future<void> loadAvailableCities() async {
    if (_accessLevel == AccessLevel.noAccess) return;
    if (_selectedRegionId == null) return;

    _isLoadingCities = true;
    notifyListeners();

    try {
      final cities =
          await _filterService.getAvailableCities(_selectedRegionId!);

      if (_accessLevel == AccessLevel.cityManager) {
        final profileCityIds =
            _userProfile?.cityIds?.map((c) => c.key as int).toSet() ?? <int>{};
        _availableCities = profileCityIds.isEmpty
            ? cities
            : cities.where((c) => profileCityIds.contains(c.id)).toList();
        if (_availableCities.isNotEmpty) {
          _selectedCityId ??= _availableCities.first.id;
        }
      } else {
        _availableCities = cities;
      }

      debugPrint(
          '✅ Loaded ${_availableCities.length} cities for region $_selectedRegionId (level=$_accessLevel)');

      // Clear selected city if it's not in the new list
      if (_selectedCity != null &&
          !_availableCities.any((city) => city.id == _selectedCityId)) {
        _selectedCityId = null;
        _availableCenters.clear();
        _selectedCenterId = null;
      }
    } catch (e) {
      _errorMessage = 'Failed to load cities: $e';
      debugPrint('❌ Error loading cities: $e');
    } finally {
      _isLoadingCities = false;
      notifyListeners();
    }
  }

  /// Load available centers for selected city
  Future<void> loadAvailableCenters() async {
    if (_accessLevel == AccessLevel.noAccess) return;
    if (_selectedRegionId == null || _selectedCityId == null) return;

    _isLoadingCenters = true;
    notifyListeners();

    try {
      _availableCenters = await _filterService.getAvailableCenters(
          _selectedRegionId!, _selectedCityId!);
      debugPrint(
          '✅ Loaded ${_availableCenters.length} centers for city $_selectedCityId');

      // Clear selected center if it's not in the new list
      if (_selectedCenterId != null &&
          !_availableCenters.any((center) => center.id == _selectedCenterId)) {
        _selectedCenterId = null;
      }
    } catch (e) {
      _errorMessage = 'Failed to load centers: $e';
      debugPrint('❌ Error loading centers: $e');
    } finally {
      _isLoadingCenters = false;
      notifyListeners();
    }
  }

  /// Load mosque data based on current filters (resets pagination)
  Future<void> loadMosqueData({bool reset = true}) async {
    if (_accessLevel == AccessLevel.noAccess) {
      debugPrint('🚫 Skipping data load: no access');
      return;
    }
    if (reset) {
      _currentPage = 1;
      _mosqueData.clear();
      _totalPages = 0;
      _totalCount = 0;
    }

    _isLoadingData = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint('📄 [FilterProvider] Loading page $_currentPage...');
      
      final response = await _filterService.getMosqueData(
        regionId: _selectedRegionId,
        cityId: _selectedCityId,
        centerId: _selectedCenterId,
        pageNo: _currentPage,
        pageSize: 50,
      );

      // Treat "No data found" as a valid empty response (end of list)
      if (response.status != 200) {
        final message = (response.message).toString().toLowerCase();
        if (message.contains('no data found')) {
          _mosqueData = [];
          _totalPages = 1;
          _totalCount = 0;
          debugPrint('ℹ️ [FilterProvider] No data for current filters.');
          return;
        } else {
          throw Exception(response.message);
        }
      }

      if (reset) {
        _mosqueData = response.data.data;
      } else {
        _mosqueData.addAll(response.data.data);
      }

      // Handle APIs that don't return pagination totals
      if (response.data.pageCount == 0) {
        // Infer next-page availability: empty page => last page
        if (response.data.data.isEmpty) {
          _totalPages = _currentPage;
        } else {
          // Assume there may be at least one more page
          _totalPages = _currentPage + 1;
        }
        // If API doesn't provide totalCount, keep a running count fallback
        _totalCount = _mosqueData.length;
      } else {
        _totalPages = response.data.pageCount;
        _totalCount = response.data.totalCount;
      }

      debugPrint(
          '✅ [FilterProvider] Loaded ${response.data.data.length} mosques (page $_currentPage/$_totalPages, total: $_totalCount)');
      debugPrint(
          '📄 [FilterProvider] Has more pages: $hasMorePages');
    } catch (e) {
      _errorMessage = 'Failed to load mosque data: $e';
      debugPrint('❌ [FilterProvider] Error loading mosque data: $e');
    } finally {
      _isLoadingData = false;
      notifyListeners();
    }
  }

  /// Load more mosque data (next page)
  Future<void> loadMoreMosqueData() async {
    if (_accessLevel == AccessLevel.noAccess) {
      debugPrint('🚫 [FilterProvider] Cannot load more: no access');
      return;
    }

    if (!hasMorePages) {
      debugPrint('⚠️ [FilterProvider] No more pages to load (current: $_currentPage, total: $_totalPages)');
      return;
    }

    if (_isLoadingMore) {
      debugPrint('⚠️ [FilterProvider] Already loading more data');
      return;
    }

    _isLoadingMore = true;
    _errorMessage = null;
    final previousPage = _currentPage;
    _currentPage++;
    notifyListeners();

    try {
      debugPrint('📄 [FilterProvider] Loading page $_currentPage/$_totalPages...');
      
      final response = await _filterService.getMosqueData(
        regionId: _selectedRegionId,
        cityId: _selectedCityId,
        centerId: _selectedCenterId,
        pageNo: _currentPage,
        pageSize: 50,
      );

      // Treat "No data found" as normal end of pagination
      if (response.status != 200) {
        final message = (response.message).toString().toLowerCase();
        if (message.contains('no data found')) {
          _currentPage = previousPage; // revert increment
          _totalPages = previousPage; // mark end
          debugPrint('ℹ️ [FilterProvider] Reached end of pages.');
          return;
        } else {
          throw Exception(response.message);
        }
      }

      _mosqueData.addAll(response.data.data);
      if (response.data.pageCount == 0) {
        if (response.data.data.isEmpty) {
          _totalPages = _currentPage; // reached the end
        } else {
          _totalPages = _currentPage + 1; // allow another fetch
        }
        _totalCount = _mosqueData.length;
      } else {
        _totalPages = response.data.pageCount;
        _totalCount = response.data.totalCount;
      }

      debugPrint(
          '✅ [FilterProvider] Loaded ${response.data.data.length} more mosques (page $_currentPage/$_totalPages, total items: ${_mosqueData.length}/$_totalCount)');
    } catch (e) {
      _errorMessage = 'Failed to load more mosque data: $e';
      debugPrint('❌ [FilterProvider] Error loading page $_currentPage: $e');
      _currentPage = previousPage; // Revert page increment on error
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Select region (Supervisor only)
  Future<void> selectRegion(int? regionId) async {
    if (!canSelectRegion) return;

    _selectedRegionId = regionId;
    _selectedCityId = null;
    _selectedCenterId = null;
    _availableCities.clear();
    _availableCenters.clear();

    notifyListeners();

    if (regionId != null) {
      await loadAvailableCities();
    }
    await loadMosqueData();
  }

  /// Select city (Supervisor and Regional Manager)
  Future<void> selectCity(int? cityId) async {
    if (!canSelectCity) return;

    _selectedCityId = cityId;
    _selectedCenterId = null;
    _availableCenters.clear();

    notifyListeners();

    if (cityId != null) {
      await loadAvailableCenters();
    }
    await loadMosqueData();
  }

  /// Select center (All access levels)
  Future<void> selectCenter(int? centerId) async {
    _selectedCenterId = centerId;
    notifyListeners();
    await loadMosqueData();
  }

  /// Reset all filters
  Future<void> resetFilters() async {
    _selectedRegionId = null;
    _selectedCityId = null;
    _selectedCenterId = null;
    _availableRegions.clear();
    _availableCities.clear();
    _availableCenters.clear();
    _mosqueData.clear();
    _currentPage = 1;
    _totalPages = 0;
    _totalCount = 0;
    _errorMessage = null;

    notifyListeners();

    try {
      await _setupInitialFilters();
      await loadMosqueData();
    } catch (e) {
      _errorMessage = 'Failed to reset filters: $e';
      debugPrint('❌ Error resetting filters: $e');
      notifyListeners();
    }
  }

  /// Retry initialization - useful for the retry button
  Future<void> retryInitialization() async {
    debugPrint('🔄 Retrying filter initialization...');
    _errorMessage = null;
    await _initializeUserAccess();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Get filter option by ID
  FilterOption? getRegionById(int id) {
    try {
      return _availableRegions.firstWhere((region) => region.id == id);
    } catch (e) {
      return null;
    }
  }

  FilterOption? getCityById(int id) {
    try {
      return _availableCities.firstWhere((city) => city.id == id);
    } catch (e) {
      return null;
    }
  }

  FilterOption? getCenterById(int id) {
    try {
      return _availableCenters.firstWhere((center) => center.id == id);
    } catch (e) {
      return null;
    }
  }

  // Helper getter for UI
  FilterOption? get _selectedCity => getCityById(_selectedCityId ?? 0);
}
