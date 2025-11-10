import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class StatItem {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  String get translatedLabel => label.tr();
}
