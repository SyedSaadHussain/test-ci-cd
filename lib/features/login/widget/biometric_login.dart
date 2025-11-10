import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/login/login_view_model.dart';
import 'package:mosque_management_system/features/login/widget/user_guide_button.dart';
import 'package:mosque_management_system/shared/widgets/wave_loader.dart';
import 'package:provider/provider.dart';

class BiometricLogin extends StatelessWidget {

  const BiometricLogin({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: vm.isLoading?null:() => vm.authenticate(context), // Call _handleLogin method on button press
            child: SizedBox(
              width: double.infinity,
              child:vm.isLoading?WaveLoader(color: Theme.of(context).colorScheme.primary,size: 25)  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fingerprint), // Add your login icon here
                  SizedBox(width: 8), // Add some spacing between the icon and text
                  Text(
                    "login".tr(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed:(){
                vm.loginWithUserName=true;
                vm.notifyListeners();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.login,color: Theme.of(context).colorScheme.primary,),
                  SizedBox(width: 5),
                  Text('login_another_account'.tr(),style: TextStyle(color: Theme.of(context).colorScheme.primary),), // Display the current language code
                ],
              ),
            ),
            Expanded(child: Container()),
            UserGuideButton(),
          ],
        )
      ],
    );
  }
}