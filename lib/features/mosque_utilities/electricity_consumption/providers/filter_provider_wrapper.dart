import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:provider/provider.dart';

import '../data/services/mosque_filter_service.dart';
import 'filter_provider.dart';

class FilterProviderWrapper extends StatelessWidget {
  final Widget child;

  const FilterProviderWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FilterProvider>(
      create: (context) {
        final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);
        final userProvider = context.read<UserProvider>();
        final filterService = MosqueFilterService(client);
        return FilterProvider(userProvider, filterService);
      },
      child: child,
    );
  }
}
