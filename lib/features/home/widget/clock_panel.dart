import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/utils/current_date.dart';
import 'package:mosque_management_system/features/home/home_view_model.dart';
import 'package:mosque_management_system/shared/widgets/prayer_clock.dart';
import 'package:provider/provider.dart';

class ClockPanel extends StatelessWidget {

  const ClockPanel({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final CurrentDate currentDate=CurrentDate();
    return   Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          Expanded(child: PrayerClock(onTab: (){
            // loadPrayerTime();
          }, size: 180,currentDate: currentDate.hijriMonthYear,
            title: Column(
              children: [
                Row(
                  children: [
                    Text(
                      (vm.prayerTime?.currentPrayerTime??""),
                      style: TextStyle(
                        color: Colors.white.withOpacity(.8),
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(width: 2,),
                    Text(
                      (vm.prayerTime?.currentPrayerName.tr()??""),
                      style: TextStyle(
                        color: Colors.white.withOpacity(.8),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      ' >> ',
                      style: TextStyle(
                          color: Colors.white.withOpacity(.8),
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      (vm.prayerTime?.upComingPrayerTime??""),
                      style: TextStyle(
                        color: Colors.white.withOpacity(.8),
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(width: 2,),
                    Text(
                      (vm.prayerTime?.upComingPrayerName.tr()??""),
                      style: TextStyle(
                        color: Colors.white.withOpacity(.8),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                Text(vm.prayerTime?.city??"", style: TextStyle(
                  color: Colors.white.withOpacity(.8),
                  fontSize: 10,
                ),)
              ],
            ),)),
        ]
    );
  }
}