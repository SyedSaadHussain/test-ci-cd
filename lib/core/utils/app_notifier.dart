import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/network_error_handler.dart';

enum DialogType { errorException, errorText, successText, error }

class DialogMessage {
  final DialogType type;
  final dynamic message;
  final bool hideTimeOutError;

  DialogMessage({required this.type, required this.message,this.hideTimeOutError = false});
}

class AppNotifier {
  static void showDialog(BuildContext context, DialogMessage dialog) {
    if (dialog.message == null) return;

    switch (dialog.type) {
      case DialogType.errorException:
        showExceptionError(context, dialog.message,hideTimeOut: dialog.hideTimeOutError);
        break;
      case DialogType.errorText:
        showError(context, dialog.message);
        break;
      case DialogType.successText:
        showSuccess(context, dialog.message);
        break;
      case DialogType.error:
        // TODO: Handle this case.
    }
  }
  static void showError(BuildContext context, String message) {
    if (!context.mounted) {
      return;
    }
    Flushbar(
      icon: const Icon(Icons.warning, color: Colors.white),
      backgroundColor: Colors.red.shade700,
      message: message,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(0),
      borderRadius: BorderRadius.circular(0),
    ).show(context);
  }
  static void showExceptionError(BuildContext context, dynamic e,{bool hideTimeOut=false}) {
    dynamic errorMessage=NetworkErrorHandler.getMessage(e,hideTimeOut: hideTimeOut);
    if(AppUtils.isNotNullOrEmpty(errorMessage)){
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.fixed, // full-width, bottom-aligned
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  errorMessage.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
      // Flushbar(
      //   icon: const Icon(Icons.warning, color: Colors.white),
      //   backgroundColor: Colors.red.shade700,
      //   message: NetworkErrorHandler.getMessage(e),
      //   duration: const Duration(seconds: 3),
      //   margin: const EdgeInsets.all(0),
      //   borderRadius: BorderRadius.circular(0),
      // ).show(context);
    }
  }
  static Future<void> showSuccess(BuildContext context, dynamic message) {
    if (!context.mounted) {
      return Future.value();
    }
    return Flushbar(
      icon: Icon(Icons.check_circle,color: Colors.white,),
      backgroundColor: AppColors.deepGreen,
      message: message,
      duration: Duration(seconds: 3),
    ).show(context);
  }
}