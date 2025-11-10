import 'package:mosque_management_system/core/utils/json_utils.dart';

class DawahBook {
  int? id;
  String? name;
  String? auther;

  DawahBook({this.id, this.name, this.auther});

  // ✅ fromJson constructor
  factory DawahBook.fromJson(Map<String, dynamic> json) {
    return DawahBook(
      id: JsonUtils.toInt(json['id']),
      name: JsonUtils.toText(json['name']),
      auther: JsonUtils.toText(json['author']),
    );
  }
}