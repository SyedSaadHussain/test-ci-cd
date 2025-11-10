import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/water_invoice.dart';
import '../models/water_total_invoices.dart';

class WaterInvoiceRepository {
  final CustomOdooClient _client;
  WaterInvoiceRepository(this._client);

  Future<WaterInvoiceResponse> getLastMonthInvoice({required int meterId}) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/water/invoice/lastmonth',
        {'meter_id': meterId},
      );
      return WaterInvoiceResponse.fromJson(response);
    } catch (e) {
      print('Error fetching water last month invoice: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'water',
              'method': 'getLastMonthInvoice',
              'endpoint': '/get/crm/mosque/water/invoice/lastmonth'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return WaterInvoiceResponse.error();
    }
  }

  Future<WaterInvoiceResponse> getThisMonthInvoice({required int meterId}) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/water/invoice/thismonth',
        {'meter_id': meterId},
      );
      return WaterInvoiceResponse.fromJson(response);
    } catch (e) {
      print('Error fetching water this month invoice: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'water',
              'method': 'getThisMonthInvoice',
              'endpoint': '/get/crm/mosque/water/invoice/thismonth'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return WaterInvoiceResponse.error();
    }
  }

  Future<WaterTotalInvoicesResponse> getTotalInvoices({required int meterId}) async {
    try {
      final response = await _client.get(
        '/get/crm/mosque/water/meter/total/invoices',
        {'meter_id': meterId},
      );
      return WaterTotalInvoicesResponse.fromJson(response);
    } catch (e) {
      print('Error fetching water total invoices: $e');
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          withScope: (scope) {
            scope.setContexts('Feature', {
              'module': 'mosque_utilities',
              'submodule': 'water',
              'method': 'getTotalInvoices',
              'endpoint': '/get/crm/mosque/water/meter/total/invoices'
            });
            scope.setExtra('meter_id', meterId);
            scope.level = SentryLevel.error;
          },
        );
      }
      return WaterTotalInvoicesResponse.error();
    }
  }
}
