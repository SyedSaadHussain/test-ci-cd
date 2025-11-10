
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mime/mime.dart';
import 'package:mosque_management_system/core/models/ir_attachment.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/takeaction_disclaimer_dialog.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';

class AppUploadAttachmentField extends StatefulWidget {

  final  String? title;
  final  bool isEditMode;
  final Function? onUpload;
  final Function? onDelete;
  final Function? onEdit;
  final Function? builder;
  final IconData? buttonIcon;
  final bool isRequired;
  final Widget? actions;
  List<DropdownMenuItem<String>>? selections;
  List<dynamic>? data;
  dynamic item;
  List<UploadAttachmentModel>? attachments;


//List<DropdownMenuItem<String>>
  AppUploadAttachmentField({this.title,this.isEditMode=false,this.data,this.onUpload,this.onDelete,this.onEdit,this.builder,this.buttonIcon,this.isRequired=false,this.actions,this.item,this.attachments});

  @override
  _AppUploadAttachmentFieldState createState() => _AppUploadAttachmentFieldState();
}

class  _AppUploadAttachmentFieldState extends State<AppUploadAttachmentField> {
  @override
  void initState() {

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  bool isLoadingAttachment=false;

  final TextEditingController _controller = TextEditingController();
  final OutlineInputBorder outlineInputBorder = OutlineInputBorder(

    borderRadius: BorderRadius.circular(15.0),
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(.0), // Set your desired border color here
    ),
  );

  bool isTrue=true;

  @override
  Widget build(BuildContext context) {

    return
      FormField<int>(
          validator: (value) {
            if (this.widget.isRequired &&
                (this.widget.attachments == null || (this.widget.attachments!=null && this.widget.attachments!.length==0))) {
              return 'please_upload_file'.tr();
            }
            return null;
          },
          builder: (FormFieldState<int> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          this.widget.title!.isEmpty?Container(): Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Expanded(child: Row(
                                  children: [
                                    Text(this.widget.title??"",style:AppTextStyles.formLabel),
                                  ],
                                )),
                                this.widget.isEditMode?
                                AppButtonSmall(
                                  onTab: () async {
                                    try {
                                      print('Pick file start');
                                      print(await FilePicker.platform);
                                      print('Pick file start');
                                      // Pick file
                                      FilePickerResult? result = await FilePicker.platform.pickFiles();
                                      print('Pick file done');

                                      if (result != null) {
                                        PlatformFile pickedFile = result.files.single; // get picked file info
                                        File file = File(pickedFile.path!);

                                        // Convert to bytes and then to Base64
                                        List<int> fileBytes = await file.readAsBytes();
                                        String base64String = base64Encode(fileBytes);

                                        // Get MIME type
                                        String? mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

                                        // Create attachment
                                        Attachment _attachment = Attachment(
                                          id: 0,
                                          name: pickedFile.name, // safe
                                          mimetype: mimeType,
                                          base64: base64String,
                                          isShowDeleteButton: true,
                                        );

                                        // Call callback if exists
                                        if (widget.onUpload != null) {
                                          widget.onUpload!(_attachment);
                                        }
                                      } else {
                                        print('No file selected');
                                      }
                                    } catch (e) {
                                      print('File pick error: $e');
                                    }
                                  },
                                  text: 'add'.tr(),
                                  icon: widget.buttonIcon ?? Icons.file_copy,
                                ):
                                this.widget.actions??Container(),

                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              children:
                              (this.widget.attachments??[]).map((action) {
                                  return Row(
                                  children: [
                                        Expanded(child: Text(action.name??"")),
                                        IconButton(icon: Icon(Icons.delete),onPressed: (){
                                          widget.onDelete!(
                                              action.id
                                          );
                                        },)
                                      ],
                                    );
                                }).toList()

                            ),
                          ),

                        ],
                      ),
                      // subtitle: Text(subTitle,style: TextStyle(color: Colors.black.withOpacity(.8),fontSize: 15)),

                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                      field.errorText ?? '',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],

            );
          }
      );
  }



}
