import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../providers/water_filter_provider.dart';
import '../../providers/water_provider_wrapper.dart';
import '../../providers/water_view_model.dart';
import '../widgets/all_mosques_section_widget.dart';
import '../widgets/filters_section_widget.dart';
import '../widgets/search_bar_widget.dart';

class WaterFiltersScreen extends StatefulWidget {
  const WaterFiltersScreen({super.key});

  @override
  State<WaterFiltersScreen> createState() => _WaterFiltersScreenState();
}

class _WaterFiltersScreenState extends State<WaterFiltersScreen> {
  final TextEditingController _searchController = TextEditingController();
  SearchType _searchType = SearchType.mosqueName;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WaterProviderWrapper(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'water_consumption'.tr(),
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
          body: Consumer<WaterFilterProvider>(
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
    // UI only: no provider or data actions
    if (query.isEmpty) {
      final vm = context.read<WaterViewModel>();
      vm.clearSearch();
    }
  }

  void _onSearchTypeChanged(BuildContext context, SearchType type) {
    final vm = context.read<WaterViewModel>();
    vm.updateSearchType(type);
    onSearchTypeChanged(type);
  }

  void _onSearchClear(BuildContext context) {
    searchController.clear();
    final vm = context.read<WaterViewModel>();
    vm.clearSearch();
  }

  void _onSearchSubmitted(BuildContext context) {
    if (searchController.text.isNotEmpty) {
      final vm = context.read<WaterViewModel>();
      final filter = context.read<WaterFilterProvider>();

      int? regionId;
      int? cityId;
      int? centerId;

      switch (filter.accessLevel) {
        case AccessLevel.noAccess:
          break;
        case AccessLevel.cityManager:
          if (filter.selectedCenterId != null) {
            centerId = filter.selectedCenterId;
          } else {
            cityId = filter.selectedCityId;
          }
          break;
        case AccessLevel.regionalManager:
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

      vm.searchMosques(
        searchController.text,
        regionId: regionId,
        cityId: cityId,
        centerId: centerId,
      );
    } else {
      final vm = context.read<WaterViewModel>();
      vm.clearSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - 200) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final viewModel = context.read<WaterViewModel>();
            final filterProvider = context.read<WaterFilterProvider>();

            if (!viewModel.isSearchMode) {
              if (filterProvider.mosqueData.isNotEmpty) {
                if (filterProvider.hasMorePages && !filterProvider.isLoadingMore) {
                  filterProvider.loadMoreMosqueData();
                }
              } else {
                if (viewModel.hasMorePages && !viewModel.isLoadingMore) {
                  viewModel.loadMoreMeters();
                }
              }
            } else {
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
            onChanged: (q) => _onSearchChanged(context, q),
            onSearchTypeChanged: (t) => _onSearchTypeChanged(context, t),
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
    ));
  }
}


