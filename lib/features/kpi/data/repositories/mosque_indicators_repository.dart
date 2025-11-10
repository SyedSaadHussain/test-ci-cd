import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/mosque_counts.dart';
import '../models/mosques_types_counts.dart';
import '../models/verification_counts.dart';

class MosqueIndicatorsRepository {
  final CustomOdooClient _client;

  MosqueIndicatorsRepository(this._client);

  Future<MosqueCounts?> getMosqueCounts(int userId) async {
    try {
      final response = await _client
          .get('/get/crm/observer/mosque/counts/json?user_id=$userId');

      // Check for error response
      if (response['success'] == false || response['status'] == false) {
        final errorMessage = response['message'] ?? 'Error fetching mosque counts';
        throw Exception(errorMessage);
      }

      if (response['status'] == 'success' && response['data'] != null) {
        final data = response['data'];
        if (data is Map && data.isEmpty) {
          return null;
        }
        final mosqueCounts = MosqueCounts.fromJson(data);
        return mosqueCounts;
      }

      return null;
    } catch (e) {
      print('Error fetching mosque counts: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'kpi',
              'repository': 'MosqueIndicatorsRepository',
              'method': 'getMosqueCounts',
              'endpoint': '/get/crm/observer/mosque/counts/json'
            });
            scope.setExtra('userId', userId);
            scope.level = SentryLevel.error;
          },
        );
      }
      rethrow;
    }
  }

  Future<VerificationCounts?> getVerificationCounts(int userId) async {
    try {
      final response = await _client.get(
          '/get/crm/observer/total/mosques/varification/json?user_id=$userId');

      // Check for error response
      if (response['success'] == false || response['status'] == false) {
        final errorMessage = response['message'] ?? 'Error fetching verification counts';
        throw Exception(errorMessage);
      }

      if (response['status'] == 'success' && response['data'] != null) {
        final data = response['data'];
        if (data is Map && data.isEmpty) {
          return null;
        }
        final verificationCounts = VerificationCounts.fromJson(data);
        return verificationCounts;
      }

      return null;
    } catch (e) {
      print('Error fetching verification counts: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'kpi',
              'repository': 'MosqueIndicatorsRepository',
              'method': 'getVerificationCounts',
              'endpoint': '/get/crm/observer/total/mosques/varification/json'
            });
            scope.setExtra('userId', userId);
            scope.level = SentryLevel.error;
          },
        );
      }
      rethrow;
    }
  }

  Future<MosquesTypesCounts?> getMosquesTypesCounts(int userId) async {
    try {
      final response = await _client
          .get('/get/crm/observer/mosque/types/json?user_id=$userId');

      // Check for error response
      if (response['success'] == false || response['status'] == false) {
        final errorMessage = response['message'] ?? 'Error fetching mosques types counts';
        throw Exception(errorMessage);
      }

      if (response['status'] == 'success' && response['data'] != null) {
        final data = response['data'];
        if (data is Map && data.isEmpty) {
          return null;
        }
        final mosquesTypesCounts = MosquesTypesCounts.fromJson(data);
        return mosquesTypesCounts;
      }

      return null;
    } catch (e) {
      print('Error fetching mosques types counts: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'kpi',
              'repository': 'MosqueIndicatorsRepository',
              'method': 'getMosquesTypesCounts',
              'endpoint': '/get/crm/observer/mosque/types/json'
            });
            scope.setExtra('userId', userId);
            scope.level = SentryLevel.error;
          },
        );
      }
      rethrow;
    }
  }

}
