import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:provider/provider.dart';

import '../../electricity_consumption/data/services/mosque_filter_service.dart';
import '../data/repositories/water_repository.dart' as water_repo;
import '../providers/water_filter_provider.dart';
import 'water_view_model.dart';

class WaterProviderWrapper extends StatelessWidget {
  final Widget child;

  const WaterProviderWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);
    final userProvider = context.read<UserProvider>();
    final waterRepository = water_repo.WaterRepository(client);
    final filterService = MosqueFilterService(client);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WaterFilterProvider>(
          create: (_) => WaterFilterProvider(userProvider, filterService, waterRepository),
        ),
        ChangeNotifierProvider<WaterViewModel>(
          create: (_) => WaterViewModel(waterRepository, userProvider),
        ),
      ],
      child: child,
    );
  }
}


