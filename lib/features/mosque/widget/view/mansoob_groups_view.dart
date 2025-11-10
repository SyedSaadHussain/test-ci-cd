import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/features/mosque/widget/mosque_mosnoob_card.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';

class MansoobGroupsView extends StatelessWidget {
  final FieldListData fields;
  final List<UserProfile> imams;
  final List<UserProfile> muezzins;
  final List<UserProfile> khatibs;
  final List<UserProfile> khadems;
  // Optional raw rows (to render extra details)
  final List<Map<String, dynamic>>? imamsRaw;
  final List<Map<String, dynamic>>? muezzinsRaw;
  final List<Map<String, dynamic>>? khatibsRaw;
  final List<Map<String, dynamic>>? khademsRaw;
  // Optional extra widget per row
  final Widget Function(UserProfile user, Map<String, dynamic> raw)? detailsBuilder;

  const MansoobGroupsView({
    super.key,
    required this.fields,
    required this.imams,
    required this.muezzins,
    required this.khatibs,
    required this.khadems,
    this.imamsRaw,
    this.muezzinsRaw,
    this.khatibsRaw,
    this.khademsRaw,
    this.detailsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppInputView(
          title: fields.getField('imam_ids')?.label ?? 'أسماء الأئمة',
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: imams.length,
            itemBuilder: (context, index) {
              final user = imams[index];
              final raw = (imamsRaw != null && index < (imamsRaw!.length)) ? imamsRaw![index] : const <String, dynamic>{};
              return MosqueMansoobCard(
                user: user,
                footer: (detailsBuilder != null && raw.isNotEmpty)
                    ? detailsBuilder!(user, raw)
                    : null,
              );
            },
          ),
        ),
        AppInputView(
          title: fields.getField('muezzin_ids')?.label ?? 'أسماء المؤذنين',
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: muezzins.length,
            itemBuilder: (context, index) {
              final user = muezzins[index];
              final raw = (muezzinsRaw != null && index < (muezzinsRaw!.length)) ? muezzinsRaw![index] : const <String, dynamic>{};
              return MosqueMansoobCard(
                user: user,
                footer: (detailsBuilder != null && raw.isNotEmpty)
                    ? detailsBuilder!(user, raw)
                    : null,
              );
            },
          ),
        ),
        AppInputView(
          title: fields.getField('khatib_ids')?.label ?? 'أسماء الخطباء',
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: khatibs.length,
            itemBuilder: (context, index) {
              final user = khatibs[index];
              final raw = (khatibsRaw != null && index < (khatibsRaw!.length)) ? khatibsRaw![index] : const <String, dynamic>{};
              return MosqueMansoobCard(
                user: user,
                footer: (detailsBuilder != null && raw.isNotEmpty)
                    ? detailsBuilder!(user, raw)
                    : null,
              );
            },
          ),
        ),
        AppInputView(
          title: fields.getField('khadem_ids')?.label ?? 'أسماء الخدم',
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: khadems.length,
            itemBuilder: (context, index) {
              final user = khadems[index];
              final raw = (khademsRaw != null && index < (khademsRaw!.length)) ? khademsRaw![index] : const <String, dynamic>{};
              return MosqueMansoobCard(
                user: user,
                footer: (detailsBuilder != null && raw.isNotEmpty)
                    ? detailsBuilder!(user, raw)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}


