import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../../authentication/authservice.dart';

String? userId;

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 2;
    List imglist = [
      'assets/gallery/Picture1.png',
      'assets/gallery/Picture2.png',
      'assets/gallery/Picture3.png',
      'assets/gallery/Picture4.png',
      'assets/gallery/Picture5.png',
      'assets/gallery/Picture1.png',
      'assets/gallery/Picture2.png',
    ];
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Gallery',
        height: 55,
        isSync: false,
      ),
      body: Stack(
        children: [
          GridView.count(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.89,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: List.generate(imglist.length, (index) {
              return Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Card(
                    elevation: 25,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    shadowColor: blue,
                    child: Image.asset(
                      imglist[index],
                      fit: BoxFit.fill,
                    ),
                  )
                  //  Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(50),
                  //   ),
                  //   height: 140,
                  //   width: 140,
                  //   child: Image.asset(
                  //     imglist[index],
                  //     fit: BoxFit.fill,
                  //   ),
                  // ),
                  );
            }),
          ),
          Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  height: 48,
                  width: MediaQuery.of(context).size.width - 20,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        // minimumSize: MediaQuery.of(context).size,
                        backgroundColor: blue,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/homepage');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Procceed',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: white,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(
                            Icons.forward,
                            size: 35,
                          )
                        ],
                      )),
                ),
              ))
        ],
      ),
    );
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
      setState(() {});
    });
  }
}
