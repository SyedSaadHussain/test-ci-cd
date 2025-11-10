import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

class UtilitiesItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const UtilitiesItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: AppColors.secondly.withOpacity(.4),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(
            color: AppColors.secondly.withOpacity(.3),
            // Change this to the color you want for the border
            width: 0.0, // You can adjust the width of the border as needed
          ),
        ),
        margin: EdgeInsets.all(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                  child: Icon(
                icon,
                size: 50,
                color: AppColors.primary,
              )),
            ),
            Text(
              title,
              style: TextStyle(color: AppColors.primary, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
