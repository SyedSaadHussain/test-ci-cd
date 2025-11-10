import 'dart:async';
import 'dart:convert';import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class ServiceMenu {
  String name;
  String menuUrl;
  String? imagePath;
  bool? isImageColor;
  IconData icon;
  Color color;
  dynamic? filter;

  ServiceMenu({
    required this.name,
    required this.menuUrl,
    required this.color,
    required this.icon,
     this.isImageColor,
    this.imagePath,
    this.filter
  });
}
