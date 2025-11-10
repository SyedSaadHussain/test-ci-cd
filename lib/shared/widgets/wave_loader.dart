import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WaveLoader extends StatefulWidget {
  final Color color;
  final double size;
  WaveLoader({this.color=AppColors.gray,this.size=50});
  @override
  _WaveLoaderState createState() => _WaveLoaderState();
}

class  _WaveLoaderState extends State<WaveLoader> {

  @override
  void initState() {

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingAnimationWidget.staggeredDotsWave(
          color: this.widget.color,
          size: this.widget.size,
        ),
      ],
    );
  }



}