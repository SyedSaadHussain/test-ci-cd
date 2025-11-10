import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EmployeeInfoCard extends StatelessWidget {
  final String name;
  final String role;
  final String id;
  final String region;
  final String city;

  const EmployeeInfoCard({
    super.key,
    required this.name,
    required this.role,
    required this.id,
    required this.region,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Container(
        width: double.infinity, // full width
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الموظف
            Text(
              "${"employee".tr()}: $name",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20, thickness: 1.2),
            
           
            Text("${"national_id".tr()}: $id", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            
            
            Text("${"role".tr()}: $role", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            
            
            Text("${"region".tr()}: $region", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 6),
            
            
            Text("${"city".tr()}: $city", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
