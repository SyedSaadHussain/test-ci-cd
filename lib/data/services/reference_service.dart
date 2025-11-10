import 'package:flutter/cupertino.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/utils/asset_json_utils.dart';
import 'package:mosque_management_system/data/services/custom_odoo_client.dart';

class ReferenceService {
  final CustomOdooClient client;


  // Constructor: optional client, fall back to singleton
  ReferenceService()
      : client = CustomOdooClient();

  Future<List<ComboItem>>  getMosqueTypes() async{
    List<ComboItem>? items=[];
    items = await AssetJsonUtils.loadList<ComboItem>(
      path: 'assets/data/mosque/types.json',
      fromJson: (json) => ComboItem.fromJsonObjectWithName(json,'mosque_type_id','mosque_type_name'),
    );
    return items??[];
  }
  Future<List<ComboItem>>  getClassification() async{
    List<ComboItem>? items=[];
    items = await AssetJsonUtils.loadList<ComboItem>(
      path: 'assets/data/mosque/classifications.json',
      fromJson: (json) => ComboItem.fromJsonObjectWithName(json,'classification_id','classification_name'),
    );
    return items??[];
  }
  Future<List<ComboItem>>  getRegion() async{
    List<ComboItem>? items=[];
    items = await AssetJsonUtils.loadList<ComboItem>(
      path: 'assets/data/district.json',
      fromJson: (json) => ComboItem.fromJsonObjectWithName(json,'district_id','district_Name'),
    );
    return items??[];
  }
  Future<List<ComboItem>>  getCity(regionId) async{
    print('regionId');
    print(regionId);
    List<ComboItem>? items=[];
    items = await AssetJsonUtils.loadList<ComboItem>(
      path: 'assets/data/mosque/cities.json',
      fromJson: (json) => ComboItem.fromJsonObjectWithName(json,'city_id','city_name'),
      filter: (json) => json['region_id'] == regionId,
    );
    return items??[];
  }
  Future<List<ComboItem>>  getDistricts() async{

    List<ComboItem>? items=[];
    items = await AssetJsonUtils.loadList<ComboItem>(
      path: 'assets/data/mosque/district.json',
      fromJson: (json) => ComboItem.fromJsonObjectWithName(json,'district_id','district_Name'),
    );
    return items??[];
  }
  Future<List<ComboItem>>  getCenter(cityId) async{
    print('cityId');
    print(cityId);
    List<ComboItem>? items=[];
    items = await AssetJsonUtils.loadList<ComboItem>(
      path: 'assets/data/mosque/centers.json',
      fromJson: (json) => ComboItem.fromJsonObjectWithName(json,'center_id','center_name'),
      filter: (json) => json['city_id'] == cityId,
    );
    return items??[];
  }

}
