import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MosqueInfoCard extends StatelessWidget {
  final String name;
  final String code; // e.g., internal ID/code
  final String region;
  final String city;
  final String classification; // optional, e.g., جامع/مسجد/مصلى
  final String observers; // المراقبين

  const MosqueInfoCard({
    super.key,
    required this.name,
    required this.code,
    required this.region,
    required this.city,
    required this.classification,
    required this.observers,
  });

  @override
  Widget build(BuildContext context) {
    final onCard = Theme.of(context).colorScheme.onSurface;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // المسجد
            Text(
              "${"mosque".tr()}: $name",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20, thickness: 1.2),
            
            // الرقم التسلسلي
            Text("${"serial_number".tr()}: $code", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            
            // المراقبين
            Text("${"observers".tr()}: $observers", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            
            // التصنيف
            Text("${"classification".tr()}: $classification", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            
            // المنطقة
            Text("${"region".tr()}: $region", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            
            // المدينة
            Text("${"city".tr()}: $city", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
