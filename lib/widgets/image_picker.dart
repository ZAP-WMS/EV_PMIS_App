import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import '../views/controller/image_picker_controller.dart';

final picker = ImagePicker();
final ImagePickerController imagePickerController =
    Get.put(ImagePickerController());

Future<void> pickImageFromGallery() async {
  final pickedFile = await FilePicker.platform
      .pickFiles(withData: true, type: FileType.any, allowMultiple: true);

  // imagePickerController.setPickedImagePath(pickedFile!.files.first.name);

  if (pickedFile != null) {
    // Handle the picked image file
    for (var file in pickedFile.files) {
      // Set the picked image path for each file
      imagePickerController.setPickedImagePath(file.path!);
    }
    // print('Image picked from gallery: ${pickedFile.path}');
  } else {
    print('No image selected.');
  }
}

Future<void> pickImageFromCamera() async {
  final pickedFile = await picker.pickImage(
    source: ImageSource.camera,
  );
  if (pickedFile != null) {
    // Handle the picked image file
    imagePickerController.setPickedImagePath(pickedFile.path);
    print('Image picked from camera: ${pickedFile.path}');
  } else {
    print('No image captured.');
  }
}
