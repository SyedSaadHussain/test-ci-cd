import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/core/utils/gps_permission.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';
import 'package:provider/provider.dart'; // adjust import

 class VisitFormBottom<T extends VisitModelBase> extends StatelessWidget {

  const VisitFormBottom({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VisitFormViewModel<T>>();
    return Selector<VisitFormViewModel<T>, (
    bool, bool, bool, bool, bool, bool, bool,GPSPermission?
    )>(
        selector: (_, vm) => (
        vm.isVisiblePermission,
        vm.isShowStartBtn,
        vm.isLoadingStart,
        vm.isProceedVisit,
        vm.isShowBackBtn,
        vm.isShowNextBtn,
        vm.isShowSubmitBtn,
        vm.permission
        ),
        builder: (_, values, __) {
     return Container(
       padding: EdgeInsets.symmetric(horizontal: 0),
       // height: 60,
       child: Column(
         mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vm.isVisiblePermission? Visibility(
                visible:  vm.isVisiblePermission,
                child: Container(
                    margin: EdgeInsets.only(bottom: 0),
                    padding: EdgeInsets.all(10),
                    //height: 30,
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(
                        color: Colors.grey,  // Set this to the desired color when not authorized
                        width: 1.0,       // Adjust the width as needed
                      ),
                      color: vm.permission!.status==GPSPermissionStatus.authorize?AppColors.background :AppColors.background,
                    ),
                    child: Row(
                      children: [
                        vm.permission!.status==GPSPermissionStatus.authorize?Icon(Icons.check_circle,color: Colors.grey.shade500,):Icon(Icons.warning_amber,color: Colors.grey.shade400,),
                        SizedBox(width: 5,),
                        Expanded(
                            child: Text(vm.permission!.statusDesc,style: TextStyle(fontSize: 13 ,color: Colors.grey),)
                        ),
                        !vm.permission!.isCompleted?SizedBox(
                            height: 25.0,
                            width: 25.0,
                            child: CircularProgressIndicator(color: Colors.grey.shade500,)):vm.permission!.showTryAgainButton?
                        TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size(50, 25),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                            onPressed: () {
                              if(vm.permission!.status==GPSPermissionStatus.locationDisabled){
                                vm.permission!.enableMobileLocation();
                              }else if(vm.permission!.status==GPSPermissionStatus.permissionDenied){
                                vm.permission!.allowPermission();
                              }else if(vm.permission!.status==GPSPermissionStatus.failFetchCoordinate || vm.permission!.status==GPSPermissionStatus.unAuthorizeLocation){
                                vm.permission!.getCurrentLocation();
                              }
                            },child: Text('try_again'.tr(),style: TextStyle(color: Colors.grey,decoration: TextDecoration.underline,),)):Container() ,
                      ],
                    )
                ),
              ):Container(),
              vm.isShowStartBtn?AppButton(text: VisitMessages.start,color: AppColors.deepRed,
                  onTab:vm.isLoadingStart?null: (){

                    vm.startVisit();
                    // startVisit1();
                  }
              ):Container(),
              vm.isProceedVisit?AppButton(text: VisitMessages.proceedVisit,color: AppColors.deepGreen,
                  onTab: (){

                    vm.nextTab();
                  }
              ):Container(),

              Row(
                children: [
                  vm.isShowBackBtn?Expanded(
                    child: AppButton(text: VisitMessages.previous,color: AppColors.gray,
                        onTab: (){
                          vm.previousTab(context);
                        }
                    ),
                  ):Container(),
                  SizedBox(width: 2,),

                  vm.isShowNextBtn?Expanded(
                    child: AppButton(text: VisitMessages.next,color: AppColors.primary,
                        onTab: (){
                          vm.nextTab();
                        }
                    ),
                  ):Container(),
                  SizedBox(width: 2,),
                  vm.isShowSubmitBtn?Expanded(
                    child: AppButton(text: VisitMessages.submit,color: AppColors.primary,
                      onTab: () =>  vm.onSubmitVisit(context),
                    ),
                  ):Container(),
                ],
              ),
               SizedBox(height: 5),
            ],
          ),
     );
      }
    );
  }
}
