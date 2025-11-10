import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../providers/electricity_provider_wrapper.dart';
import '../../providers/electricity_view_model.dart';
import '../../providers/filter_provider.dart';
import '../../providers/filter_provider_wrapper.dart';
import '../widgets/all_mosques_section_widget.dart';
import '../widgets/filters_section_widget.dart';
import '../widgets/search_bar_widget.dart';

class ElectricityFiltersScreen extends StatefulWidget {
  const ElectricityFiltersScreen({super.key});

  @override
  State<ElectricityFiltersScreen> createState() =>
      _ElectricityFiltersScreenState();
}

class _ElectricityFiltersScreenState extends State<ElectricityFiltersScreen> {
  final TextEditingController _searchController = TextEditingController();
  SearchType _searchType = SearchType.mosqueName;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FilterProviderWrapper(
      child: ElectricityProviderWrapper(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'electricity_consumption'.tr(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Consumer<FilterProvider>(
            builder: (context, filter, _) {
              if (filter.accessLevel == AccessLevel.noAccess) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline, size: 56, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'you_have_no_access'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return _ScrollableContent(
                searchController: _searchController,
                searchType: _searchType,
                onSearchTypeChanged: (type) {
                  setState(() {
                    _searchType = type;
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ScrollableContent extends StatelessWidget {
  final TextEditingController searchController;
  final SearchType searchType;
  final Function(SearchType) onSearchTypeChanged;

  const _ScrollableContent({
    required this.searchController,
    required this.searchType,
    required this.onSearchTypeChanged,
  });

  void _onSearchChanged(BuildContext context, String query) {
    // Only clear search when text is empty, don't search automatically
    if (query.isEmpty) {
      final viewModel = context.read<ElectricityViewModel>();
      viewModel.clearSearch();
    }
  }

  void _onSearchTypeChanged(BuildContext context, SearchType type) {
    final viewModel = context.read<ElectricityViewModel>();
    viewModel.updateSearchType(type);
    onSearchTypeChanged(type);
    
    // Don't auto-search when changing type, user needs to click search button
  }

  void _onSearchClear(BuildContext context) {
    searchController.clear();
    final viewModel = context.read<ElectricityViewModel>();
    viewModel.clearSearch();
  }

  void _onSearchSubmitted(BuildContext context) {
    if (searchController.text.isNotEmpty) {
      final viewModel = context.read<ElectricityViewModel>();
      final filter = context.read<FilterProvider>();

      // Block search for users without access
      if (filter.accessLevel == AccessLevel.noAccess) {
        return;
      }

      int? regionId;
      int? cityId;
      int? centerId;

      // Enforce scope per access level. Prefer narrower scopes when selected.
      switch (filter.accessLevel) {
        case AccessLevel.noAccess:
          // No scope allowed; leave all IDs null
          break;
        case AccessLevel.cityManager:
          if (filter.selectedCenterId != null) {
            centerId = filter.selectedCenterId;
          } else {
            cityId = filter.selectedCityId;
          }
          break;
        case AccessLevel.regionalManager:
          if (filter.selectedCenterId != null) {
            centerId = filter.selectedCenterId;
          } else if (filter.selectedCityId != null) {
            cityId = filter.selectedCityId;
          } else {
            regionId = filter.selectedRegionId;
          }
          break;
        case AccessLevel.supervisor:
          if (filter.selectedCenterId != null) {
            centerId = filter.selectedCenterId;
          } else if (filter.selectedCityId != null) {
            cityId = filter.selectedCityId;
          } else {
            regionId = filter.selectedRegionId;
          }
          break;
      }

      viewModel.searchMosques(
        searchController.text,
        regionId: regionId,
        cityId: cityId,
        centerId: centerId,
      );
    } else {
      // If search field is empty, clear search results
      final viewModel = context.read<ElectricityViewModel>();
      viewModel.clearSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - 200) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final viewModel = context.read<ElectricityViewModel>();
            final filterProvider = context.read<FilterProvider>();
            
            // Check if we should load more from filter provider or view model
            if (!viewModel.isSearchMode) {
              if (filterProvider.mosqueData.isNotEmpty) {
                // Using filter data, check filter provider pagination
                if (filterProvider.hasMorePages && !filterProvider.isLoadingMore) {
                  filterProvider.loadMoreMosqueData();
                }
              } else {
                // Using original data, check view model pagination
                if (viewModel.hasMorePages && !viewModel.isLoadingMore) {
                  viewModel.loadMoreMeters();
                }
              }
            } else {
              // In search mode: continue pagination using the same params
              if (viewModel.hasMorePages && !viewModel.isLoadingMore) {
                viewModel.loadMoreSearchResults();
              }
            }
          });
        }
        return false;
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            SearchBarWidget(
              controller: searchController,
              hintText: 'search_mosques'.tr(),
              searchType: searchType,
              onChanged: (query) => _onSearchChanged(context, query),
              onSearchTypeChanged: (type) => _onSearchTypeChanged(context, type),
              onClear: () => _onSearchClear(context),
              onSubmitted: () => _onSearchSubmitted(context),
            ),
            const SizedBox(height: 20),
            const FiltersSectionWidget(),
            const SizedBox(height: 24),
            const AllMosquesSectionWidget(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
