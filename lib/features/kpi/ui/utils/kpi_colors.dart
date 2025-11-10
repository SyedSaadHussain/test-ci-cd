import 'package:flutter/material.dart';

class KpiColors {
  static const List<Color> colors = [
    Color(0xff27ae60), // Bright green
    Color(0xff2ecc71), // Lighter green
    Color(0xff16a085), // Teal green
    Color(0xffff6b6b), // Red (for rejected/canceled)
    Color(0xff95a5a6), // Gray (for neutral)
    Color.fromARGB(255, 235, 177, 4), // Red (for rejected/canceled)
  ];

  static Color getColor(int index) {
    return colors[index % colors.length];
  }
}
