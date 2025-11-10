import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';

Widget AppTagButton({Function? onTab,String title="",dynamic? subTitle="",IconData? icon,
  Color iconColor= AppColors.primary,bool hasDivider=true,bool isBoolean=false,List<ComboItem>? selection,bool isTag=false,bool isBar=false,bool isSelectionReverse=false,BuildContext? context,Widget? child,bool isSelected=false,bool isExpand=true}) {
  Color tagColor=Colors.grey;
  String value=subTitle.toString();
  int index=0;
  int width_per=0;
  double width=double.infinity;
  if(selection!=null && selection.length>0){
    width=context==null?double.infinity:MediaQuery.of(context!).size.width/selection!.length;

    var filteredList = selection!.where((rec) => rec.key == subTitle);
    if (filteredList.isNotEmpty) {
      value = filteredList.first.value.toString();
    }

    index=selection.indexWhere((rec)=>rec.key==subTitle);

    if(index>-1){
      List<int> ascendingList = List<int>.generate(selection.length, (index) => index).reversed.toList();

      if(isSelectionReverse){
        width_per=index;
      }else{
        width_per=ascendingList[index];
      }
    }


    List<Color> listColor=[AppColors.success,AppColors.warning,AppColors.danger];
    if(selection.length==3){
      listColor=[AppColors.success,AppColors.warning,AppColors.danger];
    }else if(selection.length==2){
      listColor=[AppColors.success,AppColors.danger];
    }else if(selection.length==4){
      listColor=[AppColors.success,Colors.amber,AppColors.warning,AppColors.danger];
    }
    else if(selection.length==5){
      listColor=[AppColors.success,AppColors.success.withOpacity(.6),Colors.amber,AppColors.warning,AppColors.danger];
    }else if(selection.length==6){
      listColor=[AppColors.success,AppColors.success.withOpacity(.6),Colors.amber,Colors.amber.withOpacity(.6),AppColors.warning,AppColors.danger];
    }else if(selection.length==7){
      listColor=[AppColors.success,AppColors.success.withOpacity(.6),Colors.amber,Colors.amber.withOpacity(.6),AppColors.warning,AppColors.warning.withOpacity(.6),AppColors.danger];
    }else if(selection.length==8){
      listColor=[AppColors.success,AppColors.success.withOpacity(.6),Colors.amber,Colors.amber.withOpacity(.6),AppColors.warning,AppColors.warning.withOpacity(.6),AppColors.danger,AppColors.danger.withOpacity(.6)];
    }

    if(isSelectionReverse)
      listColor = listColor.reversed.toList();

    tagColor=listColor[index];

  }

  return  Container(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Container(
            width:isExpand? double.infinity:null,
            // color: Colors.green,
            child: IntrinsicWidth (

              child:
              Container(
                // constraints: BoxConstraints(
                //   minWidth: 50.0, // Minimum width
                // ),
                // width: double.infinity,
                //height: 30,
                //width: 50,
                margin: EdgeInsets.all( 3),
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
                  color: isSelected?tagColor.withOpacity(.1):Colors.white ,
                  border: Border.all(color: tagColor.withOpacity(.1),width: 2.0,),
                ),
                alignment: Alignment.center,
                child: Text(
                  value,
                  style: TextStyle(color: tagColor,fontSize: 12),
                ),
              ),

            ),
          ),
        ),
        (hasDivider && !isBar)?Divider(color: Colors.grey.shade200,height: 1,):Container()
      ],

    ),
  );
}
