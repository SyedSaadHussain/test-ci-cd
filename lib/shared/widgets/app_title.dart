import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

Widget AppTitle1(String title,IconData? icon) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
    decoration: BoxDecoration(
      color: AppColors.gray.withOpacity(.1),
      borderRadius: BorderRadius.circular(7.0),
      border: Border.all(
        color: AppColors.gray.withOpacity(.1), // Border color
        width: 1.0, // Border width
      ),
    ),
    child: Row(
      children: [
        Icon(icon,color: AppColors.gray.withOpacity(.5)),
        SizedBox(width: 5,),
        Text(title,style: TextStyle(color:AppColors.gray.withOpacity(.5),fontWeight: FontWeight.bold ),),
      ],
    ),
  );
}

Widget AppTitle2(String title,IconData? icon) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
    child: Row(
      children: [
        Icon(icon,color: AppColors.gray.withOpacity(.5)),
        SizedBox(width: 5,),
        Text(title,style: TextStyle(color:AppColors.gray.withOpacity(.5),fontWeight: FontWeight.bold ),),
      ],
    ),
  );
}

Widget ModalTitle(String title,IconData? icon,{Widget? leading}) {

  return Container(
     padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      decoration: BoxDecoration(
        // color: Colors.grey.shade50,

        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),

      margin: EdgeInsets.all(5),
      child: Row(
        children: [
          SizedBox(width: 5,),
          Icon(icon,color: Colors.grey.shade400,size: 18,),
          SizedBox(width: 0,),
          Container(
              padding: EdgeInsets.all(10),
              child: Text(title,style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey,fontSize: 18))),
          Expanded(child: Container()),
          leading==null?Container():leading
        ],
      ));
}