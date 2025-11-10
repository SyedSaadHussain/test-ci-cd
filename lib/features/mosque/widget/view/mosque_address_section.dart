import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/location_picker_page.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
class MosqueAddressSection extends StatelessWidget {
  const MosqueAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {
        // if (vm.isLoading) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        final m = vm.mosqueObj;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            AppInputView(title: vm.fields.getField('region_id')?.label ?? 'Region', value: m.region ?? ''),
            AppInputView(title: vm.fields.getField('city_id')?.label ?? 'City', value: m.city ?? ''),
            AppInputView(title: vm.fields.getField('moia_center_id')?.label ?? 'MOIA Center', value: m.moiaCenter ?? ''),
            AppInputView(title: vm.fields.getField('district')?.label ?? 'District', value: m.district ?? ''),
            AppInputView(title: vm.fields.getField('street')?.label ?? 'Street', value: m.street ?? ''),
            // Haram location fields (Conditional based on moia_center_id)
            // Show Makkah fields if moia_center_id is 37459
            if (m.moiaCenterId == 37459 || m.moiaCenter == "مركز مدينة مكة المكرمة") ...[
              AppInputView(
                title: vm.fields.getField('is_inside_haram_makkah')?.label ?? 'Inside Haram Makkah',
                value: m.isInsideHaramMakkah?.toString() ?? '',
                options: vm.fields.getComboList('is_inside_haram_makkah')
              ),
              AppInputView(
                title: vm.fields.getField('is_in_pilgrim_housing_makkah')?.label ?? 'In Pilgrim Housing Makkah',
                value: m.isInPilgrimHousingMakkah?.toString() ?? '',
                options: vm.fields.getComboList('is_in_pilgrim_housing_makkah')
              ),
            ],
            
            // Show Madinah fields if moia_center_id is 37582
            if (m.moiaCenterId == 37582 || m.moiaCenter == "مركز مدينة المدينة المنورة") ...[
              AppInputView(
                title: vm.fields.getField('is_inside_haram_madinah')?.label ?? 'Inside Haram Madinah',
                value: m.isInsideHaramMadinah?.toString() ?? '',
                options: vm.fields.getComboList('is_inside_haram_madinah')
              ),
              AppInputView(
                title: vm.fields.getField('is_in_visitor_housing_madinah')?.label ?? 'In Visitor Housing Madinah',
                value: m.isInVisitorHousingMadinah?.toString() ?? '',
                options: vm.fields.getComboList('is_in_visitor_housing_madinah')
              ),
            ],

            AppInputView(title: vm.fields.getField('complete_address')?.label ?? 'Complete Address', value: m.completeAddress ?? ''),
            AppInputView(title: vm.fields.getField('latitude')?.label ?? 'Latitude', value: m.latitude?.toString() ?? ''),
            AppInputView(title: vm.fields.getField('longitude')?.label ?? 'Longitude', value: m.longitude?.toString() ?? ''),
            OsmLocationPicker(
              location: LatLng(m.latitude??0, m.longitude??0), // Riyadh
            ),
            AppInputView(title: vm.fields.getField('place_id')?.label ?? 'Place ID', value: m.placeId ?? ''),
            AppInputView(title: vm.fields.getField('global_code')?.label ?? 'Global Code', value: m.globalCode ?? ''),
            AppInputView(title: vm.fields.getField('compound_code')?.label ?? 'Compound Code', value: m.compoundCode ?? ''),
          ],
        );
      },
    );
  }
}

