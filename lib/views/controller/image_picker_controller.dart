import 'package:get/get.dart';

class ImagePickerController extends GetxController {
  ///TOBE REMOVED

// RxList<String> pickedImagePaths = <String>[].obs;
  RxList<String> pickedImagePath = <String>[].obs;

  void setPickedImagePath(String path) {
    //  pickedImagePath.value = path;
    pickedImagePath.add(path);
  }
}
