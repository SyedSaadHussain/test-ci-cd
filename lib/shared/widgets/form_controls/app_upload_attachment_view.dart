import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/ir_attachment.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/shared/widgets/wave_loader.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AppUploadAttachmentView extends StatefulWidget {
  final String? title;
  final Attachment attachment;
  final Function? onDelete;
  final String baseUrl;
  final String? downloadPath;
  final String? queryString;
  final int? id;
  final dynamic headersMap;
  final bool isALlowDelete;
  AppUploadAttachmentView({this.title,required this.attachment,required this.headersMap,this.onDelete,this.isALlowDelete=true,required this.baseUrl,this.downloadPath,this.id,this.queryString});
  @override
  _AppUploadAttachmentViewState createState() => _AppUploadAttachmentViewState();
}


class  _AppUploadAttachmentViewState extends State<AppUploadAttachmentView> {

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text((widget.title??""),style:AppTextStyles.formLabel.copyWith(color: Colors.black.withOpacity(.3)))),

          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.05),
            borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
          ),
          width: (MediaQuery.of(context).size.width / 2)-20,
          alignment: Alignment.center,
          child: Stack(
            children: [
              ListTile(


                contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                onTap: () async{
                  if(this.widget.attachment.base64!=null){
                    // setState(() {
                    //   this.widget.attachment.isLoading=true;
                    // });
                    try{
                      final Directory appDocDir = await getApplicationDocumentsDirectory();
                      final String appDocPath = appDocDir.path;
                      final Uint8List bytes;
                      bytes = base64Decode(this.widget.attachment.base64??"");

                      // Determine file extension based on content type
                      final contentType = lookupMimeType("", headerBytes: bytes.sublist(0, 10)) ?? "application/octet-stream";
                      //final String contentType = response.headers['content-type'].toString();
                      final String fileExtension = contentType.split('/').last;
                      print(fileExtension);

                      // Generate a unique file name with the determined extension
                      final String fileName = 'sample.${fileExtension.toLowerCase()}';
                      final String filePath = '$appDocPath/$fileName';
                      File file = File(filePath);
                      await file.writeAsBytes(  bytes);
                      final result = await OpenFilex.open(filePath).then((value) {

                      }).catchError((e){
                        print(e);
                      });

                    }
                    catch(e){
                      setState(() {
                        this.widget.attachment.isLoading=false;
                      });
                      return null;
                    }
                    return;
                  }
                  print('saad');
                  var urlToOpen='';
                  if(this.widget.downloadPath!=null){
                    urlToOpen="${this.widget.baseUrl}${this.widget.downloadPath}/${this.widget.attachment.id}?re_id="+this.widget.id.toString();
                  }else{
                    urlToOpen="${this.widget.baseUrl}/web/content/${this.widget.attachment.id==0?'':this.widget.attachment.id.toString()}?download=true"+(this.widget.queryString??'').toString();

                  }

                  print(urlToOpen);

                  setState(() {
                    this.widget.attachment.isLoading=true;
                  });
                  try {

                    setState(() {
                      this.widget.attachment.isLoading=true;
                    });
                    final response = await http.get(Uri.parse(urlToOpen), headers: this.widget.headersMap);

                    if (response.statusCode == 200) {
                      setState(() {
                        this.widget.attachment.isLoading=false;
                      });
                      final Directory appDocDir = await getApplicationDocumentsDirectory();
                      final String appDocPath = appDocDir.path;
                      final Uint8List bytes = response.bodyBytes;


                      // Determine file extension based on content type
                      final String contentType = response.headers['content-type'].toString();
                      final String fileExtension = contentType.split('/').last;

                      // Generate a unique file name with the determined extension
                      final String fileName = 'sample.${fileExtension.toLowerCase()}';
                      final String filePath = '$appDocPath/$fileName';
                      File file = File(filePath);

                      await file.writeAsBytes(bytes);

                      final result = await OpenFilex.open(filePath).then((value) {
                      }).catchError((e){
                        print('error ..');
                        print(e);
                      });



                    } else {
                      setState(() {
                        this.widget.attachment.isLoading=false;
                      });
                      // Handle errors

                    }
                  } catch (e) {
                    // Handle exceptions
                    print(e);
                    setState(() {
                      this.widget.attachment.isLoading=false;
                    });

                  }
                },
                leading : this.widget.attachment.icon,
                title: Text(
                  this.widget.attachment.nameOnly??"",
                  style: TextStyle(color: AppColors.primary,fontSize: 12),overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(this.widget.attachment.extension,style: TextStyle(color: Colors.grey,fontSize: 10),),
              ),
              this.widget.attachment!.isLoading?Container(
                color: Colors.grey.withOpacity(.5),
                width: double.infinity,
                height: 70,
                child: Center(child: WaveLoader(color: Colors.white,size: 25)),
              ):Container(),
              this.widget.onDelete==null?Container():Positioned(
                  bottom: 0.0, // Distance from the bottom
                  right: 0.0, // Distance from the right
                  child: Container(
                    color: Colors.grey.withOpacity(.5),
                    height: 30,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            if(this.widget.onDelete!=null)
                            {
                              this.widget.onDelete!();
                            }

                            // this.widget.repository.createLeave(leave);
                          },

                          child: Container(
                              height: double.infinity,
                              padding: EdgeInsets.all(5),
                              color: Colors.black.withOpacity(.1),
                              child: Icon(Icons.delete_outline,color: Colors.white.withOpacity(.8),size: 20,)),
                        ),
                      ],
                    ),
                  )),


            ],
          ),
        ),
      ],
    );
  }



}