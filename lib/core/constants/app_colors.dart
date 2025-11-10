import 'dart:ui';
import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // this basically makes it so you can't instantiate this class
  static const Color primary = Color(0xFF1d6d47);
  static const Color primaryContainer = Color(0xFF8cd177);
  static const Color onPrimary = Color(0xffc9e5d8);
  static const Color onPrimaryLight = Color(0xffeff8f4);
  static const Color secondly = Color(0xffd0db84);
  static const Color tertiary = Color(0xff936514);
  static const Color flushColor = Color(0xff74a063);
  static const Color backgroundColor = Color(0xFFf9f9f9);

  static const Color formField = Color(0xFFf1f1f1);
  static const Color formDisabledField = Color(0xFFe6e6e6);
  static const Color body = Color(0xFFf6e6e6e);

  static const Color formText = Color(0xff83a1c3);

  static const Color bodyText = Color(0xff818181);

  static const Color onSecondly = Color(0xfffbffde);
  static const Color primaryText = Color(0xFFd0d4ee);
  static const Color gray = Color(0xFF979797);
  static const Color hint = Color(0xFFc1c1c1);

  static const Color other = Color(0xFF363689);
  static const Color success = Color(0xFF53af43);
  static const Color danger = Color(0xFFd93025);
  static const Color info = Color(0xFF129eaf);
  static const Color warning = Color(0xFFe37400);
  static const Color yellow = Color(0xFFeeab01);
  static const Color defaultColor = Color(0xFF6c8492);
  static const Color low = Color(0xFF81C784);
  static const Color actionButtons = Color(0xFF2E8D64);

  //New color
  static const Color mainColor = Color(0xFF1875E2);
  static const Color buttonColor = Color(0xFF1875E2);
  static const Color cardBackground = Color(0xffF3F9FE);
  static const Color background = Color(0xFFF6F6F6);
  static const Color primaryBorder = Color(0xFFF3E9E7);
  static const Color primaryGradient = Color(0xff00a7ab);
  static const Color deepRed = Color(0xFFBE5258);
  static const Color appBar = Colors.white;
  static const Color appColor = Color(0xFF1F0732);
  static const Color gradientOne = Color(0xFF00a8e6);
  static const Color gradientTwo = Color(0xDA0DC21E);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color deepGreen = Color(0xFF07936C);
  static const Color bg = Color(0xFFF5F5F5);

  // Additional colors for mosque utilities
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color accent = Color(0xFF4299E1);
  static const Color surface = Color(0xFFFFFFFF);
  // static const Color cardBackground = Color(0xFFF7FAFC);
  // static const Color background = Color(0xFFF6F5F5);
}

// Mapping Odoo classes to colors
final Map<int, Color> OdooColor = {
  1: Color(0xFFF06050),
  2: Color(0xFFF4A460),
  3: Color(0xFFF7CD1F),
  4: Color(0xFF6CC1ED),
  5: Color(0xFF814968),
  6: Color(0xFFEB7E7F),
  7: Color(0xFF2C8397),
  8: Color(0xFF475577),
  9: Color(0xFFD6145F),
  10: Color(0xFF30C381),
};
