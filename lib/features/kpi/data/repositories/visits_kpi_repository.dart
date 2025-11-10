import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/regular_visit_stats.dart';
import '../models/visits_draft_counts.dart';

class VisitsKpiRepository {
  final CustomOdooClient _client;

  VisitsKpiRepository(this._client);

  Future<VisitsDraftCounts?> getObserverDraftVisits(int userId) async {
    try {
      final response = await _client
          .get('/get/crm/observer/all/draft/visits/json?user_id=$userId');

      // Check for error response
      if (response['success'] == false || response['status'] == false) {
        final errorMessage = response['message'] ?? 'Error fetching draft visits';
        throw Exception(errorMessage);
      }

      final status = response['status'];
      if ((status == true || status == 'success') && response['data'] != null) {
        final data = response['data'];
        if (data is Map && data.isEmpty) return null;
        final counts = VisitsDraftCounts.fromJson(data);
        return counts;
      }
      return null;
    } catch (e) {
      print('Error fetching draft visits counts: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'kpi',
              'repository': 'VisitsKpiRepository',
              'method': 'getObserverDraftVisits',
              'endpoint': '/get/crm/observer/all/draft/visits/json'
            });
            scope.setExtra('userId', userId);
            scope.level = SentryLevel.error;
          },
        );
      }
      rethrow;
    }
  }

  Future<RegularVisitStats?> getRegularVisitStats({
    required int userId,
    required String date, // Date in YYYY-MM-DD format
  }) async {
    try {
      final response = await _client.get(
        '/get/crm/observer/regular/visit/stats/json?user_id=$userId&date=$date',
      );

      // Check for error response
      if (response['success'] == false || response['status'] == false) {
        final errorMessage = response['message'] ?? 'Error fetching regular visit stats';
        throw Exception(errorMessage);
      }

      final success = response['success'];
      if ((success == true || success == 'success') &&
          response['data'] != null) {
        final data = response['data'];
        if (data is Map && data.isEmpty) return null;
        final stats = RegularVisitStats.fromJson(data);
        return stats;
      }
      return null;
    } catch (e) {
      print('Error fetching regular visit stats: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'kpi',
              'repository': 'VisitsKpiRepository',
              'method': 'getRegularVisitStats',
              'endpoint': '/get/crm/observer/regular/visit/stats/json'
            });
            scope.setExtra('userId', userId);
            scope.setExtra('date', date);
            scope.level = SentryLevel.error;
          },
        );
      }
      rethrow;
    }
  }

  Future<List<DailyKpi>> getRegularDailyProgress({
    required int userId,
    required int month,
  }) async {
    try {
      final response = await _client.get(
        '/get/crm/observer/regular/daily/progress/json?user_id=$userId&month=$month',
      );

      // Check for error response
      if (response['success'] == false || response['status'] == false) {
        final errorMessage = response['message'] ?? 'Error fetching regular daily progress';
        throw Exception(errorMessage);
      }

      final success = response['success'];
      if ((success == true || success == 'success') &&
          response['data'] != null) {
        final data = response['data'];
        if (data is List) {
          return data.map((item) => DailyKpi.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching regular daily progress: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'kpi',
              'repository': 'VisitsKpiRepository',
              'method': 'getRegularDailyProgress',
              'endpoint': '/get/crm/observer/regular/daily/progress/json'
            });
            scope.setExtra('userId', userId);
            scope.setExtra('month', month);
            scope.level = SentryLevel.error;
          },
        );
      }
      rethrow;
    }
  }
}
