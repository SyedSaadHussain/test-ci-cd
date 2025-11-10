import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'dart:io' as io;

class TagButton extends StatefulWidget {
  int activeButtonIndex;
  final int index;
  final String title;
  final Function? onChange;
  TagButton({required this.activeButtonIndex,required this.index,required this.title,
    this.onChange
  });
  @override
  State<TagButton> createState() => _TagButtonState();
}

class _TagButtonState extends State<TagButton> {

  @override
  void initState() {

  }
  //int _selectedIndex = 4;
  //UserPreferences
  @override
  Widget build(BuildContext context) {
    //HalqaProvider auth = Provider.of<HalqaProvider>(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          this.widget.activeButtonIndex = this.widget.index; // Update the active button index
        });
        if(this.widget.onChange!=null)
          this.widget.onChange!();
        //getMosques(true);
      },
      child: Container(
        // width: 50,
        //height: 50,
        margin: EdgeInsets.symmetric(horizontal: 3),
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
          color: this.widget.activeButtonIndex == this.widget.index ? AppColors.secondly : Colors.transparent,
          border: Border.all(color: AppColors.secondly),
        ),
        alignment: Alignment.center,
        child: Text(
          this.widget.title,
          style: TextStyle(color: this.widget.activeButtonIndex == this.widget.index ? Colors.white : AppColors.secondly,fontSize: 12),
        ),
      ),
    );
  }
}

Widget AppTag({String? title,bool? isActive,Color color=AppColors.gray}){

  return Container(
    // width: 50,
    //height: 50,
    margin: EdgeInsets.symmetric(horizontal: 3),
    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
      color: color.withOpacity(.1),

    ),
    alignment: Alignment.center,
    child: Text(
      title??"",
      style: TextStyle(color: color,fontSize: 12,fontWeight: FontWeight.bold),
    ),
  );
}

Widget AppTagSm({String? title,bool? isActive,Color color=AppColors.gray}){

  return Container(
    // width: 50,
    //height: 50,
    margin: EdgeInsets.symmetric(horizontal: 2),
    padding: EdgeInsets.symmetric(horizontal: 6,vertical: 3),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(8), // Adjust the radius as needed
      color: color.withOpacity(.1),

    ),
    alignment: Alignment.center,
    child: Text(
      title??"",
      style: TextStyle(color: color,fontSize: 9,fontWeight: FontWeight.bold),
    ),
  );
}

Widget CustomTag({String? title,bool? isActive,int? colorId}){
  Color color=AppColors.secondly;
  if(colorId!=null)
    color=OdooColor[colorId]??AppColors.secondly;
  return Container(
    // width: 50,
    //height: 50,
    margin: EdgeInsets.symmetric(horizontal: 2),
    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
      color: (isActive??false) ? color : Colors.transparent,
      border: Border.all(color: color),
    ),
    alignment: Alignment.center,
    child: Text(
      title??"",
      style: TextStyle(color: (isActive??false) ? Colors.white : AppColors.secondly,fontSize: 11),
    ),
  );
}

Widget MultiTag({String? title,bool? isActive,int? colorId,Function? onTab}){

  return Container(
    // width: 150,
    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Container(
      child: Wrap(
        children: [
          Text(
            title??"",
            style: TextStyle(fontSize: 12.0),
          ),

          onTab==null?SizedBox(width: 1,):GestureDetector(
            onTap: (){
              if(onTab!=null)
                onTab!();

            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.close, color: Colors.grey,size: 15,)),
          ),
        ],
      ),
    ),
  );
}


class AppNewTagButton extends StatefulWidget {
  dynamic activeButtonIndex;
  bool isActive;
  final dynamic? index;
  final String title;
  final bool? isDisable;
  final Function? onChange;
  final Widget? icon;
  final Color color;
  AppNewTagButton({Key? key,this.activeButtonIndex=0,this.index,required this.title,this.isDisable,
    this.onChange,this.color=AppColors.tertiary,this.icon,this.isActive=false
  }): super(key: key);
  @override
  State<AppNewTagButton> createState() => _AppNewTagButtonState();
}

class _AppNewTagButtonState extends State<AppNewTagButton> {

  @override
  void initState() {

  }

   bool get isActive=> this.widget.activeButtonIndex == this.widget.index || widget.isActive;

  //int _selectedIndex = 4;
  //UserPreferences
  @override
  Widget build(BuildContext context) {

    //HalqaProvider auth = Provider.of<HalqaProvider>(context);
    return GestureDetector(
      onTap: () {
        if((this.widget.isDisable??false)==false){
          setState(() {
            if(this.widget.index!=null){
              this.widget.activeButtonIndex = this.widget.index!;
            }
            // Update the active button index
          });
          if(this.widget.onChange!=null)
            this.widget.onChange!();
        }
      },
      child: Container(

        // width: 50,
        //height: 50,
        constraints: BoxConstraints(
          minWidth: 50, // Set your desired minimum width here
        ),
        margin: EdgeInsets.symmetric(horizontal: 3),
        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: isActive
                ? AppColors.tertiary // Active border color
                : Colors.grey.shade300, // Inactive border color
            width: 1.5, // Adjust the border width if needed
          ),
          borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
          color: (isActive) ? this.widget.color : AppColors.backgroundColor,

        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // if (this.widget.activeButtonIndex == this.widget.index) ...[
            //   Icon(Icons.check, size: 16, color: Colors.white.withOpacity(0.7)),
            //   SizedBox(width: 4),
            // ],
            widget.icon??Container(),
            Text(
              this.widget.title,
              style: TextStyle(
                color: isActive
                    ? Colors.white.withOpacity(.7)
                    : AppColors.gray,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

      ),
    );
  }
}