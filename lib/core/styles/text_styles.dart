import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

class AppTextStyles {
  // Method to get the desired text style
  static TextStyle get formLabel => TextStyle(
    color: Colors.grey,
    fontSize: 13,
    fontWeight: FontWeight.w300,
  );

  static TextStyle get textForm => TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w300,
  );

  static TextStyle get defaultHeading1 => TextStyle(
    color: Colors.grey,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get heading1 => TextStyle(
    color: Colors.grey,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static TextStyle get heading2 => TextStyle(
    color: Colors.grey,
    fontSize: 24,
  );

  static TextStyle get defaultHeadingSm => TextStyle(
    color: Colors.grey,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );


  static TextStyle get headerText => TextStyle(
    color: AppColors.onPrimaryLight,
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get appBarTitle => TextStyle(
      fontSize: 18,color: AppColors.onPrimary
  );

  static TextStyle get primaryTitle => TextStyle(
      fontSize: 18,color: AppColors.primary
  );


  static TextStyle  get cardTitle => TextStyle(
    color:Colors.black.withOpacity(.7),fontSize: 13,
  );

  static TextStyle  get hint => TextStyle(
    color:Colors.grey.withOpacity(.7),fontSize: 13,fontStyle: FontStyle.italic,
  );

  static TextStyle  get error => TextStyle(
    color:Colors.red.withOpacity(.7),fontSize: 13,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold
  );

  static TextStyle  get cardTitleHeading => TextStyle(
    color:Colors.black.withOpacity(.7),fontSize: 15,fontWeight: FontWeight.bold
  );

  static TextStyle  get cardSubTitle => TextStyle(
    color:Colors.grey,fontSize: 12,
  );



  static TextStyle get headerTextLight => TextStyle(
    color: AppColors.onPrimaryLight,
    fontSize: 13,
    fontWeight: FontWeight.w300,
  );
}