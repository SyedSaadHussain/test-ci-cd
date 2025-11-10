import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../providers/electricity_view_model.dart';
import '../../providers/filter_provider.dart';
import 'consumption_card_widget.dart';

class AllMosquesSectionWidget extends StatefulWidget {
  const AllMosquesSectionWidget({super.key});

  @override
  State<AllMosquesSectionWidget> createState() =>
      _AllMosquesSectionWidgetState();
}

class _AllMosquesSectionWidgetState extends State<AllMosquesSectionWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeDefaultFilters();
      }
    });
  }

  Future<void> _initializeDefaultFilters() async {
    final filterProvider = context.read<FilterProvider>();

    // Wait for filter provider to initialize
    while (filterProvider.isInitializing) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Set default Riyadh region for supervisors
    if (filterProvider.accessLevel == AccessLevel.supervisor) {
      // Find Riyadh region ID (1496 is typically Riyadh region)
      final riyadhRegion = filterProvider.availableRegions
          .where((region) =>
              region.name.contains('الرياض') ||
              region.name.toLowerCase().contains('riyadh'))
          .firstOrNull;

      if (riyadhRegion != null) {
        debugPrint(
            '🔄 Setting default Riyadh region for supervisor: ${riyadhRegion.name}');
        await filterProvider.selectRegion(riyadhRegion.id);
      }
    }

    // Load initial mosque data
    await filterProvider.loadMosqueData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ElectricityViewModel, FilterProvider>(
      builder: (context, viewModel, filterProvider, child) {
        // Loading State - show loading if either filter or electricity data is loading
        if (filterProvider.isInitializing ||
            filterProvider.isLoadingData ||
            (!viewModel.isInitialized ||
                (viewModel.isLoading && viewModel.summaries.isEmpty))) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'all_mosques'.tr(),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ],
            ),
          );
        }

        // Error State - show error if filter has error or electricity has error
        if (filterProvider.errorMessage != null ||
            (viewModel.hasError && viewModel.summaries.isEmpty)) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'all_mosques'.tr(),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'error_loading_data'.tr(),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (filterProvider.errorMessage != null) {
                            filterProvider.clearError();
                            filterProvider.retryInitialization();
                          } else {
                            viewModel.refreshMeters();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('retry'.tr()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Success State
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    viewModel.isSearchMode
                        ? 'search_results'.tr()
                        : 'all_mosques'.tr(),
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Info container with pagination details when using filtered data
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.green.withOpacity(0.6), width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'data_updates_every_12_hours'.tr(),
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              _buildContent(viewModel, filterProvider),
            ],
          ),
        );
      },
    );
  }

  // removed popup info

  Widget _buildContent(
      ElectricityViewModel viewModel, FilterProvider filterProvider) {
    // If any filter is active, rely solely on filtered data (even if empty)
    final usingFilter = filterProvider.selectedRegionId != null ||
        filterProvider.selectedCityId != null ||
        filterProvider.selectedCenterId != null;
    final isLoading = filterProvider.isLoadingData ||
        (viewModel.isLoading && viewModel.summaries.isEmpty);
    final hasError = filterProvider.errorMessage != null ||
        (viewModel.hasError && viewModel.summaries.isEmpty);
    final isEmpty = usingFilter
        ? filterProvider.mosqueData.isEmpty
        : viewModel.summaries.isEmpty;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError && isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(filterProvider.errorMessage ?? 'error_loading_data'.tr()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (filterProvider.errorMessage != null) {
                  filterProvider.clearError();
                  filterProvider.retryInitialization();
                } else {
                  viewModel.refreshMeters();
                }
              },
              child: Text('retry'.tr()),
            ),
          ],
        ),
      );
    }

    if (isEmpty) {
      return Center(child: Text('no_mosques_found'.tr()));
    }

    return Column(
      children: [
        // Show search results when in search mode
        if (viewModel.isSearchMode) ...[
          if (viewModel.isSearching)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (viewModel.searchResults.isEmpty &&
              viewModel.searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'no_search_results'.tr(),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            // Display search results (same summary model)
            ...viewModel.searchResults
                .map((meter) => ConsumptionCardWidget(
                      consumption: meter.totalConsumption != null
                          ? '${meter.totalConsumption!.toStringAsFixed(0)} ${'kwh_unit'.tr()}'
                          : '-- ${'kwh_unit'.tr()}',
                      mosqueName: meter.mosqueName,
                      mosqueNumber: meter.mosqueNumber,
                      invoiceAmount: meter.totalAmountInvoices != null
                          ? '${meter.totalAmountInvoices!.toStringAsFixed(2)} ${'sar_currency'.tr()}'
                          : '-- ${'sar_currency'.tr()}',
                      meterNumber: meter.meterNumber,
                      meterId: meter.meterId,
                    )),
        ] else ...[
          // When filters are active, show only filtered data (no fallback)
          if (usingFilter) ...[
            ...filterProvider.mosqueData.map((mosque) => ConsumptionCardWidget(
                  consumption: mosque.totalConsumption != null
                      ? '${mosque.totalConsumption!.toStringAsFixed(0)} ${'kwh_unit'.tr()}'
                      : '-- ${'kwh_unit'.tr()}',
                  mosqueName: mosque.mosqueName,
                  mosqueNumber: mosque.mosqueNumber,
                  invoiceAmount: mosque.totalAmountInvoices != null
                      ? '${mosque.totalAmountInvoices!.toStringAsFixed(2)} ${'sar_currency'.tr()}'
                      : '-- ${'sar_currency'.tr()}',
                  meterNumber: mosque.meterNumber,
                  meterId: mosque.meterId,
                )),

            // Loading more indicator for filtered data
            if (filterProvider.isLoadingMore)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),

            // Load more for filtered data
            if (filterProvider.hasMorePages && !filterProvider.isLoadingMore)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Page ${filterProvider.currentPage} of ${filterProvider.totalPages}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () => filterProvider.loadMoreMosqueData(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_downward, size: 18),
                        label: Text('load_more'.tr()),
                      ),
                    ],
                  ),
                ),
              ),
          ] else ...[
            // No filters active → show regular summaries
            ...viewModel.summaries.map((meter) => ConsumptionCardWidget(
                  consumption: meter.totalConsumption != null
                      ? '${meter.totalConsumption!.toStringAsFixed(0)} ${'kwh_unit'.tr()}'
                      : '-- ${'kwh_unit'.tr()}',
                  mosqueName: meter.mosqueName,
                  mosqueNumber: meter.mosqueNumber,
                  invoiceAmount: meter.totalAmountInvoices != null
                      ? '${meter.totalAmountInvoices!.toStringAsFixed(2)} ${'sar_currency'.tr()}'
                      : '-- ${'sar_currency'.tr()}',
                  meterNumber: meter.meterNumber,
                  meterId: meter.meterId,
                )),

            if (viewModel.isLoadingMore)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),

            if (viewModel.hasMorePages && !viewModel.isLoadingMore)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => viewModel.loadMoreMeters(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('load_more'.tr()),
                  ),
                ),
              ),
          ],
        ],
      ],
    );
  }
}
