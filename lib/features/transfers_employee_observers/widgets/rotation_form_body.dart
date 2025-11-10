import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

import 'cancel_send_buttons.dart';
import 'employee_info_card.dart';
import 'labeled_input_field.dart';
import 'mosque_info_card.dart';

class RotationFormBody extends StatefulWidget {
  const RotationFormBody({super.key});

  @override
  State<RotationFormBody> createState() => _RotationFormBodyState();
}

class _RotationFormBodyState extends State<RotationFormBody> {
  // Employee
  String? selectedEmployee;

  // Mosque (Current & New)
  String? selectedCurrentMosque;
  String? selectedNewMosque;

  // Dummy employees (Arabic realistic data)
  final Map<String, Map<String, String>> employeeData = const {
    "عبدالله القحطاني": {
      "role": "إمام",
      "id": "1539506978",
      "region": "الرياض",
      "city": "الرياض",
    },
    "سلمان العتيبي": {
      "role": "مؤذن",
      "id": "1430955569",
      "region": "مكة المكرمة",
      "city": "جدة",
    },
    "محمد الخالدي": {
      "role": "خطيب",
      "id": "1064329403",
      "region": "الشرقية",
      "city": "الدمام",
    },
    "أحمد الزهراني": {
      "role": "إمام",
      "id": "1322996977",
      "region": "المدينة المنورة",
      "city": "المدينة",
    },
  };

  // Demo data for mosques
  final Map<String, Map<String, String>> mosqueData = const {
    "جامع الملك خالد": {
      "code": "MK-001",
      "region": "الرياض",
      "city": "الرياض",
      "classification": "جامع",
      "observers": "سالم الدوسري، ناصر القحطاني",
    },
    "مسجد النور": {
      "code": "NR-112",
      "region": "الشرقية",
      "city": "الدمام",
      "classification": "مسجد",
      "observers": "سالم الدوسري، ناصر القحطاني",
    },
    "مسجد السلام": {
      "code": "SL-209",
      "region": "مكة المكرمة",
      "city": "جدة",
      "classification": "مسجد",
      "observers": "سالم الدوسري، ناصر القحطاني",
    },
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ===== Employee dropdown =====
          LabeledInputField(
            title: "observer_name".tr(),
            hint: "select_observer".tr(),
            isDropdown: true,
            value: selectedEmployee,
            options: employeeData.keys.toList(),
            onChanged: (val) {
              setState(() => selectedEmployee = val);
            },
          ),

          if (selectedEmployee != null) ...[
            EmployeeInfoCard(
              name: selectedEmployee!,
              role: employeeData[selectedEmployee]!['role'] ?? "موظف",
              id: employeeData[selectedEmployee]!['id'] ?? "-",
              region: employeeData[selectedEmployee]!['region'] ?? "غير محدد",
              city: employeeData[selectedEmployee]!['city'] ?? "غير محدد",
            ),
          ],

          // ===== Current Mosque =====
          LabeledInputField(
            title: "remove_associated_mosque".tr(),
            hint: "select_current_mosque".tr(),
            isDropdown: true,
            value: selectedCurrentMosque,
            options: mosqueData.keys.toList(),
            onChanged: (val) {
              setState(() => selectedCurrentMosque = val);
            },
          ),

          if (selectedCurrentMosque != null) ...[
            MosqueInfoCard(
              name: selectedCurrentMosque!,
              code: mosqueData[selectedCurrentMosque]!["code"]!,
              region: mosqueData[selectedCurrentMosque]!["region"]!,
              city: mosqueData[selectedCurrentMosque]!["city"]!,
              classification:
                  mosqueData[selectedCurrentMosque]!["classification"]!,
              observers:
                  mosqueData[selectedCurrentMosque]!["observers"] ?? "غير محدد",
            ),
          ],

          // ===== New Mosque =====
          LabeledInputField(
            title: "new_mosque".tr(),
            hint: "select_new_mosque".tr(),
            isDropdown: true,
            value: selectedNewMosque,
            options: mosqueData.keys.toList(),
            onChanged: (val) {
              setState(() => selectedNewMosque = val);
            },
          ),

          if (selectedNewMosque != null) ...[
            MosqueInfoCard(
              name: selectedNewMosque!,
              code: mosqueData[selectedNewMosque]!["code"]!,
              region: mosqueData[selectedNewMosque]!["region"]!,
              city: mosqueData[selectedNewMosque]!["city"]!,
              classification: mosqueData[selectedNewMosque]!["classification"]!,
              observers:
                  mosqueData[selectedNewMosque]!["observers"] ?? "غير محدد",
            ),
          ],

          const SizedBox(height: 20),

          // ===== Buttons =====
          CancelSendButtons(
            onCancel: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("done_canceling_request".tr()),
                  duration: Duration(milliseconds: 1000),
                  backgroundColor: const Color(0xFF8B4513),
                ),
              );
            },
            onSave: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("done_sending_request".tr()),
                  duration: Duration(milliseconds: 1000),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
