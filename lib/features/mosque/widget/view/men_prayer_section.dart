import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

class MenPrayerSection extends StatelessWidget {
  const MenPrayerSection({super.key});

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
            AppInputView(title: vm.fields.getField('friday_prayer_rows')?.label ?? 'Friday Prayer Rows', value: m.fridayPrayerRows?.toString() ?? ''),
            AppInputView(title: vm.fields.getField('row_men_praying_number')?.label ?? 'Row Men Praying Number', value: m.rowMenPrayingNumber?.toString() ?? ''),
            AppInputView(title: vm.fields.getField('length_row_men_praying')?.label ?? 'Length Row Men Praying', value: m.lengthRowMenPraying?.toString() ?? ''),
            AppInputView(title: vm.fields.getField('capacity')?.label ?? 'Capacity', value: m.capacity?.toString() ?? ''),
            AppInputView(
              title: vm.fields.getField('men_prayer_avg_attendance')?.label ?? 'Average Attendance',
              value: m.menPrayerAvgAttendance?.toString() ?? '',
              options: vm.fields.getComboList('men_prayer_avg_attendance'),
            ),
            AppInputView(title: vm.fields.getField('toilet_men_number')?.label ?? 'Toilet Men Number', value: m.toiletMenNumber?.toString() ?? ''),
          ],
        );
      },
    );
  }
}
