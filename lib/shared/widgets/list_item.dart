import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

class AppListItem extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Function? onTap;

  AppListItem({
    required this.child,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: this.color??Colors.grey.shade200,
          width: this.color==null?0:1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06), // Shadow color
            offset: Offset(0, 3), // X and Y offset
            blurRadius: 4, // Blur radius
            spreadRadius: 2, // Spread radius
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      margin: EdgeInsets.only(bottom: 15),
      child: ListTile(
        onTap: () {
          if(onTap!=null)
            this.onTap!();
        },
        contentPadding: EdgeInsets.all(0),
        title: this.child,
      ),
    );
  }
}

class AppListItemBorder extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Function? onTap;

  AppListItemBorder({
    required this.child,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Container(
        padding: EdgeInsets.only(top: 10,bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 2,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}