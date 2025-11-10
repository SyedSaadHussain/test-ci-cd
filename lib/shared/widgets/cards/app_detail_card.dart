import 'package:flutter/material.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';

class AppDetailCard extends StatelessWidget {
  final Widget child;

  AppDetailCard({
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          padding: EdgeInsets.only(top: 10,right: 10,left: 10,bottom: 20),
          child: child),
    );
  }
}