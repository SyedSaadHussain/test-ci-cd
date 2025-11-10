import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/ir_attachment.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/features/visit/core/constants/system_default.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_upload_attachment_field.dart';
import 'package:provider/provider.dart';

class UploadAttachmentModel{
   final int id;
   String? name;
   dynamic base64;

   UploadAttachmentModel({required this.id,this.name,this.base64});

   factory UploadAttachmentModel.fromJson(Map<String, dynamic> json) {
     return UploadAttachmentModel(
       id: 0,
       name: json['name'],
       base64: json['data'],
     );
   }
}
 class TakeVisitActionModel{
  String? notes;
  List<UploadAttachmentModel> actionAttachments;
  String? attachment;
  String? attachmentName;
  String? image;
  String? actionTakenTypeId;
  String? trasolNumber;
  String? disclaimer;
  bool? isApproved;
  bool? actionGranted;

  // Constructor
  TakeVisitActionModel({
    this.notes,
    this.attachment,
    this.image,
    this.actionTakenTypeId,
    this.trasolNumber,
    this.disclaimer,
    this.isApproved,
    this.actionGranted
  }): actionAttachments =  [];

}
void takeActionDisclaimerDialog<T extends VisitModelBase>(BuildContext context,
    {String? text,Function? onApproved,FieldListData? fields,
    List<ComboItem>? actionTypes
    }) {
  TakeVisitActionModel action=TakeVisitActionModel();
  final _formKey = GlobalKey<FormState>();
  showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true, // allows full-screen scrollable sheet
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, StateSetter setState) {
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          return Padding(
            padding: EdgeInsets.only(
              bottom: bottomInset, // keyboard safe area
              left: 16,
              right: 16,
              top: 12,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 16),
                  // Text(
                  //   'terms_condition'.tr(),
                  //   style: const TextStyle(
                  //       fontSize: 18, fontWeight: FontWeight.bold),
                  // ),
                  const SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppInputField(
                          value: action.notes,
                          title: fields!.getField('action_notes').label,
                          isRequired: true,
                          onChanged: (val) {
                            action.notes = val;
                            setState(() {});
                          },
                        ),
                        AppUploadAttachmentField(
                          title: fields.getField('action_attachments').label,
                          item: action.attachmentName,
                          attachments: action.actionAttachments,
                          isEditMode: true,
                          isRequired: true,
                          onDelete: (id) {
                            action.actionAttachments
                                .removeWhere((a) => a.id == id);
                            setState(() {});
                          },
                          onUpload: (Attachment file) {
                            action.actionAttachments.add(UploadAttachmentModel(
                              id: AppUtils.getUniqueId(),
                              name: file.name,
                              base64: file.base64,
                            ));
                            setState(() {});
                          },
                        ),

                        AppSelectionField(
                          value: action.actionTakenTypeId,
                          title: fields.getField('action_taken_type_id').label,
                          options: actionTypes,
                          isRequired: true,
                          onChanged: (val) {
                            action.actionTakenTypeId = val;
                            setState(() {});
                          },
                        ),
                        AppInputField(
                          value: action.trasolNumber,
                          title: fields.getField('trasol_number').label,
                          isRequired: true,
                          onChanged: (val) {
                            action.trasolNumber = val;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(fields.getField('action_granted').label),
                      const Spacer(),
                      Switch(
                        inactiveThumbColor: AppColors.gray.withOpacity(.5),
                        inactiveTrackColor: AppColors.gray.withOpacity(.3),
                        value: action.actionGranted ?? false,
                        onChanged: (value) {
                          setState(() {
                            action.actionGranted = value;
                          });
                        },
                      ),
                    ],
                  ),
                   Row(
                    children: [
                      Text('accept_terms_condition'.tr()),
                      const Spacer(),
                      Switch(
                        inactiveThumbColor: AppColors.gray.withOpacity(.5),
                        inactiveTrackColor: AppColors.gray.withOpacity(.3),
                        value: action.isApproved ?? false,
                        onChanged: (value) {
                          setState(() {
                            action.isApproved = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Text('*'+VisitDefaults.declarationText,style: TextStyle(color: AppColors.gray),),


                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: VisitMessages.approve,
                          onTab: ((action.isApproved ?? false) && (action.actionGranted??false))
                              ? () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.of(context).pop(true);
                            }
                          }
                              : null,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          text: VisitMessages.reject,
                          onTab: () {
                            Navigator.of(context).pop(false);
                          },
                          color: AppColors.defaultColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      );
    },
  ).then((res) {
    if (res == true && onApproved != null) {
      onApproved(action);
    }
  });

}
