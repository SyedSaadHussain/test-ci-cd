import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/model.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/ir_attachment.dart';
import 'package:mosque_management_system/core/models/khutba_management.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/attachment_card.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class KhutbaAttachmentButton extends StatelessWidget {
  final KhutbaManagement khutba;
  final dynamic headersMap;
  final FieldListData fields;

  const KhutbaAttachmentButton({
    super.key,
    required this.khutba,
    required this.headersMap,
    required this.fields,
  });

  @override
  Widget build(BuildContext context) {
   var appUserProvider = context.read<UserProvider>();
    if (!AppUtils.isNotNullOrEmpty(khutba.attachment)) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AttachmentCard(
        child: Row(
          children: [
            Text(fields.getField('attachment').label,
                style: const TextStyle(color: Colors.white)),
            const Icon(Icons.download),
          ],
        ),
        baseUrl: appUserProvider.baseUrl,
        headersMap: headersMap,
        attachment: Attachment(
          id: 0,
          name: 'download'.tr() + '.file',
          mimetype: 'application/download',
        ),
        queryString:
        '&model=${Model.khutbaManagement}&id=${khutba.id}&field=attachment&unique=${khutba.uniqueId}',
      ),
    );
  }
}
