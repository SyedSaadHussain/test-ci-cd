import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/utils/asset_json_utils.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_ondemand_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';

class CreateOndemandViewModel extends ChangeNotifier{


  late VisitOndemandModel visit;
  bool isLoading=false;
  late VisitRepository visitRepository;
  Function?  showDialogCallback;

  ///Call funtion when visit create successfully, to add the visit in list
  Function?  onSuccess;
  FieldListData fields=FieldListData();
  dynamic formKey = GlobalKey<FormState>();
  String get viewPath => 'assets/views/visit_ondemand.json';

  CreateOndemandViewModel({required this.visit,required this.onSuccess});

  updateMosque(ComboItem item){
    visit.mosque=item.value;
    visit.mosqueId=item.key;
    notifyListeners();
  }

  updateObserver(ComboItem item){
    visit.employee=item.value;
    visit.employeeId=item.key;
    notifyListeners();
  }

  void init(){
    loadView();
  }

  ///Load form translation
  Future<void> loadView() async {
    fields.list=[];
    if(viewPath!=null){
      final fieldItems = await AssetJsonUtils.loadView<FieldList>(
        path: viewPath!,
        fromKeyValue: (key, value) => FieldList.fromStringJson(key, value),
      );
      fields.list.addAll(fieldItems);
      notifyListeners();
    }
  }

  void onSubmit(context){
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      isLoading=true;
      notifyListeners();
      visitRepository!.createVisit(visit).then((value){
        isLoading=false;
        notifyListeners();
        showDialogCallback!(DialogMessage(type: DialogType.successText, message: value?.message));
        //add new create visit in list
        onSuccess!(value?.visit);

      }).catchError((e){
        isLoading=false;
        notifyListeners();
        showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
      });
    }

  }

}