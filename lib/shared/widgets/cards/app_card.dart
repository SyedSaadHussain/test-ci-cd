import 'package:flutter/material.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? barColor;
  final bool? isLoading;
  final Function? onTap;

  AppCard({
    required this.child,
    this.isLoading,
    this.color,
    this.barColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          IntrinsicHeight(
            child: Container(

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: this.color?.withOpacity(.3) ?? Colors.grey.shade200,
                  // color: Colors.grey.shade200,
                  width: this.color == null ? 0 : 1.0,
                  // width: 0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    offset: Offset(0, 3),
                    blurRadius: 4,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              margin: EdgeInsets.only(bottom: 15),
              child: Container(
                decoration: BoxDecoration(
                   color: this.color?.withOpacity(.03) ?? Colors.grey.shade200,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch, // important!
                  children: [
                    // Left bar
                    Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: ListTile(
                          onTap: () {
                            if (onTap != null) this.onTap!();
                          },
                          contentPadding: EdgeInsets.all(0),
                          title: this.child,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Loading overlay
          (isLoading ?? false)
              ? Positioned.fill(
            child: ProgressBar(opacity: .2),
          )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}