import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/provider/cities_provider.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../style.dart';

String userId = '';

class DepotPage extends StatefulWidget {
  String? role;
  String? cityName;
  DepotPage({
    super.key,
    this.cityName,
    this.role,
  });

  @override
  State<DepotPage> createState() => _DepotPageState();
}

class _DepotPageState extends State<DepotPage> {
  Stream? _stream;

  @override
  void initState() {
    getUserId();
    // TODO: implement initState
    super.initState();
    print('depotPage - UserId- ${userId}');
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<CitiesProvider>(
        builder: (context, value, child) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('DepoName')
                  .doc(value.getName)
                  .collection('AllDepots')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1.2,
                                mainAxisSpacing: 3,
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, '/overview page',
                                arguments: {
                                  'depoName': snapshot.data!.docs[index]
                                      ['DepoName'],
                                  'role': widget.role,
                                  'userId': userId
                                }),
                            // onTap: () => Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => OverviewPage(
                            //         role: widget.role,
                            //         depoName: snapshot.data!.docs[index]
                            //             ['DepoName'],
                            //       ),
                            //     )),
                            child: depolist(
                              snapshot.data!.docs[index]['DepoUrl'],
                              snapshot.data!.docs[index]['DepoName'],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
      print('UserId - $value');
      // setState(() {});
    });
  }

  Widget depolist(String image, String text) {
    return Column(children: [
      Container(
          padding: const EdgeInsets.all(20),
          width: 90,
          height: 90,
          decoration: BoxDecoration(
              border: Border.all(color: grey),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    image,
                  ),
                  //  NetworkImage(image),
                  fit: BoxFit.cover))),
      Expanded(
        child: Text(
          text,
          softWrap: true,
          textAlign: TextAlign.center,
          style:
              TextStyle(color: blue, fontWeight: FontWeight.bold, fontSize: 11),
        ),
      ),
    ]);
  }
}
