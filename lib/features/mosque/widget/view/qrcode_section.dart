 
import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_image_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

class QRCodeSection extends StatelessWidget {
  const QRCodeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {
        // if (vm.isLoading) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        final m = vm.mosqueObj;
        
        // Get QR code data from payload or fallback to model fields
        final qrData = m.payload?['qrcode'] ?? m.payload?['data'];
        
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            AppInputView(
              title: vm.fields.getField('is_qr_code_exist')?.label ?? 'QR Code Existence', 
              value: qrData?['is_qr_code_exist']?.toString() ?? m.isQrCodeExist?.toString() ?? '',
                options: vm.fields.getComboList('is_qr_code_exist')
            ),
            AppInputView(
              title: vm.fields.getField('qr_panel_numbers')?.label ?? 'QR Panel Numbers', 
              value: qrData?['qr_panel_numbers']?.toString() ?? m.qrPanelNumbers?.toString() ?? ''
            ),
            AppInputView(
              title: vm.fields.getField('is_panel_readable')?.label ?? 'Is Panel Readable', 
              value: qrData?['is_panel_readable']?.toString() ?? m.isPanelReadable?.toString() ?? '',
                options: vm.fields.getComboList('is_panel_readable')
            ),
            AppInputView(
              title: vm.fields.getField('mosque_data_correct')?.label ?? 'Mosque Data Correct', 
              value: qrData?['mosque_data_correct']?.toString() ?? m.mosqueDataCorrect?.toString() ?? '',
                options: vm.fields.getComboList('mosque_data_correct')
            ),
            AppInputView(
              title: vm.fields.getField('is_mosque_name_qr')?.label ?? 'Mosque Name on QR', 
              value: qrData?['is_mosque_name_qr']?.toString() ?? m.isMosqueNameQr?.toString() ?? '',
                options: vm.fields.getComboList('is_mosque_name_qr')
            ),
            AppInputView(
              title: vm.fields.getField('qr_code_notes')?.label ?? 'QR Code Notes', 
              value: qrData?['qr_code_notes']?.toString() ?? m.qrCodeNotes?.toString() ?? ''
            ),
            AppImageView(
              title: vm.fields.getField('qr_image')?.label ?? 'QR Image',
              value: '${EnvironmentConfig.baseUrl}/web/image?model=${vm.modelName}&field=qr_image&id=${vm.idForImage}&unique=${m.uniqueId ?? ''}',
              headersMap: vm.headerMap,
            ),
          ],
        );
      },
    );
  }
}
