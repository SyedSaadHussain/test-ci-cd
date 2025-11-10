import 'package:flutter/cupertino.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/utils/asset_json_utils.dart';
import 'package:mosque_management_system/data/services/custom_odoo_client.dart';

class VisitService {
  final CustomOdooClient client;


  // Constructor: optional client, fall back to singleton
  VisitService()
      : client = CustomOdooClient();

  Future<List<ComboItem>> getActionTypes() async {
    try {

      final items= await AssetJsonUtils.loadList<ComboItem>(
          path: 'assets/data/visit/action_types.json',
          fromJson: (json) => ComboItem.fromJsonObject(json)
      ) ?? [];

      return items;
    } catch (e) {

      rethrow;
    }
  }

  /// Get Employee Detail
  Future<Map<String, dynamic>> getVisits(dynamic queryString) async {
    try {
        final response = await client.get('/get/crm/regular/allvisits',queryString);

        return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Get Employee Detail
  Future<Map<String, dynamic>> getFemaleVisits(dynamic queryString) async {
    try {
      final response = await client.get('/get/crm/female/allvisits',queryString);
return response;
    } catch (e) {
rethrow;
    }
  }

  /// Get Employee Detail
  Future<Map<String, dynamic>> getJummaVisits(dynamic queryString) async {
    try {
      final response = await client.get('/get/crm/jumma/allvisits',queryString);
return response;
    } catch (e) {
rethrow;
    }
  }

  /// Get Employee Detail
  Future<Map<String, dynamic>> getOndemandVisits(dynamic queryString) async {
    try {
      final response = await client.get('/get/crm/ondemand/allvisits',queryString);
      return response;
    } catch (e) {
rethrow;
    }
  }

  /// Get Employee Detail
  Future<Map<String, dynamic>> getLandVisit(dynamic queryString) async {
    try {
      final response = await client.get('/get/crm/land/allvisits',queryString);
      return response;
    } catch (e) {
rethrow;
    }
  }
  /// Get Employee Detail
  Future<Map<String, dynamic>> getEidVisit(dynamic queryString) async {
    try {
      final response = await client.get('/get/crm/eid/allvisits',queryString);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Get Employee Detail
  Future<dynamic> getInitializeVisit(dynamic queryString) async {
    try {
      final response = await client.get('/get/crm/dynamic/mosque/details',queryString);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Get Employee Detail
  Future<dynamic> getInitializeOndemandVisit(dynamic queryString) async {
    try {
      final response = await client.get('/get/crm/ondemand/dynamic/mosque/details',queryString);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Get Employee Detail
  Future<dynamic> getInitializeFemaleVisit(dynamic queryString) async {
    try {
      final response = await client.get('/get/crm/female/visit/dynamic/mosque/details',queryString);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Get Employee Detail
  Future<dynamic> getInitializeJummaVisit(dynamic queryString) async {
    try {
      final response = await client.get('/get/crm/jumma/dynamic/mosque/details',queryString);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getInitializeLandVisit(dynamic queryString) async {
    try {
      final response = await client.get('/get/crm/land/visit/dynamic/land/details',queryString);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getInitializeEidVisit(dynamic queryString) async {
    try {
      final response = await client.get('/get/crm/eid/visit/dynamic/mosque/details',queryString);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Get Employee Detail
  Future<dynamic> getVisitDetail(dynamic queryString,String url) async {
    try {
      final response = await client.get('/get/crm'+url,queryString);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getTodayPrayerTime() async {
    try {
      final response = await client.get('/prayer/time/crm/2');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitVisit(dynamic pram) async {
    try {
      final response = await client.patch('/patch/app/regular/visit',pram);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitOndemandVisit(dynamic pram) async {
    try {
      final response = await client.patch('/patch/app/ondemand/visit',pram);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitLandVisit(dynamic pram) async {
    try {
      final response = await client.patch('/patch/app/land/visit',pram);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitEidVisit(dynamic pram) async {
    try {
      final response = await client.patch('/patch/app/eid/visit',pram);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitFemaleVisit(dynamic pram) async {
    try {
      final response = await client.patch('/patch/app/female/visit',pram);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> submitJummaVisit(dynamic pram) async {
    try {
      final response = await client.patch('/patch/app/jumma/visit',pram);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //region for action taken
  Future<dynamic> acceptVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/regular/visit/action/accept',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> actionTakenRegularVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/regular/visit/action/taken',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> underProgressRegularVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/regular/visit/under/progress',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> acceptOndemandVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/ondemand/visit/action/accept',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> actionTakenOndemandVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/ondeamnd/visit/action/taken',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> underProgressOndemandVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/ondemand/visit/under/progress',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> acceptJummaVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/jumma/visit/action/accept',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> actionTakenJummaVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/jumma/visit/action/taken',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> underProgressJummaVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/jumma/visit/under/progress',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> acceptEidVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/eid/visit/action/accept',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> actionTakenEidVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/eid/visit/action/taken',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> underProgressEidVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/eid/visit/under/progress',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> acceptFemaleVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/female/visit/action/accept',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> actionTakenFemaleVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/female/visit/action/taken',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> underProgressFemaleVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/female/visit/under/progress',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> acceptLandVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/land/visit/action/accept',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> actionTakenLandVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/land/visit/action/taken',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> underProgressLandVisit(dynamic pram) async {
    try {
      final response = await client.patch('/app/patch/land/visit/under/progress',pram);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  //endregion

  /// Get Employee Detail
  Future<Map<String, dynamic>> getOndemandMosques(dynamic queryString) async {
    try {
      final response = await client.get('/get/crm/mosques/ondemand/visit',queryString);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  /// Get Employee Detail
  Future<Map<String, dynamic>> getOndemandObservers(dynamic queryString) async {
    try {
      final response = await client.get('/get/crm/employee/ondemand/visit',queryString);
      return response;
    } catch (e) {
      rethrow;
    }
  }/// Get Employee Detail
  ///
  Future<Map<String, dynamic>> createVisit(dynamic queryString) async {
    try {
      final response = await client.post('/post/mobile/visit/ondemand',queryString,false);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
