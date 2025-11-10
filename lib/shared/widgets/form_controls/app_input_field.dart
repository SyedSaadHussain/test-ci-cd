import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';

enum InputFieldType {
  textField,
  number,
  double,
  textArea
}


class AppInputField extends StatefulWidget {

  final Function? onSave;
  final Function? onTab;
  final Function? onChanged;
  final String? title;
  final bool isRequired;
  final bool isDisable;
  final bool isReadonly;
  final RegExp? validationRegex;
  final RegExp? denyRegex;
  final String? validationError;
  final dynamic value;
  final  InputFieldType type;
  final Widget? action;

//List<DropdownMenuItem<String>>
  AppInputField({
    Key? key,                       // ← add this
    this.onSave,this.onTab,this.onChanged,this.title,this.value,this.type=InputFieldType.textField,
    this.isRequired=false, this.isDisable=false, this.isReadonly=false,this.validationError,this.validationRegex,this.denyRegex,this.action
    }): super(key: key);

  @override
  _AppInputFieldState createState() => _AppInputFieldState();
}

class  _AppInputFieldState extends State<AppInputField> {

  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    if(widget.onSave!=null && widget.type == InputFieldType.double){
      _focusNode.addListener(() {
        if (!_focusNode.hasFocus) {
          callOnSaveMethod();
        }
      });
    }
  }

  void callOnSaveMethod(){
    if (widget.onSave!=null && widget.type == InputFieldType.double &&
        AppUtils.isNotNullOrEmpty(_controller.text) &&
        double.tryParse(_controller.text) != null) {
      widget.onSave!(double.parse(_controller.text));
    }
  }


  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }
  final TextEditingController _controller = TextEditingController();
  final OutlineInputBorder outlineInputBorder = OutlineInputBorder(

    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
      color: Colors.grey, // Adjust opacity or use Colors.grey directly
      width: 1.0, // This ensures it's 1px wide
    ),
  );
 //update when parent wiget rebuild
  @override
  void didUpdateWidget(covariant AppInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if(this.widget.value!=null && this.widget.value!=''){
        _controller.text=this.widget.value.toString()??"";
      }else{
        _controller.text = '';
      }
    });
  }
  //update first time
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(this.widget.value!=null && this.widget.value!=''){
      _controller.text=this.widget.value.toString()??"";
    }else{
      _controller.text = '';
    }
  }
  @override
  Widget build(BuildContext context) {

    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Expanded(
              child: Text(
                widget.title ?? "",
                style: AppTextStyles.formLabel,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.action != null)
              Padding(
                // adds space after the action; flips automatically in RTL
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: widget.action!,
              ),
          ],
        ),

        const SizedBox(height: 6),

        Container(
          // decoration: BoxDecoration(
          //   border: Border.all(color: Colors.grey.shade500, width: 1),
          //   borderRadius: BorderRadius.circular(10),
          //   color: AppColors.formField,
          // ),
          child: TextFormField(
            focusNode: _focusNode,
            //this.widget.type==FieldType.textArea?
            //this.isDisable
            maxLines: null,  // Allows the TextFormField to be multi-line
            // minLines: this.widget.type==InputFieldType.textArea?2:1,     // Sets the minimum number of lines
            // keyboardType:this.widget.type==InputFieldType.textArea?TextInputType.multiline:this.widget.type==InputFieldType.number?TextInputType.number:
            keyboardType:this.widget.type==InputFieldType.number?TextInputType.number:
            this.widget.type==InputFieldType.double?TextInputType.numberWithOptions(decimal: true):TextInputType.text,
            inputFormatters:this.widget.type==InputFieldType.number? <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ]:this.widget.type==InputFieldType.double?
            <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ]
                : <TextInputFormatter>[
                  if(widget.denyRegex!=null)
                    FilteringTextInputFormatter.deny(widget.denyRegex!),

            ],
            validator: (text) {
              if (this.widget.isRequired && (text == null || text.isEmpty)) {
                return 'this_field_is_required'.tr();
              }
              if (widget.validationRegex != null &&
                  !widget.validationRegex!.hasMatch(text??"")) {
                return widget.validationError ?? 'invalid'.tr();
              }
              return null;
            },
            onChanged: (val){

              if(this.widget.onChanged!=null){
                if(this.widget.type==InputFieldType.number)
                  this.widget.onChanged!(val==''?null:int.parse(val!));
                else if(this.widget.type==InputFieldType.double){
                  if(AppUtils.isNotNullOrEmpty(val) && double.tryParse(val!)!=null){
                    this.widget.onChanged!(val==''?null:double.parse(val!));
                  }else{
                    this.widget.onChanged!(null);
                  }


                }
                else
                  this.widget.onChanged!(val);
              }
            },
            onSaved: (val){

              if(this.widget.onSave!=null){
                if(this.widget.type==InputFieldType.number)
                  this.widget.onSave!(val==''?null:int.parse(val!));
                else if(this.widget.type==InputFieldType.double)
                  this.widget.onSave!(val==''?null:double.parse(val!));
                else
                  this.widget.onSave!(val);
              }

            },
            onTapOutside: (val){
              try{
                _focusNode.unfocus();
              }catch(e){

              }
              callOnSaveMethod();
            },
            enabled:!this.widget.isDisable,
            onTap: (){
              if(this.widget.onTab!=null)
                this.widget.onTab!();

            },

            readOnly:this.widget.isReadonly || widget.onTab!=null,
            controller: _controller,
            style: TextStyle(color: Colors.grey),
            decoration: InputDecoration(
              suffixIcon: widget.onTab!=null?Icon(Icons.unfold_more,color: AppColors.gray,):null,
              filled: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),

              labelStyle: TextStyle(color: Colors.blue), // Set label text color
              hintStyle: TextStyle(
                color: Colors.grey.withOpacity(0.7),
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
              ),
              fillColor: this.widget.isDisable?AppColors.formDisabledField:AppColors.formField,

              // Customize the appearance of the input fields for the first theme
              focusedBorder: outlineInputBorder,
              enabledBorder: outlineInputBorder,
              disabledBorder:outlineInputBorder,
              border: outlineInputBorder,
              // Add more customizations as needed
            ),
          ),
        ),

      ],

    );
  }



}
