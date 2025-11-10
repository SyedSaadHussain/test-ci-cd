import 'package:mosque_management_system/core/constants/config.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../../data/services/custom_odoo_client.dart';
import '../models/invoice_entry.dart';

class InvoiceRepository {
  final CustomOdooClient _client;

  InvoiceRepository(this._client);

  Future<InvoiceEntry?> getThisMonthInvoice(int meterId) async {
    try {
      final res = await _client.get(
        '/get/crm/mosque/this/month/invoice',
         {'meter_id': meterId},
      );
      if (res['status'] == 200 &&
          res['data'] is List &&
          (res['data'] as List).isNotEmpty) {
        return InvoiceEntry.fromJson((res['data'] as List).first as Map<String, dynamic>);
      }
    } catch (e) {
      // ignore and return null
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'electricity',
              'method': 'getThisMonthInvoice',
              'endpoint': '/get/crm/mosque/this/month/invoice'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
    }
    return null;
  }

  Future<InvoiceEntry?> getLastMonthInvoice(int meterId) async {
    try {
      final res = await _client.get(
        '/get/crm/mosque/last/month/invoice',
        {'meter_id': meterId},
      );
      if (res['status'] == 200 &&
          res['data'] is List &&
          (res['data'] as List).isNotEmpty) {
        return InvoiceEntry.fromJson((res['data'] as List).first as Map<String, dynamic>);
      }
    } catch (e) {
      // ignore and return null
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'electricity',
              'method': 'getLastMonthInvoice',
              'endpoint': '/get/crm/mosque/last/month/invoice'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getMeterTotalInvoices(int meterId) async {
    try {
      final res = await _client.get(
        '/get/crm/mosque/meter/total/invoices',
         {'meter_id': meterId},
      );
      if (res['status'] == 200 &&
          res['data'] is List &&
          (res['data'] as List).isNotEmpty) {
        final Map<String, dynamic> row =
            Map<String, dynamic>.from((res['data'] as List).first);
        return row;
      }
    } catch (e) {
      // ignore and return null
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'electricity',
              'method': 'getMeterTotalInvoices',
              'endpoint': '/get/crm/mosque/meter/total/invoices'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
    }
    return null;
  }
}


