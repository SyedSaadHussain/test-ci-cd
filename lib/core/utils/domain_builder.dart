import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';

class DomainBuilder {
  dynamic _conditions = [];

  dynamic get domain=> _conditions;

  // Constructor with optional initial filters
  DomainBuilder(dynamic initialConditions)
      : _conditions = initialConditions ?? [];

  void add(String field, dynamic value,String operator) {

    print(_conditions.length);
    print(value);
    if ((value is String && AppUtils.isNotNullOrEmpty(value)) ||  (value is! String && value != null)) {

      if(_conditions.length>0)
        _conditions.insert(0, '&');
      print('add');
      _conditions.add([field,operator,value]);
    }


    print(value);
    print(_conditions);
  }
}