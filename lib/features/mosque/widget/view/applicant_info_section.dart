import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/features/mosque/widget/mosque_mosnoob_card.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/features/mosque/widget/view/mansoob_groups_view.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class ApplicantInfoSection extends StatelessWidget {
  const ApplicantInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {
        final fields = vm.fields;
        final List data = (vm.mosqueObj.payload?['applicants'] as List?) ?? const [];

        List<UserProfile> imams = [];
        List<UserProfile> muezzins = [];
        List<UserProfile> khatibs = [];
        List<UserProfile> khadems = [];
        List<Map<String, dynamic>> imamsRaw = [];
        List<Map<String, dynamic>> muezzinsRaw = [];
        List<Map<String, dynamic>> khatibsRaw = [];
        List<Map<String, dynamic>> khademsRaw = [];

        for (final e in data.whereType<Map>()) {
          final m = Map<String, dynamic>.from(e as Map);
          final up = UserProfile(
            userId: (m['id'] as int?) ?? 0,
            name: ((m['full_arabic_name'] ?? '').toString().trim().isNotEmpty)
                ? m['full_arabic_name'].toString()
                : m['full_english_name']?.toString(),
            phone: m['partner_mobile']?.toString(),
            identificationId: m['identification_id']?.toString(),
            cityIds: null,
            parentId: null,
            parent: null,
            stateIds: null,
            roleNames: null,
            employeeId: null,
            employee: null,
            moiaCenterIds: null,
            userAppVersion: null,
            classificationId: null,
            classification: null,
            staffRelationType: null,
            genderArabic: null,
          );
          final roleId = m['role_id'] is int ? m['role_id'] as int : int.tryParse('${m['role_id']}');
          switch (roleId) {
            case 8: imams.add(up); imamsRaw.add(m); break;
            case 9: muezzins.add(up); muezzinsRaw.add(m); break;
            case 10: khatibs.add(up); khatibsRaw.add(m); break;
            case 11: khadems.add(up); khademsRaw.add(m); break;
            default: break;
          }
        }

        return FutureBuilder<Map<String, Map<int, String>>>(
          future: _loadLookups(),
          builder: (context, snap) {
            final famNames = snap.data?['family'] ?? const {};
            final posNames = snap.data?['position'] ?? const {};

            String _relName(String code) {
              switch (code) {
                case 'regular': return 'Regular'.tr();
                case 'contract_base': return 'Contract Base'.tr();
                case 'rewarding_base': return 'Rewarding Base'.tr();
                case 'volunteer_khateeb': return 'Volunteer Khateeb'.tr();
                case 'unassigned_ministry': return 'Unassigned in Ministry'.tr();
                default: return code;
              }
            }

            Widget _details(UserProfile u, Map<String, dynamic> raw) {
              final int? famId = raw['job_family_id'] is int ? raw['job_family_id'] : int.tryParse('${raw['job_family_id']}');
              final int? posId = raw['job_id'] is int ? raw['job_id'] : int.tryParse('${raw['job_id']}');
              final String fam = famNames[famId ?? -1] ?? '${famId ?? ''}';
              final String pos = posNames[posId ?? -1] ?? '${posId ?? ''}';
              final String rel = _relName((raw['staff_relation_type'] ?? '').toString());
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${'job_family'.tr()}: $fam', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                  const SizedBox(height: 2),
                  Text('${'job_position'.tr()}: $pos', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                  const SizedBox(height: 2),
                  Text('${'staff_relation_type'.tr()}: $rel', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                ],
              );
            }

            return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red.shade400, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'applicant_viewing_message'.tr(),
                      style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            MansoobGroupsView(
              fields: fields,
              imams: imams,
              muezzins: muezzins,
              khatibs: khatibs,
              khadems: khadems,
              imamsRaw: imamsRaw,
              muezzinsRaw: muezzinsRaw,
              khatibsRaw: khatibsRaw,
              khademsRaw: khademsRaw,
              detailsBuilder: _details,
            ),
          ],
            );
          },
        );
      },
    );
  }
}

Future<Map<String, Map<int, String>>> _loadLookups() async {
  try {
    final famJson = await rootBundle.loadString('assets/data/mosque/job_family.json');
    final posJson = await rootBundle.loadString('assets/data/mosque/job_position.json');
    final List famList = json.decode(famJson) as List;
    final List posList = json.decode(posJson) as List;
    final Map<int, String> fam = {
      for (final e in famList.whereType<Map>())
        if (e['id'] != null) (e['id'] as int): (e['name'] ?? '').toString()
    };
    final Map<int, String> pos = {
      for (final e in posList.whereType<Map>())
        if (e['id'] != null) (e['id'] as int): (e['name'] ?? '').toString()
    };
    return {'family': fam, 'position': pos};
  } catch (_) {
    return {'family': const {}, 'position': const {}};
  }
}


