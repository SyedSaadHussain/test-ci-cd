import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

Widget AppButton({Function? onTab,String value="",String text="",IconData? icon,
  Color color= AppColors.defaultColor, Color onColor= AppColors.defaultColor,bool isFullWidth=true,bool isOutline=false}) {

  return  TextButton(
    onPressed:  (){
      if(onTab!=null)
        onTab();
    },
    child:  Row(
      mainAxisSize:isFullWidth?MainAxisSize.max:MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon==null?Container():Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Icon(icon,color:Colors.white.withOpacity(.8) ,size: 13,),
        ),
        Text(text??"",style: TextStyle(color: isOutline?color:Colors.white.withOpacity(.8)),),
      ],
    ),
    style:isOutline==false?TextButton.styleFrom(
      backgroundColor: onTab==null?color.withOpacity(.6):color, // Background color
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
    ):TextButton.styleFrom(
      backgroundColor: Colors.transparent, // Transparent background color
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0), // Padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0), // Rounded corners
        side: BorderSide(color: color, width: 1), // Outline color and width
      ),
    ),
  );
}


Widget AppButtonSmall({Function? onTab,String value="",String text="",IconData? icon,
  Color color= AppColors.defaultColor, Color? onColor,bool isFullWidth=true,bool isOutline=false}) {

  return  TextButton(
    onPressed:  (){
      if(onTab!=null)
        onTab();
    },
    child:  Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        decoration: BoxDecoration(
          color: isOutline?Colors.transparent:color,
          borderRadius: BorderRadius.circular(15.0), // Set the radius here
          border: isOutline
              ? Border.all(color: color, width: 1) // Border when outline is true
              : null, // No bor
        ),
        child: Row(
          mainAxisSize:isFullWidth?MainAxisSize.max:MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon==null?Container():Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Icon(icon,color:isOutline?color:(onColor??Colors.white.withOpacity(.8)) ,size: 13,),
            ),
            Text(text??"",style: TextStyle(color: isOutline?color:(onColor??Colors.white.withOpacity(.8))),),
          ],
        )
    ),

  );
}