import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatelessWidget {
  String? url;
  Object tag;
  ImageView({super.key, required this.tag, this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File View'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: PhotoView(
              backgroundDecoration: const BoxDecoration(color: Colors.white),
              imageProvider: NetworkImage(url!),
            ),
          )
        ],
      ),
    );
  }
}
