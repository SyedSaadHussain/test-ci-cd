import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';


Widget CategoryItem(
    {Function? onTab, String value = "", String text = "", IconData icon = Icons
        .add,
      Color? color, Color? onColor, String? iconPath, bool isIconPathColor = true}) {
  return GestureDetector(
    onTap: () {
      if (onTab != null)
        onTab();
    },

    child: Container(
      padding: EdgeInsets.all(10),

      decoration: BoxDecoration(

        shape: BoxShape.rectangle,
        color: color ?? AppColors.secondly.withOpacity(.1),
        borderRadius: new BorderRadius.all(Radius.circular(8.0)),
        border: Border.all(
          color: AppColors.secondly.withOpacity(.3),
          // Change this to the color you want for the border
          width: 0.0, // You can adjust the width of the border as needed
        ),
      ),
      width: double.infinity,
      //width: 100,

      // width: double.infinity,
      margin: EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              // width: double.infinity,

              child:iconPath==null?Icon(icon, size: 50,
                color: onColor ?? AppColors.secondly.withOpacity(.8),):
              Image.asset(
                iconPath, // Path to your SVG file
                height: 35, // Set the height for the icon
                width: 35, // Set the width (optional)
                color: onColor ?? AppColors.secondly.withOpacity(.8),
              ),


            ),
          ),
          Text(text,style: TextStyle(color: AppColors.primary,fontSize: 20), textAlign: TextAlign.center,),

        ],
      ),
    ),
  );
}

