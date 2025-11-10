import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/data/services/yakeen_service.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/dawah_book.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/utils/asset_json_utils.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';


/// Base class for visit form view models (`Regular`, `Jumma`, `Female`, `OnDemand`).
abstract  class VisitFormSubViewModel<T extends VisitModel>
    extends VisitFormViewModel<T> {

  List<DawahBook> books = [];

  VisitFormSubViewModel(
      super.visitService,
      super.visitParam,
      super.visitObj,
      super.onCallback,
      );

  //Load book in dawah section
  Future<List<DawahBook>> loadBooks() async {
    var allBooks = await AssetJsonUtils.loadList<DawahBook>(
      path: 'assets/data/visit/books.json',
      fromJson: (json) => DawahBook.fromJson(json),
    ) ?? [];
    return allBooks;
  }

  //Yakeen verification in dawah section
  Future<void> preacherYakeenVerification() async{
    isLoading=true;
    notifyListeners();
    final yakeenService = YakeenService();
    try {
      final name = await yakeenService.getUserName(
        visitObj.preacherIdentificationId ?? "",
        visitObj.dobPreacherHijri ?? "",
      );
      if(AppUtils.isNotNullOrEmpty(name)){
        visitObj.yaqeenStatus=name;
        notifyListeners();
      }else{
        showDialogCallback!(DialogMessage(type: DialogType.errorText, message: VisitMessages.yakeenNotVerifiedError));
      }
      notifyListeners();

    } catch (e) {
      showDialogCallback!(DialogMessage(type: DialogType.errorText, message: e.toString()));
    } finally{
      isLoading=false;
      notifyListeners();
    }
  }

}