import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_analog_clock/animated_analog_clock.dart' as analogClock;
import 'package:mosque_management_system/core/constants/app_colors.dart';

class PrayerClock extends StatelessWidget {
  final double size;
  final String currentDate;
  final String location;
  final Widget? title;
  final Function? onTab;

  // Constructor to receive the parameters
  PrayerClock({Key? key, required this.size,required this.currentDate,this.location="Asia/Riyadh",this.title,this.onTab}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.teal,

      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipOval(
            child: Container(
              height: this.size,
              width:  this.size,
              child: Image.asset(
                'assets/images/clock.png', // Use your custom PNG image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 50, // Adjust as needed for spacing
            child: title??SizedBox.shrink(),
          ),
          Positioned(
            bottom: 40, // Adjust as needed for spacing
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
              // height: 20, // Adjust as needed
              // width: 250, // Adjust as needed
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20), // Adjust for desired corner roundness
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  this.currentDate,
                  style: TextStyle(
                    color: AppColors.primary, // Change text color as needed
                    fontSize: 10, // Adjust font size as needed
                    fontWeight: FontWeight.w700, // Optional: change font weight
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              this.onTab!();
            },

            child: analogClock.AnimatedAnalogClock(
              size: this.size,
              location: this.location,
              showSecondHand: true,
              hourHandColor: AppColors.secondly.withOpacity(.8),
              minuteHandColor: AppColors.secondly.withOpacity(.8),
              secondHandColor: AppColors.secondly.withOpacity(.8),
              backgroundColor: Colors.transparent,
              centerDotColor:AppColors.secondly,
              numberColor: Colors.white, // Set the numbers in white
              dialType: analogClock.DialType.none,
              extendHourHand: true,
            ),
          )
        ],
      ),
    );
  }
}
