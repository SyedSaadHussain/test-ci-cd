import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/shared/widgets/open_camera_screen.dart';

class AppAttachmentField extends StatefulWidget {
  final Function? onSave;
  final Function? onTab;
  final Function? onChanged;
  final String? title;
  final bool? isMemory;
  final bool isRequired;
  final dynamic headersMap;
  final dynamic value;
  final dynamic path;
//List<DropdownMenuItem<String>>
  AppAttachmentField({
    this.onSave,this.onTab,this.onChanged,this.title,this.value,this.path,
    this.isRequired=false,this.headersMap,this.isMemory=true
    });

  @override
  _AppAttachmentFieldState createState() => _AppAttachmentFieldState();
}

class  _AppAttachmentFieldState extends State<AppAttachmentField> {
  late dynamic selectedValue;


  @override
  void initState() {
    super.initState();
    print(widget.path);
    base64Content = widget.value?.toString();
    path = widget.path?.toString();
  }


  //update when parent wiget rebuild
  @override
  void didUpdateWidget(covariant AppAttachmentField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          base64Content = widget.value?.toString();
        });
      });
    } else if (oldWidget.path != widget.path) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          path = widget.path?.toString();
        });
      });
    }
  }


  String? base64Content;
  String? path;
  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }
  // final TextEditingController _controller = TextEditingController();
  final OutlineInputBorder outlineInputBorder = OutlineInputBorder(

    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
      color: Colors.grey, // Adjust opacity or use Colors.grey directly
      width: 1.0, // This ensures it's 1px wide
    ),
  );

  @override
  Widget build(BuildContext context) {




    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Text(this.widget.title??"",style:AppTextStyles.formLabel),

        Container(
          child:
          FormField<int>(
              validator: (value) {
                if (this.widget.isRequired &&
                    (AppUtils.isNotNullOrEmpty(base64Content)==false
                    && (AppUtils.isNullOrEmpty(widget.path) || AppUtils.isNullOrEmpty(path))
                    )) {
                  return 'please_take_a_picture'.tr();
                }
                return null;
              },
              builder: (FormFieldState<int> field) {
                return  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        shape: BoxShape.rectangle,
                        // color: AppColors.backgroundColor,
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Stack(
                        children: [   // Adjust radius as needed

                          Container(
                              width: 90,
                              height: 90,
                          ),

                          AppUtils.isNullOrEmpty(base64Content)?Container(
                            width: 90,
                            height: 90,
                            child:  ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: (AppUtils.isNotNullOrEmpty(path))
                                  ? Image.network(
                                path!,
                                headers: this.widget.headersMap,
                                fit: BoxFit.fitHeight,
                                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                  path=null;
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey.shade300,
                                      size: 65,
                                    ),
                                  );
                                },
                              )
                                  : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade300,
                                  size: 65,
                                ),
                              ),
                            ),
                          ):Image.memory(
                            base64Decode(base64Content!),
                            fit: BoxFit.cover, // You can change the BoxFit as per your requirement
                          ),
                          // if (field.hasError &&  AppUtils.isNullOrEmpty(base64Content))
                          //   Container(
                          //     width: 90,
                          //     height: 90,
                          //     child: ClipRRect(
                          //       borderRadius: BorderRadius.circular(8.0),
                          //       child: Container(
                          //         color: Colors.red.shade50, // Optional background
                          //         child: Center(
                          //           child: Icon(
                          //             Icons.person,
                          //             color: Colors.red.shade200,
                          //             size: 65,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                        onTap: () async{
                                          try{
                                            final ImagePicker _picker = ImagePicker();

                                            XFile? image =  await Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => OpenCameraScreen()),
                                            );
                                            // XFile? image = await _picker.pickImage(source: ImageSource.camera,imageQuality: 100,
                                            //
                                            // );


                                            if(image!=null){
                                              Uint8List? unitBytes=await image!.readAsBytes();
                                              // final compressedBytes = await FlutterImageCompress.compressWithList(
                                              //   unitBytes,
                                              //   quality: SystemDefault.compressedValue,
                                              // );
                                              base64Content = base64Encode(unitBytes!);
                                              int sizeInBytes = unitBytes.length;
                                              // base64Content = base64Encode(compressedBytes!);
                                              // int sizeInBytes = compressedBytes.length;


                                              // Size in kilobytes
                                              double sizeInKB = sizeInBytes / 1024;

                                              // Size in megabytes
                                              double sizeInMB = sizeInKB / 1024;

                                              print("Size: $sizeInBytes bytes");
                                              print("Size: ${sizeInKB.toStringAsFixed(2)} KB");
                                              print("Size: ${sizeInMB.toStringAsFixed(2)} MB");
                                              setState(() {

                                              });
                                              if (widget.onChanged != null) widget.onChanged!(base64Content);
                                            }
                                          }catch(e){
                                            print('error in camera');
                                            print(e);
                                          }

                                          // FilePickerResult? result = await FilePicker.platform.pickFiles(
                                          //   // type: FileType.custom,
                                          //   // allowedExtensions: ['jpg', 'png', 'jpeg'],
                                          // );
                                          // if (result != null) {
                                          //   PlatformFile file = result.files.first;
                                          //   File file1 = File(file.path!);
                                          //   List<int> bytes = await file1.readAsBytes();
                                          //   if (bytes != null) {
                                          //     String base64Content = base64Encode(bytes!);//For database
                                          //     unitBytes= base64Decode(base64Content);//For Viewer
                                          //     this.widget.onChanged!(base64Content);
                                          //     setState(() {
                                          //
                                          //     });
                                          //
                                          //   }
                                          // }
                                        },
                                        child:Container(
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            color: Colors.grey.withOpacity(.7),
                                            child: Icon(Icons.edit,color:  Colors.white.withOpacity(.8),size: 20,))),
                                  ),

                                  Expanded(child: GestureDetector(
                                    onTap: (){

                                      base64Content=null;
                                      path=null;
                                      setState(() {

                                      });
                                      if(this.widget.onChanged!=null)
                                        this.widget.onChanged!(null);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 5),
                                        color: Colors.grey.withOpacity(.7),
                                        child: Icon(Icons.delete_outline,color:  Colors.white.withOpacity(.8),size: 20)),
                                  )),
                                ],
                              )),
                        ],
                      ),
                    ),
                    if (field.hasError)
                      Text('please_take_a_picture'.tr(),style: AppTextStyles.errorLabel,),
                  ],
                );
              }
          )


        ),

      ],

    );
  }



}
