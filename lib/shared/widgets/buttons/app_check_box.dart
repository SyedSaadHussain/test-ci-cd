
import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

class AppCheckBox extends StatelessWidget {
  final bool isChecked;
  final void Function()? onChange;
  final String title;
  final Color color;

  const AppCheckBox({
    Key? key,
    required this.isChecked,
    required this.title,
    this.color=AppColors.tertiary,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        if (onChange != null) {
          onChange!();
        }
      },
      child: Container(
        constraints: BoxConstraints(minWidth: 50),
        margin: EdgeInsets.symmetric(horizontal: 3),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          color: isChecked ? color : AppColors.backgroundColor,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(this.isChecked?Icons.check_box
                :Icons.check_box_outline_blank_sharp
                , size: 16, color: this.isChecked?Colors.white.withOpacity(0.7):AppColors.gray),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isChecked ? Colors.white.withOpacity(.7) : AppColors.gray,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}