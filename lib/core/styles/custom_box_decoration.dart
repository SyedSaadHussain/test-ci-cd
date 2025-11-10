import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

class AppBoxDecoration {
  // Method to get the desired text style
  static BoxDecoration get mainBody {
    return BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
      color: Colors.white,
    );
  }
}