import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/data/services/reference_service.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_service.dart';

class ReferenceRepository {
  final ReferenceService service;
  final UserProfile userProfile;

  ReferenceRepository(this.userProfile)
      : service =  ReferenceService();

  Future<List<ComboItem>> getMosqueTypes() async {
    try{
      final data = await service.getMosqueTypes();
      return data;
    }catch(e){
      throw e;
    }
  }

  Future<List<ComboItem>> getClassification() async {
    try{
      final data = await service.getClassification();
      return data;
    }catch(e){
      throw e;
    }
  }

  ///First try to get data from userprofile then from service
  Future<List<ComboItem>> getRegion() async {
    try{
      List<ComboItem> items=[];
      if ((userProfile.stateIds??[]).isNotEmpty) {
        items = userProfile.stateIds!;
      }else{
        items=await service.getRegion();
      }
      return items;
    }catch(e){
      throw e;
    }
  }

  Future<List<ComboItem>> getDistricts() async {
    try{
      final data = await service.getDistricts();
      return data;
    }catch(e){
      throw e;
    }
  }
  
  Future<List<ComboItem>> getCity(regionId) async {
    try{
      List<ComboItem> items=[];
      if ((userProfile.cityIds??[]).isNotEmpty) {
        items = userProfile.cityIds!;
      }else{
        items=await await service.getCity(regionId);
      }
      return items;
    }catch(e){
      throw e;
    }
  }

  Future<List<ComboItem>> getCenter(cityId) async {
    try{
      List<ComboItem> allCenters=[];
      List<ComboItem> centers=[];

      allCenters=await service.getCenter(cityId);
      if ((userProfile.moiaCenterIds??[]).isNotEmpty) {
        centers = allCenters.where((c) {
          final id = c.key;
          return (userProfile.moiaCenterIds??[]).any((uc) {
            return uc.key == id;
          });
        }).toList();
      }else{
        centers=allCenters;
      }
      return centers;

    }catch(e){
      throw e;
    }
  }

}