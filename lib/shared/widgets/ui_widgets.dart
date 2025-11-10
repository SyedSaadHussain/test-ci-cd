import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/shared/widgets/wave_loader.dart';


Widget AppBackground() {

  return Positioned.fill(
    child: Opacity(
      opacity: .4,
      child: Image.asset(
        'assets/images/splash.png', // Replace with your image URL
        fit: BoxFit.cover,
      ),
    ),
  );
}

Widget AppCustomBar({String? title,List<Widget>? actions, TextStyle? style}) {

  return AppBar(
    backgroundColor: Colors.transparent, // Make AppBar transparent
    title: Text(title??"",style: style != null
    ? AppTextStyles.appBarTitle.copyWith(
      fontSize: style.fontSize,
      color: style.color,
      fontWeight: style.fontWeight,
      // Add other style fields as needed
    )
          : AppTextStyles.appBarTitle),
    iconTheme:  IconThemeData(
      color: AppColors.onPrimary, // Change this to your desired icon color
    ),// Your title here
    actions: actions??[],
  );
}


