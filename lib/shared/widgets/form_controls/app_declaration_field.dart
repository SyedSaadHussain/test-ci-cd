import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

class AppDeclarationField extends StatefulWidget {
  final bool? value;
  final ValueChanged<bool>? onChanged; // callback when switch changes
  final String? label;                // text shown next to switch

  const AppDeclarationField({
    super.key,
    this.onChanged,
    this.value,
    this.label,
  });

  @override
  State<AppDeclarationField> createState() => _AppDeclarationFieldState();
}

class _AppDeclarationFieldState extends State<AppDeclarationField> {
  bool isAgree = false;

  @override
  void initState() {
    super.initState();
    isAgree=widget.value??false;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.value==true){
      isAgree=true;
    }
    return Column(
      children: [
        FormField<String>(
          validator: (_) {
            if (!isAgree) {
              return 'Please Confirm'.tr();
            }
            return null;
          },
          initialValue: isAgree.toString(),
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      widget.label??'تم التدقيق',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        inactiveThumbColor: AppColors.gray.withOpacity(.5),
                        inactiveTrackColor: AppColors.gray.withOpacity(.3),
                        activeColor: AppColors.success,
                        activeTrackColor: AppColors.success.withOpacity(.3),
                        value: isAgree,
                        onChanged: (val) {
                          setState(() {
                            isAgree = val;
                          });
                          widget.onChanged?.call(val);
                          field.didChange(val.toString());
                        },
                      ),
                    ),
                  ],
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      field.errorText ?? '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}