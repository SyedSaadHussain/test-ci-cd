import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

class AppInputDecoration {
  // First InputDecorationTheme
  static InputDecoration firstInputDecoration(BuildContext context,{String? label,IconData? icon,Function? onTab}) {

    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(.0), // Set your desired border color here
      ),
    );

    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
      suffixIcon: icon==null?null:GestureDetector(
          onTap: (){
            if(onTab!=null){
              onTab!();
            }
          },
          child: Icon(icon,color: Colors.grey.withOpacity(.5),)),
      labelStyle: TextStyle(color: Colors.blue), // Set label text color
      hintStyle: TextStyle(color: Colors.blue),
      label: Text(label??"",style: TextStyle(color: Colors.grey.withOpacity(.4)),),
      fillColor: Colors.grey.withOpacity(.15),


      // Customize the appearance of the input fields for the first theme
      focusedBorder: outlineInputBorder,
      enabledBorder: outlineInputBorder,
      border: outlineInputBorder,
      // Add more customizations as needed
    );
  }

  static InputDecoration secondInputDecoration(BuildContext context,{String? label,IconData? icon,Function? onTab,
    TextEditingController? control
  }) {

    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Colors.white.withOpacity(.2), // Set your desired border color here
      ),

    );

    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
      suffixIcon: icon==null?null:Container(
        width: 100,
        child: Row(
          children: [
            Expanded(child: Container()),

            (control!=null && control.text.isNotEmpty)?IconButton(
              icon: Icon(Icons.close, color: Colors.grey.withOpacity(0.5)),
              onPressed: () {
                control.text='';
                if(onTab!=null)
                  onTab();
              },
            ):Container(),
            IconButton(
              icon: Icon(icon, color: Colors.grey.withOpacity(0.5)),
              onPressed: () {
                if(onTab!=null)
                  onTab();
              },
            ),
          ],
        ),
      ),
      labelStyle: TextStyle(color: Colors.blue), // Set label text color
      hintStyle: TextStyle(color: Colors.blue),
      label: Text(label??"",style: TextStyle(color: AppColors.hint),),
      //fillColor: Colors.white.withOpacity(.2),

      // Customize the appearance of the input fields for the first theme
      focusedBorder: outlineInputBorder,
      enabledBorder: outlineInputBorder,
      border: outlineInputBorder,
      // Add more customizations as needed
    );
  }

  static InputDecoration defaultInputDecoration({String? label,IconData? icon,Function? onTab
  ,bool? isCloseIcon,Function? onClose}) {

    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Colors.white.withOpacity(.2), // Set your desired border color here
      ),

    );

    return InputDecoration(
      filled: true, // Fill the background
      fillColor: Colors.grey.shade100, // Set background color to transparent
      contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
      suffixIcon: icon==null?null:Container(
        width: 100,
        child: Row(
          children: [
            Expanded(child: Container()),

            (isCloseIcon??false)?
            InkWell(
              onTap: () {
                if (onClose != null) onClose();
              },
              borderRadius: BorderRadius.circular(20), // optional
              child: Icon(Icons.close, color: Colors.grey, size: 20),
            ):Container(),

            IconButton(
              icon: Icon(icon,color: Colors.grey,),
              onPressed: () {
                if(onTab!=null)
                  onTab();
              },
            )

            // GestureDetector(
            //   onTap: (){
            //
            //   },
            //   child: Container(
            //       padding: EdgeInsets.symmetric(horizontal: 10),
            //       child: Icon(icon, color: AppColors.gray,size: 20,)),
            // ),
          ],
        ),
      ),
      labelStyle: TextStyle(color: Colors.blue), // Set label text color
      hintStyle: TextStyle(color: AppColors.hint),
      // label: Text(label??"",style: TextStyle(color: AppColors.hint),),
      hintText: label??"",
      //fillColor: Colors.white.withOpacity(.2),

      // Customize the appearance of the input fields for the first theme
      focusedBorder: outlineInputBorder,
      enabledBorder: outlineInputBorder,
      border: outlineInputBorder,
      // Add more customizations as needed
    );
  }

  static InputDecoration dropDownDecoration({Color? color}) {

    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        filled: true, // This will make sure the background is filled
        fillColor: color??Colors.grey[200], // Background color
        border: OutlineInputBorder( // Optional: Add border
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        hintText: '',
        alignLabelWithHint: true
    );
  }
}