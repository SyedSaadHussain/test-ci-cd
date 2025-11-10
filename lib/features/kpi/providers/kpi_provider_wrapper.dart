import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../data/repositories/mosque_indicators_repository.dart';
import '../data/repositories/visits_kpi_repository.dart';
import 'mosque_indicators_view_model.dart';
import 'regular_visits_view_model.dart';
import 'visits_kpi_view_model.dart';

class KpiProviderWrapper extends StatelessWidget {
  final Widget child;

  const KpiProviderWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);
    final userProvider = context.read<UserProvider>();

    final mosqueRepo = MosqueIndicatorsRepository(client);
    final visitsRepo = VisitsKpiRepository(client);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MosqueIndicatorsViewModel>(
          create: (_) => MosqueIndicatorsViewModel(mosqueRepo, userProvider),
        ),
        ChangeNotifierProvider<VisitsKpiViewModel>(
          create: (_) => VisitsKpiViewModel(visitsRepo, userProvider),
        ),
        ChangeNotifierProvider<RegularVisitsViewModel>(
          create: (_) => RegularVisitsViewModel(
            repository: visitsRepo,
            userProvider: userProvider,
          ),
        ),
      ],
      child: child,
    );
  }
}


