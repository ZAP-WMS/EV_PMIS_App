import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class PdfController extends GetxController {
  // Reactive list to hold PDF URLs
  var pdfNames = <String>[].obs;
  var pdfUrls = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPdfUrls();
  }

  Future<void> fetchPdfUrls() async {
    try {
      // Reference to the 'Sop Checklist/' folder in Firebase Storage
      ListResult result =
          await FirebaseStorage.instance.ref('Sop Checklist/').listAll();

      // Clear existing list and add new files
      List<String> names = [];
      List<String> urls = [];
      for (var item in result.items) {
        String pdfUrl = await item.getDownloadURL();
        String encodedFileName = item.name;
        String decodedFileName = Uri.decodeComponent(encodedFileName);
        names.add(decodedFileName);
        urls.add(pdfUrl);
      }

      // Update the reactive list with the new URLs
      pdfNames.value = names;
      pdfUrls.value = urls;
    } catch (e) {
      print('Error fetching PDFs: $e');
    }
  }
}
