import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/styles/app_input_decoration.dart';
import 'package:mosque_management_system/features/login/login_view_model.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';
import 'package:mosque_management_system/shared/widgets/wave_loader.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);
  @override
  State<LoginForm> createState() => _LoginFormState();
}


class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
      color: Colors.white.withOpacity(.2), // Set your desired border color here
    ),
  );




  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    return Column(
      children: [
        TextFormField(
          style: TextStyle(color: Colors.grey),
          decoration: AppInputDecoration.firstInputDecoration(context,label: "user_name".tr(),icon: Icons.person),
          controller: _usernameController,
          validator: (value) {

            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },

        ),
        SizedBox(height: 10.0),
        TextFormField(
          autocorrect: false,
          enableSuggestions: false,

          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
          controller: _passwordController,
          obscureText: vm.isObscureText,
          style:  TextStyle(color: Colors.grey),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
            suffixIcon: IconButton(
              icon: Icon(
                vm.isObscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                color: Colors.grey,
              ),
              onPressed: vm.togglePasswordVisibility,
            ),
            labelStyle: TextStyle(color: Colors.blue), // Set label text color
            hintStyle: TextStyle(color: Colors.blue),
            label: Text("password".tr(),style: TextStyle(color: Colors.grey.withOpacity(.4)),),
            fillColor: Colors.grey.withOpacity(.2),

            // Customize the appearance of the input fields for the first theme
            focusedBorder: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            border: outlineInputBorder,
            // Add more customizations as needed
          ),


        ),
        SizedBox(height: 5.0),
        Container(
            width: 150,
            child: PrimaryButton(text: "login".tr(),onTab:vm.isLoading?null:()=>vm.doLogin(context,_usernameController.text,_passwordController.text),icon:Icons.login)),
      ],
    );
  }
}