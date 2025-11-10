import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:provider/provider.dart';

import '../data/repositories/electricity_repository.dart';
import 'electricity_view_model.dart';

class ElectricityProviderWrapper extends StatelessWidget {
  final Widget child;

  const ElectricityProviderWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ElectricityViewModel>(
      create: (_) {
        final vm = ElectricityViewModel(
          ElectricityRepository(
              CustomOdooClient.getInstance(EnvironmentConfig.baseUrl)),
        );
        // Async bootstraap from cached profile (roles + defaults)
        () async {
          final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);
          final userService = UserService(client);
          await userService.getCachedCrmUserInfo();

          return vm;
        }();
        return vm;
      },
      child: child,
    );
  }
}
