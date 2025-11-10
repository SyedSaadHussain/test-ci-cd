import 'package:flutter/material.dart';

class TabModel {
  final String? key;
  final String name;
  final String url;
  final String? response;
  final IconData? icon;
  bool isLoaded;

  TabModel({
    this.key,
    required this.name,
    required this.url,
    this.response,
    this.icon,
    this.isLoaded = false,
  });
}