import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../providers/water_filter_provider.dart';
import '../../providers/water_view_model.dart';
import '../screens/water_mosque_details_screen.dart';
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
    final filterProvider = context.read<WaterFilterProvider>();

    // Wait for provider init to finish
    while (filterProvider.isInitializing) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Default Riyadh for supervisors
    if (filterProvider.accessLevel == AccessLevel.supervisor) {
      final riyadhRegion = filterProvider.availableRegions
          .where((region) =>
              region.name.contains('الرياض') ||
              region.name.toLowerCase().contains('riyadh'))
          .firstOrNull;

      if (riyadhRegion != null) {
        await filterProvider.selectRegion(riyadhRegion.id);
      }
    }

    await filterProvider.loadMosqueData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WaterViewModel, WaterFilterProvider>(
      builder: (context, vm, filterProvider, _) {
        if (filterProvider.isInitializing ||
            filterProvider.isLoadingData ||
            (!vm.isInitialized || (vm.isLoading && vm.summaries.isEmpty))) {
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ],
            ),
          );
        }

        if (!vm.isSearchMode &&
            (filterProvider.errorMessage != null ||
                (vm.hasError && vm.summaries.isEmpty))) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
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
                        vm.refreshMeters();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('retry'.tr()),
                  ),
                ],
              ),
            ),
          );
        }

        final usingFilter = filterProvider.selectedRegionId != null ||
            filterProvider.selectedCityId != null ||
            filterProvider.selectedCenterId != null;
        final isEmpty = usingFilter
            ? filterProvider.mosqueData.isEmpty
            : vm.summaries.isEmpty;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vm.isSearchMode ? 'search_results'.tr() : 'all_mosques'.tr(),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
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
              if (vm.isSearchMode && vm.isSearching)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (isEmpty)
                Center(child: Text('no_mosques_found'.tr()))
              else if (vm.isSearchMode) ...[
                if (vm.isSearching)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (vm.searchResults.isEmpty && vm.searchQuery.isNotEmpty)
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
                else if (vm.searchResults.isEmpty)
                  Center(child: Text('no_mosques_found'.tr()))
                else
                  ...vm.searchResults.map((searchResult) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WaterMosqueDetailsScreen(
                                mosqueName: searchResult.mosqueName,
                                consumption:
                                    '${searchResult.totalConsumption.toStringAsFixed(0)} m³',
                                meterId: searchResult.meterId,
                                meterNumber: searchResult.meterNumber,
                              ),
                            ),
                          );
                        },
                        child: ConsumptionCardWidget(
                          consumption:
                              '${searchResult.totalConsumption.toStringAsFixed(0)} m³',
                          mosqueName: searchResult.mosqueName,
                          mosqueNumber: searchResult.mosqueNumber,
                          invoiceAmount:
                              '${searchResult.totalAmountInvoices.toStringAsFixed(2)} ${'sar_currency'.tr()}',
                          meterNumber: searchResult.meterNumber,
                          meterId: searchResult.meterId,
                        ),
                      )),
              ] else ...[
                if (usingFilter) ...[
                  if (filterProvider.mosqueData.isEmpty)
                    Center(child: Text('no_mosques_found'.tr()))
                  else ...[
                    ...filterProvider.mosqueData
                        .map((mosque) => ConsumptionCardWidget(
                              consumption: mosque.totalConsumption != null
                                  ? '${mosque.totalConsumption!.toStringAsFixed(0)} m³'
                                  : '-- m³',
                              mosqueName: mosque.mosqueName,
                              mosqueNumber: mosque.mosqueNumber,
                              invoiceAmount: mosque.totalAmountInvoices != null
                                  ? '${mosque.totalAmountInvoices!.toStringAsFixed(2)} ${'sar_currency'.tr()}'
                                  : '-- ${'sar_currency'.tr()}',
                              meterNumber: mosque.meterNumber,
                              meterId: mosque.meterId,
                            )),
                    if (filterProvider.isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    if (filterProvider.hasMorePages &&
                        !filterProvider.isLoadingMore)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                filterProvider.loadMoreMosqueData(),
                            icon: const Icon(Icons.arrow_downward, size: 18),
                            label: Text('load_more'.tr()),
                          ),
                        ),
                      ),
                  ],
                ] else ...[
                  if (vm.summaries.isEmpty)
                    Center(child: Text('no_mosques_found'.tr()))
                  else ...[
                    ...vm.summaries.map((m) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => WaterMosqueDetailsScreen(
                                  mosqueName: m.mosqueName,
                                  consumption: m.totalConsumption != null
                                      ? '${m.totalConsumption!.toStringAsFixed(0)} m³'
                                      : '-- m³',
                                  meterId: m.meterId,
                                  meterNumber: m.meterNumber,
                                ),
                              ),
                            );
                          },
                          child: ConsumptionCardWidget(
                            consumption: m.totalConsumption != null
                                ? '${m.totalConsumption!.toStringAsFixed(0)} m³'
                                : '-- m³',
                            mosqueName: m.mosqueName,
                            mosqueNumber: m.mosqueNumber,
                            invoiceAmount: m.totalAmountInvoices != null
                                ? '${m.totalAmountInvoices!.toStringAsFixed(2)} ${'sar_currency'.tr()}'
                                : '-- ${'sar_currency'.tr()}',
                            meterNumber: m.meterNumber,
                            meterId: m.meterId,
                          ),
                        )),
                    if (vm.isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    if (vm.hasMorePages && !vm.isLoadingMore)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () => vm.loadMoreMeters(),
                            child: Text('load_more'.tr()),
                          ),
                        ),
                      ),
                  ],
                ],
              ]
            ],
          ),
        );
      },
    );
  }
}
