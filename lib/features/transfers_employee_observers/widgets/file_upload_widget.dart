import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FileUploadWidget extends StatelessWidget {
  final String title;
  final String? selectedFile;
  final Function(String?) onFileSelected;

  const FileUploadWidget({
    super.key,
    required this.title,
    required this.selectedFile,
    required this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        
        // Upload Button
        GestureDetector(
          onTap: () => _showFilePicker(context),
          child: Container(
            width: 100,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF8B4513), // Brown color like the Yes/No buttons
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.upload_file,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "upload_file".tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Selected file name (if any)
        if (selectedFile != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.attach_file,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedFile!,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => onFileSelected(null),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _showFilePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: Text("file_from_device".tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickFile(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text("gallery".tr()),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickFile(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickMedia();
      
      if (file != null) {
        // Get file name from path
        String fileName = file.path.split('/').last;
        onFileSelected(fileName);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("error_uploading_file".tr()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      
      if (image != null) {
        // Get file name from path
        String fileName = image.path.split('/').last;
        onFileSelected(fileName);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("error_uploading_file".tr()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
