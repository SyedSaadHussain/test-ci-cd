import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';

Widget AppLargeContainer(Function fun,{ String value="",String text="",IconData icon=Icons.add,
  Color color= const Color(0xfff223b51), Color onColor= const Color(0xfff223b51),Widget? child}) {

  return GestureDetector(
    onTap: (){
      fun();
    },
    child: Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal:10,vertical: 5),
            margin: EdgeInsets.symmetric(horizontal:5,vertical: 5),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: <Color>[color, color.withOpacity(.9)]),
                // color: ,
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            width: double.infinity,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text,style: TextStyle(color: onColor.withOpacity(.8),fontSize: 15,fontWeight: FontWeight.bold),),
                      child!=null?child:

                      Text(value,style: TextStyle(color: onColor.withOpacity(1),fontSize: 35))

                    ],
                  ),
                ),
                SizedBox(width: 10,),
                Icon(icon,color: onColor.withOpacity(.8),size: 50,)
              ],
            ) ,
          ),
        ],
      ),
    ),
  );
}


Widget AppContainerStyle1({Function? onTab,Color? color,String? label,dynamic value,IconData? icon}) {

  return GestureDetector(
    onTap: (){

      onTab!();
    },
    child: Container(

      decoration: BoxDecoration(
        color: color!.withOpacity(.1),
        borderRadius: BorderRadius.circular(8), // Set the border radius
      ),

      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon??Icons.check_box,size: 16,color: color,),
                Text(label??"" ,style: TextStyle(color: color),),
              ],
            ),
          ),
          Expanded(child: Container()),
          Container(
            width:50,

            child: Container(
                height: double.infinity,
                child: Center(child: Text(JsonUtils.convertToString(value),style: TextStyle(fontWeight: FontWeight.bold,color: color),))

            ),

          )
        ],
      ),
    ),
  );
}