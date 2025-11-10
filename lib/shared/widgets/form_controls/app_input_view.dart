import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_new_tag_button.dart';

enum ListType {
  tag,
  date,
  text,
  image,
  multiSelect
}
String add_zero(your_number) {
  // return your_number.toString();
  var num = '' + your_number.toString();
  if (your_number < 10) {
    num = '0' + num;
  }
  return num;
}
Widget AppInputView({Function? onTab,String title="",dynamic value,List<ComboItem>? options,ListType type=ListType.text,
bool? isShowWarning,Widget? child,Widget? action
}) {

  String text=(value??'').toString();
  if(options!=null && options.length>0){

    var filteredList = options!.where((rec) => rec.key == value);
    if (filteredList.isNotEmpty) {
      text = filteredList.first.value.toString();
    }

  }else if(type==ListType.date){
    if(AppUtils.isNotNullOrEmpty(value)){

      var selectedDateHijri = new HijriCalendar.now();
      DateTime? _selectedDate=DateTime.tryParse(value);
      if(_selectedDate!=null && _selectedDate.year>1937){
        selectedDateHijri = new HijriCalendar.fromDate(_selectedDate!);
        text += ' / '+(selectedDateHijri.hYear.toString() +
            '-' +
            add_zero(selectedDateHijri.hMonth) +
            '-' +
            add_zero(selectedDateHijri.hDay).toString());
      }
    }
  }
  return  Column(
    children: [
      SizedBox(height: 5,),
      Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(

          // color: Colors.green,
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            onTap:(){
              if(onTab!=null)
                onTab!();
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title.isEmpty?Container():
                Row(
                  children: [
                    Expanded(child: Text((title??""),style:(isShowWarning??false)?AppTextStyles.warningLabel:AppTextStyles.formLabel.copyWith(color: Colors.black.withOpacity(.3)))),
                    action??Container()
                  ],
                ),
                child??(type==ListType.multiSelect?Wrap(
                    spacing: 5.0, // spacing between adjacent widgets
                    runSpacing: 8.0,
                    children: (options??[])!.map((rec){
                      return MultiTag(title:rec.value??"");
                    }).toList() ):Text((text??"")+'',style: TextStyle(color: Colors.black.withOpacity(.6),fontSize: 15)))
              ],
            ),

          ),
        ),
      ),
      Divider(color: Colors.grey.shade200,height: 1,)
    ],

  );
}
