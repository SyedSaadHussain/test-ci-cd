import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/ir_attachment.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_upload_attachment_view.dart';
import 'package:provider/provider.dart';


class ActionTakenDetail extends StatefulWidget {
  final VisitModelBase visit;
  final FieldListData fields;

  const ActionTakenDetail({
    required this.visit,
    required this.fields,
    super.key,
  });

  @override
  State<ActionTakenDetail> createState() => _ActionTakenDetailState();
}

class _ActionTakenDetailState extends State<ActionTakenDetail> {
  dynamic headerMap;

  @override
  void initState() {
    super.initState();
    AppUtils.getHeadersMap().then((header) {
      setState(() {
        headerMap = header;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return widget.visit.isShowActionTakenPanel ?
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInputView(title: widget.fields
            .getField('action_notes')
            .label, value: widget.visit.actionNotes),

        AppInputView(title: widget.fields
            .getField('action_attachments')
            .label, child:
        LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 3,
                runSpacing: 3,
                children: [
                  ...(widget.visit.actionAttachments ?? []).map((rec) {
                    double width = (widget.visit.actionAttachments?.length == 1)
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 6) / 2;
                    return SizedBox(
                      width: width,
                      child: AppUploadAttachmentView(
                          baseUrl: TestDatabase.baseUrl,
                          headersMap: headerMap,
                          attachment: Attachment(id: rec,
                              name: VisitMessages.download,
                              mimetype: 'application/download')
                      ),
                    );
                  }),
                ],
              );
            }
        )
        ),

        AppInputView(title: widget.fields
            .getField('action_taken_type_id')
            .label,
          value: widget.visit.actionTakenType,),
        AppInputView(title: widget.fields
            .getField('trasol_number')
            .label,
            value: widget.visit.trasolNumber),
      ],
    ) : Container();
  }
}