import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/FullImageViewer.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_image_view.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

class MetersSection extends StatelessWidget {
  const MetersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {


        final m = vm.mosqueObj;

        // Get meters data from multiple possible sources
        var metersData = m.payload?['meters'];

        // Fallback to model arrays if payload is empty
        if (metersData == null) {
          // Try to construct from model arrays
          final electricMeters = m.electricMetersArray;
          final waterMeters = m.waterMetersArray;

          if (electricMeters != null || waterMeters != null) {
            metersData = {
              'meter_ids': electricMeters ?? [],
              'water_meter_ids': waterMeters ?? [],
            };
          }
        }

        // Check if we have any data to display
        if (metersData == null ||
            (metersData is Map &&
                (metersData['meter_ids'] == null || (metersData['meter_ids'] as List).isEmpty) &&
                (metersData['water_meter_ids'] == null || (metersData['water_meter_ids'] as List).isEmpty))) {
          return _buildEmptyState();
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // Electric Meters Section
            _buildMeterSection(
              title: 'عدادات الكهرباء',
              meters: metersData['meter_ids'],
              vm: vm,
              meterType: 'electric',
            ),

            const SizedBox(height: 24),

            // Water Meters Section
            _buildMeterSection(
              title: 'عدادات المياه',
              meters: metersData['water_meter_ids'],
              vm: vm,
              meterType: 'water',
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.electric_meter_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد بيانات عدادات متاحة',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'قد تكون بيانات العدادات غير متوفرة لهذا المسجد أو غير مدخلة',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeterSection({
    required String title,
    required dynamic meters,
    required MosqueBaseViewModel vm,
    required String meterType,
  }) {
    if (meters == null || (meters is List && meters.isEmpty)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: meterType == 'electric' ? Colors.amber[50] : Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: meterType == 'electric' ? Colors.amber[200]! : Colors.blue[200]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  meterType == 'electric' ? Icons.electrical_services : Icons.water_drop,
                  color: meterType == 'electric' ? Colors.amber[700] : Colors.blue[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: meterType == 'electric' ? Colors.amber[800] : Colors.blue[800],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'لا توجد عدادات من هذا النوع',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (meters is! List) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: meterType == 'electric' ? Colors.amber[50] : Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: meterType == 'electric' ? Colors.amber[200]! : Colors.blue[200]!,
            ),
          ),
          child: Row(
            children: [
              Icon(
                meterType == 'electric' ? Icons.electrical_services : Icons.water_drop,
                color: meterType == 'electric' ? Colors.amber[700] : Colors.blue[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: meterType == 'electric' ? Colors.amber[800] : Colors.blue[800],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: meterType == 'electric' ? Colors.amber[100] : Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${meters.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: meterType == 'electric' ? Colors.amber[800] : Colors.blue[800],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Meters list
        ...meters.asMap().entries.map((entry) {
          final index = entry.key;
          final meter = entry.value as Map<String, dynamic>;

          return _buildMeterCard(meter, index + 1, vm, meterType);
        }).toList(),
      ],
    );
  }

  Widget _buildMeterCard(Map<String, dynamic> meter, int index, MosqueBaseViewModel vm, String meterType) {
    final meterNumber = meter['meter_number']?.toString() ?? '';
    final isNew = meter['meter_new'] == true;
    final attachmentId = meter['attachment_id'];
    final hasImage = attachmentId != null && attachmentId != false;

    // Get usage locations
    List<String> usageLocations = [];
    if (meter['imam'] == true) usageLocations.add('إمام');
    if (meter['muezzin'] == true) usageLocations.add('مؤذن');
    if (meter['mosque'] == true) usageLocations.add('مسجد');
    if (meter['facility'] == true) usageLocations.add('مرافق');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: meterType == 'electric' ? Colors.amber[25] : Colors.blue[25],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  meterType == 'electric' ? Icons.electrical_services : Icons.water_drop,
                  color: meterType == 'electric' ? Colors.amber[700] : Colors.blue[700],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'عداد رقم $index',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: meterType == 'electric' ? Colors.amber[800] : Colors.blue[800],
                        ),
                      ),
                      if (meterNumber.isNotEmpty)
                        Text(
                          meterNumber,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontFamily: 'monospace',
                          ),
                        ),
                    ],
                  ),
                ),
                if (isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'جديد',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Usage locations
                if (usageLocations.isNotEmpty) ...[
                  Text(
                    'مواقع الاستخدام',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: usageLocations.map((location) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Meter image
                if (hasImage)
                  Builder(
                    builder: (context) => AppImageView(
                      title: 'صورة العداد',
                      value: '${EnvironmentConfig.baseUrl}/web/image?model=${meterType == 'electric'?vm.meterModelName:vm.watetMeterModelName}&field=attachment_id&id=${meter['id']}&unique=${vm.mosqueObj.uniqueId ?? ''}',
                      headersMap: vm.headerMap,
                      onTab: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImagePage(
                              title: 'صورة العداد - ${meter['meter_number'] ?? 'غير محدد'}',
                              imageUrl: '${EnvironmentConfig.baseUrl}/web/image?model=${meterType == 'electric'?vm.meterModelName:vm.watetMeterModelName}&field=attachment_id&id=${meter['id']}&unique=${vm.mosqueObj.uniqueId ?? ''}',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
