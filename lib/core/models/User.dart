import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class User {
  final int userId;
  final String? proxy;

  User({
    required this.userId,
    this.proxy
  });
}