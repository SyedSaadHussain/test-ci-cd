import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/styles/app_input_decoration.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';

class AppSearchInputField extends StatefulWidget {
  final Function onSearch;
  final Function? onChange;
  final String? hint;

  const AppSearchInputField({
    super.key,
    required this.onSearch,
    this.onChange,
    this.hint
  });

  @override
  State<AppSearchInputField> createState() => _AppSearchInputFieldState();
}

class _AppSearchInputFieldState extends State<AppSearchInputField> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterList() {
    widget.onSearch(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10,bottom:10,left: 10 ),
      decoration: BoxDecoration(
        color: Colors.white, // background for shadow to be visible
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200, // border color
          width: 1,                     // border width
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // shadow color
            blurRadius: 6, // spread of blur
            offset: Offset(0, 4), // x,y position of shadow
          ),
        ],
      ),
      child: TextFormField(
        controller: _searchController,
        onEditingComplete: () {
          _filterList();
        },
        onChanged: (val) {
          print(val.isEmpty);
          setState(() {}); // updates the close icon
          if (val.isEmpty) _filterList();

          if(widget.onChange!=null){
             widget.onChange!(_searchController.text);
          }

        },
        style: TextStyle(color: AppColors.gray),
        decoration: AppInputDecoration.defaultInputDecoration(label: this.widget.hint??"search".tr(),icon: Icons.search,
            onTab: (){
              this.widget.onSearch(_searchController.text);
            },isCloseIcon: AppUtils.isNotNullOrEmpty(_searchController.text),
            onClose: (){
              _searchController.text='';
              this.widget.onSearch(_searchController.text);
            }
        ),
      ),
    );
  }
}