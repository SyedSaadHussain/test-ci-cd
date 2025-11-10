import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../providers/filter_provider.dart';
import 'filter_dropdown_widget.dart';

class FiltersSectionWidget extends StatefulWidget {
  const FiltersSectionWidget({super.key});

  @override
  State<FiltersSectionWidget> createState() => _FiltersSectionWidgetState();
}

class _FiltersSectionWidgetState extends State<FiltersSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(
      builder: (context, filterProvider, child) {
        if (filterProvider.isInitializing) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'filters'.tr(),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // Region dropdown
                  Expanded(
                    child: FilterDropdownWidget(
                      label: 'region'.tr(),
                      selectedValue: filterProvider
                          .getRegionById(filterProvider.selectedRegionId ?? 0),
                      items: filterProvider.availableRegions,
                      isEnabled: filterProvider.canSelectRegion,
                      isLoading: filterProvider.isLoadingRegions,
                      isFixed: !filterProvider.canSelectRegion,
                      onChanged: (region) {
                        filterProvider.selectRegion(region?.id);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // City dropdown
                  Expanded(
                    child: FilterDropdownWidget(
                      label: 'city'.tr(),
                      selectedValue: filterProvider
                          .getCityById(filterProvider.selectedCityId ?? 0),
                      items: filterProvider.availableCities,
                      isEnabled: filterProvider.canSelectCity,
                      isLoading: filterProvider.isLoadingCities,
                      isFixed: !filterProvider.canSelectCity,
                      onChanged: (city) {
                        filterProvider.selectCity(city?.id);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Center dropdown
                  Expanded(
                    child: FilterDropdownWidget(
                      label: 'center'.tr(),
                      selectedValue: filterProvider
                          .getCenterById(filterProvider.selectedCenterId ?? 0),
                      items: filterProvider.availableCenters,
                      isEnabled: filterProvider.canSelectCenter,
                      isLoading: filterProvider.isLoadingCenters,
                      onChanged: (center) {
                        filterProvider.selectCenter(center?.id);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
