import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/login/login_view_model.dart';
import 'package:mosque_management_system/features/login/widget/user_guide_button.dart';
import 'package:provider/provider.dart';

class ActionButtons extends StatelessWidget {

  const ActionButtons({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Row(
      children: [
        if (!(vm.canCheckBiometrics??false))
          Container()
        else if (vm.isAuthenticating)
          TextButton(
            onPressed: vm.cancelAuthentication,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('cancel_authentication'.tr(),style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),), // Display the current language code
                SizedBox(width: 5), // Add some space between text and icon
                Icon(Icons.cancel,color: Theme.of(context).colorScheme.onPrimary,), // Add an icon (you can replace it with your desired icon)
              ],
            ),
          )
        else
          TextButton(
            onPressed: (){
              vm.authenticate(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.fingerprint,color: Theme.of(context).colorScheme.primary,),
                SizedBox(width: 5),
                Text('using_biometric'.tr(),style: TextStyle(color: Theme.of(context).colorScheme.primary),), // Display the current language code
              ],
            ),
          ),
        Expanded(child: Container()),
        UserGuideButton(),
      ],
    );
  }
}