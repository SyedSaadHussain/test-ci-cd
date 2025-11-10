import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/utils/paginated_list.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';


class AppModelField<T> extends StatefulWidget {
  final Function? onSave;
  final Function? onTab;
  final Function? onChanged;
  final Function? onSearchRecords;
  final String? title;
  final bool isRequired;
  final bool isReadonly;
  final dynamic value;
  final bool? isShowWarning;
  List<ComboItem>? options;
  final Widget? action;
  final Widget? list;
  PaginatedList<T>? data;

  AppModelField({
    this.onSave,this.onTab,this.onChanged,this.title,this.value,this.options,
    this.isRequired=false,this.onSearchRecords,
    this.isReadonly=false,this.isShowWarning=false,this.action,this.data,this.list
    });

  @override
  _AppModelFieldState createState() => _AppModelFieldState();
}

class  _AppModelFieldState<T> extends State<AppModelField<T>> {

  late dynamic selectedValue;

  @override
  void initState() {
    selectedValue=widget.value;
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  final TextEditingController _controller = TextEditingController();

  PaginatedList<ComboItem> data=PaginatedList<ComboItem>();


  onShowModel(){

    showModalBottomSheet(

      context: context,
      builder: (BuildContext context) {
        print('widget.data');
        print(widget.data?.list);
        return Container(
          // margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), // Adjust top radius here
              topRight: Radius.circular(8),
            ),
          ),

          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5,vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.title??''),
                SizedBox(height: 10),
                Expanded(
                  child: widget.list!,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    if(this.widget.value!=null && this.widget.value!=''){
      _controller.text=this.widget.value.toString()??"";
    }else{
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = '';
      });

    }
    return  Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
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
            Container(

              child:  FormField<int>(
                    validator: (value) {
                      if (this.widget.isRequired && AppUtils.isNullOrEmpty(widget.value)) {
                        return 'please_select_an_option'.tr();
                      }
                      return null;
                    },
                    builder: (FormFieldState<int> field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:  AppColors.formField,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ListTile(

                            onTap: (){
                              onShowModel();
                            },
                            title: AppUtils.isNotNullOrEmpty(widget.value)?Text(widget.value??'',style: TextStyle(color: Colors.grey),):Text('select_option'.tr(),style:TextStyle(color: Colors.grey.shade400)),
                            trailing: Icon(Icons.arrow_right),
                          ),
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
                ),
            )
          ],
        ),
      ),
    );
  }



}
