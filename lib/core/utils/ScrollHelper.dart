// scroll_helper.dart
import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';

class ScrollHelper {
  static void scrollToTab({
     List<TabItem>? stages,
     int? activeButtonIndex,
    dynamic key,
    Duration duration = const Duration(milliseconds: 300),
    double alignment = 0.5,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dynamic _key;
      if(key==null){
        _key = (stages??[]).firstWhere(
              (rec) => rec.key == activeButtonIndex,
          orElse: () => TabItem(key: 0),
        ).globalKey;
      }
      else{
        _key=key;
      }

      if (_key == null) return;
      final context = _key.currentContext;
      if (context == null) return;

      Scrollable.ensureVisible(
        context,
        duration: duration,
        alignment: alignment,
        curve: Curves.easeInOut,
      );
    });

  }
}