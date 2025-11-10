import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

/// Centralized image help dialog utility
/// Provides consistent image help dialogs with requirements and example images
class ImageHelpDialog {
  /// Shows an image help dialog with requirements and example image
  static void show({
    required BuildContext context,
    required String title,
    required String description,
    required List<String> requirements,
    required String imagePath,
    String? exampleLabel,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description (only show if not empty)
                if (description.isNotEmpty) ...[
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Requirements section
                Text(
                  'requirements_title'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: requirements.map((req) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('• $req'),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Example section
                Text(
                  exampleLabel ?? 'example_title'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    width: 320,
                    height: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported, size: 72, color: Colors.grey.shade400),
                                const SizedBox(height: 8),
                                Text(
                                  'image_not_available'.tr(),
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('close_button'.tr()),
            ),
          ],
        );
      },
    );
  }

  /// Convenience methods for common image types
  static void showInternalMosqueHelp(BuildContext context) {
    showWithConfig(context: context, config: ImageHelpConfigs.internalMosque);
  }

  static void showExternalMosqueHelp(BuildContext context) {
    showWithConfig(context: context, config: ImageHelpConfigs.externalMosque);
  }

  static void showQrPanelHelp(BuildContext context) {
    showWithConfig(context: context, config: ImageHelpConfigs.qrPanel);
  }

  static void showMeterImageHelp(BuildContext context) {
    showWithConfig(context: context, config: ImageHelpConfigs.meterImage);
  }

  /// Helper widget for creating a help icon button
  static Widget helpIcon({
    required VoidCallback onTap,
    double size = 16,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.help_outline,
          size: size,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }

  /// Helper widget for creating a field title row with help icon and required asterisk
  static Widget fieldTitleRow({
    required String title,
    required VoidCallback onHelpTap,
    bool isRequired = false,
    TextStyle? titleStyle,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: titleStyle ?? const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        helpIcon(onTap: onHelpTap),
        if (isRequired) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  /// Generic show method with config object
  static void showWithConfig({
    required BuildContext context,
    required ImageHelpConfig config,
  }) {
    show(
      context: context,
      title: config.title,
      description: config.description,
      requirements: config.requirements,
      imagePath: config.imagePath,
      exampleLabel: config.exampleLabel,
    );
  }
}

/// Predefined configurations for common image types
class ImageHelpConfigs {
  /// Internal mosque image configuration
  static ImageHelpConfig internalMosque = ImageHelpConfig(
    title: 'internal_mosque_attachment_help_description'.tr(),
    description: '',
    requirements: [
      'internal_mosque_attachment_req_1'.tr(),
      'internal_mosque_attachment_req_2'.tr(),
      'internal_mosque_attachment_req_3'.tr(),
      'internal_mosque_attachment_req_4'.tr(),
    ],
    imagePath: 'assets/images/internal_mosque_image.jpeg',
  );

  /// External mosque image configuration
  static ImageHelpConfig externalMosque = ImageHelpConfig(
    title: 'external_mosque_attachment_help_description'.tr(),
    description: '',
    requirements: [
      'external_mosque_attachment_req_1'.tr(),
      'external_mosque_attachment_req_2'.tr(),
      'external_mosque_attachment_req_3'.tr(),
      'external_mosque_attachment_req_4'.tr(),
    ],
    imagePath: 'assets/images/external_mosque_image.jpeg',
  );

  /// QR panel image configuration
  static ImageHelpConfig qrPanel = ImageHelpConfig(
    title: 'qr_panel_attachment_help_description'.tr(),
    description: '',
    requirements: [
      'qr_panel_attachment_req_1'.tr(),
      'qr_panel_attachment_req_2'.tr(),
      'qr_panel_attachment_req_3'.tr(),
    ],
    imagePath: 'assets/images/QRPanelExample.jpeg',
  );

  /// Meter image configuration
  static ImageHelpConfig meterImage = ImageHelpConfig(
    title: 'meter_attachment_help_description'.tr(),
    description: '',
    requirements: [
      'meter_attachment_req_1'.tr(),
      'meter_attachment_req_2'.tr(),
      'meter_attachment_req_3'.tr(),
      'meter_attachment_req_4'.tr(),
      'meter_attachment_req_5'.tr(),
    ],
    imagePath: 'assets/images/ElectrictyMeterExample.jpeg',
  );
}

/// Configuration class for image help dialogs
class ImageHelpConfig {
  final String title;
  final String description;
  final List<String> requirements;
  final String imagePath;
  final String? exampleLabel;

  const ImageHelpConfig({
    required this.title,
    required this.description,
    required this.requirements,
    required this.imagePath,
    this.exampleLabel,
  });
}
