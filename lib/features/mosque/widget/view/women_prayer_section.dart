import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

class WomenPrayerSection extends StatelessWidget {
  const WomenPrayerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {


        final m = vm.mosqueObj;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            AppInputView(
                title: vm.fields.getField('has_women_prayer_room')?.label ?? 'Has Women Prayer Room',
                value: m.hasWomenPrayerRoom ?? '',
                options: vm.fields.getComboList('has_women_prayer_room')

            ),

            AppInputView(title: vm.fields.getField('row_women_praying_number')?.label ?? 'Row Women Praying Number', value: m.rowWomenPrayingNumber?.toString() ?? ''),
            AppInputView(title: vm.fields.getField('length_row_women_praying')?.label ?? 'Length Row Women Praying', value: m.lengthRowWomenPraying?.toString() ?? ''),
            AppInputView(title: vm.fields.getField('women_prayer_room_capacity')?.label ?? 'Women Prayer Room Capacity', value: m.womenPrayerRoomCapacity?.toString() ?? ''),
            AppInputView(title: vm.fields.getField('toilet_woman_number')?.label ?? 'Toilet Woman Number', value: m.toiletWomanNumber?.toString() ?? ''),
          ],
        );
      },
    );
  }
}
