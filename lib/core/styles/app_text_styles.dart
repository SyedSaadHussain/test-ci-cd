import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

class AppTextStyles {

  static TextStyle  get cardTitle => TextStyle(
    color:Colors.black.withOpacity(.7),fontSize: 13,
  );

  static TextStyle  get cardSubTitle => TextStyle(
    color:Colors.grey,fontSize: 12,
  );

  static TextStyle  get formLabel =>
      TextStyle(color: Colors.black.withOpacity(.7),fontSize: 13,fontWeight: FontWeight.w500);

  static TextStyle  get warningLabel =>
      TextStyle(color: AppColors.deepRed,fontSize: 13,fontWeight: FontWeight.bold);

  static TextStyle  get errorLabel =>
      TextStyle(color: Colors.red,fontSize: 14,fontWeight: FontWeight.normal);


  static TextStyle  get headingLG =>
      TextStyle(color: Colors.black.withOpacity(.7),fontSize: 20,fontWeight: FontWeight.w500);

}