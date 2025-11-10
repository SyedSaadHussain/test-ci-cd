import 'package:flutter/foundation.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/models/user_roles.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/features/mosque_utilities/electricity_consumption/data/services/mosque_filter_service.dart' as elec;

import '../../electricity_consumption/data/models/mosque_meter_summary.dart' show FilterOption; // reuse FilterOption model for id+name
import '../data/models/water_meter.dart';
import '../data/repositories/water_repository.dart';

enum AccessLevel {
  noAccess,
  supervisor,
  regionalManager,
  cityManager,
}

class WaterFilterProvider with ChangeNotifier {
  final UserProvider _userProvider;
  final elec.MosqueFilterService _filterService;
  final WaterRepository _waterRepository;

  WaterFilterProvider(this._userProvider, this._filterService, this._waterRepository) {
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
  List<WaterMeterSummary> _mosqueData = [];
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
  List<WaterMeterSummary> get mosqueData => _mosqueData;
  bool get isLoadingRegions => _isLoadingRegions;
  bool get isLoadingCities => _isLoadingCities;
  bool get isLoadingCenters => _isLoadingCenters;
  bool get isLoadingData => _isLoadingData;
  bool get isLoadingMore => _isLoadingMore;
  bool get isInitializing => _isInitializing;
  String? get errorMessage => _errorMessage;

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalCount => _totalCount;
  bool get hasMorePages => _currentPage < _totalPages;

  bool get canSelectRegion => _accessLevel == AccessLevel.supervisor;
  bool get canSelectCity =>
      _accessLevel != AccessLevel.noAccess &&
      (_accessLevel == AccessLevel.supervisor || _accessLevel == AccessLevel.regionalManager);
  bool get canSelectCenter => _accessLevel != AccessLevel.noAccess;

  Future<void> _initializeUserAccess() async {
    _isInitializing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userProfile = _userProvider.userProfile;
      _determineAccessLevel();
      await _setupInitialFilters();
    } catch (e) {
      _errorMessage = 'Failed to initialize filters: $e';
      _accessLevel = AccessLevel.supervisor;
      try {
        await loadAvailableRegions();
      } catch (_) {}
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  void _determineAccessLevel() {
    if (_userProfile != null) {
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
        _accessLevel = AccessLevel.noAccess;
      }
      return;
    }
    _accessLevel = AccessLevel.noAccess;
  }

  Future<void> _setupInitialFilters() async {
    switch (_accessLevel) {
      case AccessLevel.noAccess:
        _availableRegions = [];
        _availableCities = [];
        _availableCenters = [];
        _selectedRegionId = null;
        _selectedCityId = null;
        _selectedCenterId = null;
        break;
      case AccessLevel.supervisor:
        await loadAvailableRegions();
        break;
      case AccessLevel.regionalManager:
        if (_userProfile != null && (_userProfile!.stateIds?.isNotEmpty ?? false)) {
          _selectedRegionId = _userProfile!.stateIds!.first.key as int;
          final region = _userProfile!.stateIds!.first;
          _availableRegions = [FilterOption(id: region.key as int, name: region.value ?? '')];
          await loadAvailableCities();
          await loadMosqueData();
        } else {
          await loadAvailableRegions();
        }
        break;
      case AccessLevel.cityManager:
        if (_userProfile != null && (_userProfile!.stateIds?.isNotEmpty ?? false)) {
          _selectedRegionId = _userProfile!.stateIds!.first.key as int;
          final region = _userProfile!.stateIds!.first;
          _availableRegions = [FilterOption(id: region.key as int, name: region.value ?? '')];
        }
        if (_selectedRegionId == null) {
          await loadAvailableRegions();
          break;
        }
        await loadAvailableCities();
        final crmCityId = (_userProfile?.cityIds?.isNotEmpty ?? false)
            ? _userProfile!.cityIds!.first.key as int
            : null;
        if (crmCityId != null && _availableCities.any((c) => c.id == crmCityId)) {
          _selectedCityId = crmCityId;
        } else if (_availableCities.isNotEmpty) {
          _selectedCityId = _availableCities.first.id;
        }
        await loadAvailableCenters();
        await loadMosqueData();
        break;
    }
  }

  Future<void> loadAvailableRegions() async {
    if (_accessLevel == AccessLevel.noAccess) return;
    _isLoadingRegions = true;
    notifyListeners();
    try {
      final profileRegions = _userProfile?.stateIds
              ?.map((s) => FilterOption(id: s.key as int, name: s.value ?? ''))
              .toList() ??
          <FilterOption>[];
      if (profileRegions.isNotEmpty) {
        _availableRegions = profileRegions;
      } else {
        _availableRegions = await _filterService.getAvailableRegions();
      }
      if (_accessLevel != AccessLevel.supervisor && _availableRegions.isNotEmpty) {
        _selectedRegionId ??= _availableRegions.first.id;
      }
    } finally {
      _isLoadingRegions = false;
      notifyListeners();
    }
  }

  Future<void> loadAvailableCities() async {
    if (_accessLevel == AccessLevel.noAccess) return;
    if (_selectedRegionId == null) return;
    _isLoadingCities = true;
    notifyListeners();
    try {
      final cities = await _filterService.getAvailableCities(_selectedRegionId!);
      if (_accessLevel == AccessLevel.cityManager) {
        final profileCityIds = _userProfile?.cityIds?.map((c) => c.key as int).toSet() ?? <int>{};
        _availableCities = profileCityIds.isEmpty
            ? cities
            : cities.where((c) => profileCityIds.contains(c.id)).toList();
        if (_availableCities.isNotEmpty) {
          _selectedCityId ??= _availableCities.first.id;
        }
      } else {
        _availableCities = cities;
      }
      if (_selectedCity != null && !_availableCities.any((c) => c.id == _selectedCityId)) {
        _selectedCityId = null;
        _availableCenters.clear();
        _selectedCenterId = null;
      }
    } finally {
      _isLoadingCities = false;
      notifyListeners();
    }
  }

  Future<void> loadAvailableCenters() async {
    if (_accessLevel == AccessLevel.noAccess) return;
    if (_selectedRegionId == null || _selectedCityId == null) return;
    _isLoadingCenters = true;
    notifyListeners();
    try {
      _availableCenters = await _filterService.getAvailableCenters(_selectedRegionId!, _selectedCityId!);
      if (_selectedCenterId != null && !_availableCenters.any((c) => c.id == _selectedCenterId)) {
        _selectedCenterId = null;
      }
    } finally {
      _isLoadingCenters = false;
      notifyListeners();
    }
  }

  Future<void> loadMosqueData({bool reset = true}) async {
    if (_accessLevel == AccessLevel.noAccess) return;
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
      final response = await _waterRepository.getMosqueWaterSummary(
        queryParams: {
          if (_selectedRegionId != null) 'region_id': _selectedRegionId,
          if (_selectedCityId != null) 'city_id': _selectedCityId,
          if (_selectedCenterId != null) 'moia_center_id': _selectedCenterId,
          'page_no': _currentPage,
        },
      );
      if (response.isSuccess) {
        if (reset) {
          _mosqueData = response.data;
        } else {
          _mosqueData.addAll(response.data);
        }

        // Robust handling when API does not return totals
        if (response.pageCount == 0) {
          if (response.data.isEmpty) {
            // empty page means end reached
            _totalPages = _currentPage;
          } else {
            // allow at least one more load; will stop when we hit empty
            _totalPages = _currentPage + 1;
          }
          _totalCount = _mosqueData.length;
        } else {
          _totalPages = response.pageCount;
          _totalCount = response.totalCount;
        }
      } else {
        final msg = (response.message).toString().toLowerCase();
        if (msg.contains('no data')) {
          // Treat as empty state, not an error
          _mosqueData = [];
          _totalPages = 1;
          _totalCount = 0;
          _errorMessage = null;
        } else {
          _errorMessage = response.message;
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingData = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreMosqueData() async {
    if (_accessLevel == AccessLevel.noAccess) return;
    if (!hasMorePages || _isLoadingMore) return;
    _isLoadingMore = true;
    notifyListeners();
    final previous = _currentPage;
    _currentPage++;
    try {
      final response = await _waterRepository.getMosqueWaterSummary(
        queryParams: {
          if (_selectedRegionId != null) 'region_id': _selectedRegionId,
          if (_selectedCityId != null) 'city_id': _selectedCityId,
          if (_selectedCenterId != null) 'moia_center_id': _selectedCenterId,
          'page_no': _currentPage,
        },
      );

      if (!response.isSuccess) {
        final message = (response.message).toString().toLowerCase();
        if (message.contains('no data')) {
          // end of pages
          _currentPage = previous;
          _totalPages = previous;
        } else {
          throw Exception(response.message);
        }
      } else {
        _mosqueData.addAll(response.data);

        if (response.pageCount == 0) {
          if (response.data.isEmpty) {
            _totalPages = _currentPage; // reached end
          } else {
            _totalPages = _currentPage + 1; // allow another fetch
          }
          _totalCount = _mosqueData.length;
        } else {
          _totalPages = response.pageCount;
          _totalCount = response.totalCount;
        }
      }
    } catch (_) {
      _currentPage = previous;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> selectRegion(int? regionId) async {
    if (!canSelectRegion) return;
    _selectedRegionId = regionId;
    _selectedCityId = null;
    _selectedCenterId = null;
    _availableCities.clear();
    _availableCenters.clear();
    notifyListeners();
    if (regionId != null) await loadAvailableCities();
    await loadMosqueData();
  }

  Future<void> selectCity(int? cityId) async {
    if (!canSelectCity) return;
    _selectedCityId = cityId;
    _selectedCenterId = null;
    _availableCenters.clear();
    notifyListeners();
    if (cityId != null) await loadAvailableCenters();
    await loadMosqueData();
  }

  Future<void> selectCenter(int? centerId) async {
    _selectedCenterId = centerId;
    notifyListeners();
    await loadMosqueData();
  }

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
    await _setupInitialFilters();
    await loadMosqueData();
  }

  Future<void> retryInitialization() async {
    _errorMessage = null;
    await _initializeUserAccess();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

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

  FilterOption? get _selectedCity => getCityById(_selectedCityId ?? 0);
}


