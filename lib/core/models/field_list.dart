import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';

class FieldList{
  String? field='';
  String label='';
  List<ComboItem>? list=[];
  FieldListData? child;
  FieldList({
    this.field,
    this.label='',
    this.child,
    this.list
  });
  factory FieldList.fromStringJson(String key,Map<String, dynamic> json) {
    FieldListData fields= FieldListData();
    if((json["views"] != null && json["views"]["tree"] != null ) && json["views"]["tree"].containsKey("fields")) {
      fields.list=(json["views"]["tree"]["fields"] as   Map<String, dynamic>).map((key,item) => MapEntry(
        key,
        FieldList.fromStringJson(key, item),
      ),
      ).values
          .toList();
    }

    //json['no_planned']=false;
    return FieldList(
        field:key,
        label: JsonUtils.toText(json['string'])??"",
        child: fields,
        list:(json['selection']==null)?null: (json['selection'] as List).map((item) => ComboItem.fromStringJson(item)).toList()
    );
  }
}


class FieldListData{
  List<FieldList> list=[];
  FieldList getField(dynamic key){
    var filteredList = list!.where((rec) => rec.field==key);
    if (filteredList.isNotEmpty) {
      return filteredList.first;
    }else{
      return FieldList(label: "");
    }

  }

  List<ComboItem> getComboList(dynamic field){
    var filteredList = list!.where((rec) => rec.field==field);
    if (filteredList.isNotEmpty) {

      return filteredList.first.list??[];
    }else{
      return [];
    }
    //return comboList.where((rec) => rec.field==field).first.list;
  }
}
