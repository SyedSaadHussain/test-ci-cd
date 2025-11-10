import 'package:flutter/foundation.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';

import '../data/models/search_result_model.dart';
import '../data/models/water_meter.dart';
import '../data/models/water_response.dart';
import '../data/repositories/water_repository.dart';
import '../ui/widgets/search_bar_widget.dart' show SearchType; // reuse water enum

class WaterViewModel with ChangeNotifier {
  final WaterRepository repository;
  final UserProvider _userProvider;
  UserProfile? _userProfile;

  int? regionId;
  int? cityId;
  int? centerId;

  List<WaterMeterSummary> summaries = [];
  int page = 1;
  int pageCount = 0;
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasError = false;
  bool isInitialized = false;

  bool isSearchMode = false;
  bool isSearching = false;
  String searchQuery = '';
  SearchType searchType = SearchType.mosqueName;
  List<WaterMosqueSearchResult> searchResults = [];
  Map<String, dynamic>? _activeSearchParams;

  bool get hasMorePages => page < pageCount;

  WaterViewModel(this.repository, this._userProvider) {
    _initFromUserProvider();
  }

  Future<void> _initFromUserProvider() async {
    try {
      _userProfile = _userProvider.userProfile;

      isInitialized = true;
      notifyListeners();
      await loadMetersWithUserRegion().timeout(const Duration(seconds: 10), onTimeout: () {});
    } catch (e) {
      isInitialized = true;
      notifyListeners();
    }
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

      if (_userProfile != null) {
        if (!queryParam.containsKey('region_id') && !queryParam.containsKey('city_id')) {
          if ((_userProfile!.stateIds?.isNotEmpty ?? false)) {
            filteredQueryParam['region_id'] = _userProfile!.stateIds!.first.key as int;
          }
        }
      }

      final WaterSummaryResponse res =
          await repository.getMosqueWaterSummary(queryParams: filteredQueryParam);

      if (res.isSuccess) {
        // Append items
        final int receivedCount = res.data.length;
        summaries.addAll(res.data);

        // Handle APIs that may return pageCount = 0 (unknown total)
        if (res.pageCount > 0) {
          pageCount = res.pageCount;
        } else {
          // If empty page, we've reached the end; else allow another fetch
          if (receivedCount == 0) {
            pageCount = page; // end reached
          } else {
            pageCount = 10000; // sentinel to allow further loads until empty
          }
        }

        if (!reset) page += 1;
      }
    } catch (e) {
      hasError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMeters() async {
    await _fetch({'page_no': 1}, reset: true);
  }

  Future<void> loadMetersWithUserRegion() async {
    if (_userProfile?.stateIds?.isNotEmpty == true) {
      regionId = _userProfile!.stateIds!.first.key as int;
      await _fetch({'region_id': regionId, 'page_no': 1}, reset: true);
    } else {
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
        // Keep searchResults in sync with accumulated summaries during pagination
        searchResults = summaries.map((e) => WaterMosqueSearchResult(
          cityId: e.cityId,
          meterId: e.meterId,
          mosqueId: e.mosqueId,
          regionId: e.regionId,
          periodEnd: (e.periodEnd ?? ''),
          mosqueName: e.mosqueName,
          meterNumber: e.meterNumber,
          meterStatus: (e.meterStatus ?? ''),
          periodStart: (e.periodStart ?? ''),
          invoiceCount: e.invoiceCount ?? 0,
          mosqueNumber: e.mosqueNumber,
          moiaCenterId: e.moiaCenterId,
          totalConsumption: e.totalConsumption ?? 0,
          totalAmountInvoices: e.totalAmountInvoices ?? 0,
        )).toList();
      }
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  void setSearchMode(bool enabled) {
    isSearchMode = enabled;
    if (!enabled) {
      clearSearch();
    }
    notifyListeners();
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

      // Use summary endpoint so we have pageCount and can paginate
      summaries = [];
      page = 1;
      pageCount = 0;
      final WaterSummaryResponse res = await repository.getMosqueWaterSummary(queryParams: qp);
      if (res.isSuccess) {
        final int receivedCount = res.data.length;
        summaries.addAll(res.data);
        if (res.pageCount > 0) {
          pageCount = res.pageCount;
        } else {
          // unknown total: allow more until we hit an empty page
          pageCount = receivedCount == 0 ? 1 : 10000;
        }
        // keep searchResults for UI mapping compatibility
        searchResults = res.data.map((e) => WaterMosqueSearchResult(
          cityId: e.cityId,
          meterId: e.meterId,
          mosqueId: e.mosqueId,
          regionId: e.regionId,
          periodEnd: (e.periodEnd ?? ''),
          mosqueName: e.mosqueName,
          meterNumber: e.meterNumber,
          meterStatus: (e.meterStatus ?? ''),
          periodStart: (e.periodStart ?? ''),
          invoiceCount: e.invoiceCount ?? 0,
          mosqueNumber: e.mosqueNumber,
          moiaCenterId: e.moiaCenterId,
          totalConsumption: e.totalConsumption ?? 0,
          totalAmountInvoices: e.totalAmountInvoices ?? 0,
        )).toList();
      } else {
        hasError = true;
        searchResults = [];
      }
    } catch (e) {
      hasError = true;
      searchResults = [];
    } finally {
      isSearching = false;
      notifyListeners();
    }
  }

  List<WaterMeterSummary> get displayResults {
    if (isSearchMode && searchResults.isNotEmpty) {
      return searchResults.map((r) => r.toWaterMeterSummary()).toList();
    }
    return summaries;
  }

  Future<void> loadMoreSearchResults() async {
    await loadMoreMeters();
  }
}


