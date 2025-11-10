import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_check_box.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_new_tag_button.dart';

enum SingleSelectionFieldType {
  selection,
  radio,
  checkBox
}


class AppSelectionField extends StatefulWidget {
  final Function? onSave;
  final Function? onTab;
  final Function? onChanged;
  final String? title;
  final bool isRequired;
  final bool isDisable;
  final bool isReadonly;
  final dynamic value;
  final bool? isShowWarning;
  final  SingleSelectionFieldType type;
  List<ComboItem>? options;
  final Widget? action;
//List<DropdownMenuItem<String>>
  AppSelectionField({ Key? key,
    this.onSave,this.onTab,this.onChanged,this.title,this.value,this.options,this.type=SingleSelectionFieldType.selection,
    this.isRequired=false, this.isDisable=false, this.isReadonly=false,this.isShowWarning=false,this.action
    });

  @override
  _AppSelectionFieldState createState() => _AppSelectionFieldState();
}

class  _AppSelectionFieldState extends State<AppSelectionField> {

  late dynamic selectedValue;

  @override
  void initState() {
    selectedValue=widget.value;
  }


  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }
  // final TextEditingController _controller = TextEditingController();

  //update when parent wiget rebuild
  @override
  void didUpdateWidget(covariant AppSelectionField oldWidget) {

    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if(this.widget.value!=null && this.widget.value!=''){
        selectedValue=widget.value;
        setState(() {

        });
      }else{
        // _controller.text = '';
      }
    });
  }
  //update first time
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(this.widget.value!=null && this.widget.value!=''){

        selectedValue=widget.value;

    }else{
      // _controller.text = '';
    }
  }
  List<ComboItem> getItems(){
    final items = this.widget.options??[];

    // Check if the list contains "yes"
    final containsYes = items.any(
          (e) => e.key.toString().toLowerCase() == 'yes',
    );

    if (containsYes) {
      print('yes...........');
      final yes = items.where(
            (e) => e.key.toString().toLowerCase() == 'yes',
      );
      final no = items.where(
            (e) => e.key.toString().toLowerCase() == 'no',
      );
      final others = items.where((e) {
        final v = e.key.toString().toLowerCase();
        return v != 'yes' && v != 'no';
      });

      return [...yes, ...no, ...others];
    }

    // If no "yes" found, return original order
    return items;
  }
  @override
  Widget build(BuildContext context) {



    return  Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(
                child: Text(this.widget.title??"",style:(widget.isShowWarning??false)?AppTextStyles.warningLabel:AppTextStyles.formLabel,
                ),
              ),
              widget.action??Container()
            ],
          ),
          this.widget.type==SingleSelectionFieldType.checkBox?
          FormField<int>(
              validator: (value) {
                if (this.widget.isRequired &&
                    (this.widget.value == null || (this.widget.value!=null && this.widget.value.length==0))) {
                  return 'please_select_an_option'.tr();
                }
                return null;
              },
              builder: (FormFieldState<int> field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    runSpacing: 8.0, // Optional: space between lines
                    children: (this.widget.options??[])!.map((item) {
                      // (this.widget.value??[]).contains(item.key)
                      return IntrinsicWidth(
                        child: AppCheckBox(
                          isChecked: (this.widget.value??[]).contains(item.key),
                          title: (item.value??""),
                          onChange: () {
                            this.widget.onChanged!(item,!(this.widget.value??[]).contains(item.key));
                          },
                        ),
                      );

                    }).toList(),
                  ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        field.errorText ?? '',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              );
            }
          ):
          this.widget.type==SingleSelectionFieldType.radio?
          FormField<int>(
              validator: (value) {
                if (this.widget.isRequired && AppUtils.isNullOrEmpty(this.widget.value)  && AppUtils.isNullOrEmpty(selectedValue)) {
                  return 'please_select_an_option'.tr();
                }
                return null;
              },
            builder: (FormFieldState<int> field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(selectedValue??''),
                  Wrap(
                    runSpacing: 8.0, // Optional: space between lines
                    children: getItems().map((item) {

                      return IntrinsicWidth(
                        child: AppNewTagButton(
                          index: item.key,
                          isDisable:this.widget.isDisable,
                          activeButtonIndex: selectedValue,
                          title: (item.value??""),
                          onChange: () {
                            selectedValue=item.key;
                              setState(() {

                              });
                              this.widget.onChanged!(item.key);


                          },
                        ),
                      );

                    }).toList(),
                  ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        field.errorText ?? '',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              );
            }
          ):
          DropdownButtonHideUnderline(
            child: AbsorbPointer(
              absorbing: this.widget.isDisable,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true, // This will make sure the background is filled
                  fillColor: Colors.grey[100], // Background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.grey), // Default border color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.grey), // Gray when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.grey), // Gray when focused
                  ),
                  hintText: 'select_option'.tr(), // Placeholder text
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Reduce padding here
                  // hintText: 'select_option'.tr(), // Placeholder text
                ),
                validator: (text) {
                  if (this.widget.isRequired && (text == null || text.isEmpty)) {
                    return 'please_select_an_option'.tr();
                  }
                  return null;
                },
                // hint: Text('select_option'.tr()),
                hint: Text('select_option'.tr()),
                value: AppUtils.isNotNullOrEmpty(selectedValue)?selectedValue:null,
                onChanged: (String? newValue) {
                  // setState(() {
                  //   _controller.text = newValue.toString();
                  // });
                  selectedValue= newValue.toString();
                  if(this.widget.onChanged!=null)
                    this.widget.onChanged!(newValue.toString());
                },

                items:(this.widget.options??[])!.length>0?
                this.widget.options!.map((item){
                  return DropdownMenuItem<String>(
                    value: item.key.toString(),
                    child: Text(item.value??"", overflow: TextOverflow.visible,),
                  );
                }).toList()
                    :[],
                selectedItemBuilder: (BuildContext context) {
                  return (this.widget.options ?? []).map((item) {
                    return Text(
                      item.value ?? "",
                      overflow: TextOverflow.ellipsis, // Ellipsis for selected item
                      maxLines: 1,
                    );
                  }).toList();
                },
                style: TextStyle(color: Colors.grey, fontSize: 14),
                dropdownColor: Colors.grey[100],


              ),
            ),
          ),
        ],
      ),
    );
  }



}
