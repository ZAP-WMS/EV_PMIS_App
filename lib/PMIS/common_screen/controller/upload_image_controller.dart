import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/image_picker.dart';

void showPickerOptions(String pageTitle) {
  Get.defaultDialog(
    title: "Select Image",
    content: Column(
      children: [
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text("Pick from Gallery"),
          onTap: () {
            Get.back();
            pickImageFromGallery(pageTitle);
          },
        ),
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text("Capture from Camera"),
          onTap: () {
            Get.back();
            pickImageFromCamera();
          },
        ),
      ],
    ),
  );
}
