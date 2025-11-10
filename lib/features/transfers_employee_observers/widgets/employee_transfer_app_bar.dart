import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class EmployeeTransferAppBar extends StatelessWidget {
  final String title ;
  const EmployeeTransferAppBar({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 50,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(.7),
              size: 25,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(.9),
            ),
          ),
        ],
      ),
    );
  }
}
