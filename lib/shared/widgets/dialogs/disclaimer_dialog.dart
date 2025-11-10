import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';

void showDisclaimerDialog(BuildContext context,{String? text,Function? onApproved}) {
  bool isApproved = false; // Initial state of the switch

  showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('terms_condition'.tr()),
              content:  Wrap(
                children: [
                  Text(text??""),
                  SizedBox(height:10 ,),
                  Row(
                    children: [
                      Text('accept_terms_condition'.tr()),
                      Expanded(child: Container()),
                      Switch(
                        inactiveThumbColor: AppColors.gray.withOpacity(.5), // Color of the thumb when the switch is OFF
                        inactiveTrackColor: AppColors.gray.withOpacity(.3),
                        value:isApproved,
                        onChanged: (value) {
                          setState(() {
                            isApproved=value;
                          });
                        },

                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                Row(
                  children: [
                    Expanded(child: PrimaryButton(text: 'approve'.tr(),onTab:isApproved?(){
                      Navigator.of(context).pop(true);
                    }:null)),
                    Expanded(child: SecondaryButton(text: 'reject'.tr(),onTab: (){
                      Navigator.of(context).pop(false);
                    })),

                  ],
                ),

              ],
            );
          }
      );
    },
  ).then((res) {

    if (res == true) {
      if(onApproved!=null)
        onApproved();
    }
  });
}

void showDisclaimerDialogWithReason(BuildContext context,{String? text,Function? onApproved,String? fieldLabel,bool isRequired=false}) {
  bool isApproved = false; // Initial state of the switch
  String reason = ""; // Initial state of the switch

  showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      final _formKey = GlobalKey<FormState>();
      return StatefulBuilder(
          builder: (context, StateSetter setState) {

            return AlertDialog(
              title: Text('terms_condition'.tr()),
              content:  Wrap(
                children: [
                  Text(text??""),
                  SizedBox(height:10 ,),
                  Row(
                    children: [
                      Text('accept_terms_condition'.tr()),
                      Expanded(child: Container()),
                      Switch(
                        inactiveThumbColor: AppColors.gray.withOpacity(.5), // Color of the thumb when the switch is OFF
                        inactiveTrackColor: AppColors.gray.withOpacity(.3),
                        value:isApproved,
                        onChanged: (value) {
                          setState(() {
                            isApproved=value;
                          });
                        },

                      ),
                    ],
                  ),
                  Text(fieldLabel??""),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (text) {
                        if (isRequired==true && text!.isEmpty) {
                          setState(() {

                          });
                          return '';
                        }
                        return null;
                      },
                      maxLines: null, // Allows for multi-line input
                      keyboardType: TextInputType.multiline,
                      onChanged: (value) {
                        setState(() {
                          reason = value; // Update the current value
                        });
                      },
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                Row(
                  children: [
                    Expanded(child: PrimaryButton(text: 'approve'.tr(),onTab:isApproved?(){
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(true);
                      }
                    }:null)),
                    Expanded(child: SecondaryButton(text: 'reject'.tr(),onTab: (){
                      Navigator.of(context).pop(false);
                    })),

                  ],
                ),

              ],
            );
          }
      );
    },
  ).then((res) {
    if (res == true) {
      if(onApproved!=null)
        onApproved(reason);
    }
  });

  }
void showDisclaimerWithInputAndToggle(
    BuildContext context, {
      required String disclaimerText,
      required String fieldLabel,
      required String validationText,
      required Function(String actionText, bool acceptTerms) onApproved
    }) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  bool acceptTerms = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text('terms_condition'.tr()),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(disclaimerText),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("accept_terms_condition".tr()),
                    Spacer(),
                    Switch(
                      value: acceptTerms,
                      inactiveThumbColor: AppColors.gray.withOpacity(.5),
                      inactiveTrackColor: AppColors.gray.withOpacity(.3),
                      onChanged: (val) => setState(() => acceptTerms = val),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: fieldLabel,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return validationText;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'action'.tr(),
                    onTab: acceptTerms
                        ? () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        onApproved(_controller.text.trim(),acceptTerms); // ✅ SAFE
                      }
                    }
                        : null,
                  ),
                ),
                Expanded(
                  child: SecondaryButton(
                    text: 'cancel'.tr(),
                    onTab: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        );
      });
    },
  );
}
