import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/provider/cities_provider.dart';
import 'package:ev_pmis_app/screen/citiespage/cities_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/Loading_page.dart';
import '../../style.dart';
import '../overviewpage/overview.dart';

class DepotPage extends StatefulWidget {
  String? role;
  String? cityName;
  DepotPage({super.key, this.cityName, this.role});

  @override
  State<DepotPage> createState() => _DepotPageState();
}

class _DepotPageState extends State<DepotPage> {
  Stream? _stream;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                    return LoadingPage();
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.81,
                    child: GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      padding: const EdgeInsets.only(bottom: 10),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.9,
                              mainAxisSpacing: 5,
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OverviewPage(
                                  role: widget.role,
                                  depoName: snapshot.data!.docs[index]
                                      ['DepoName'],
                                ),
                              )),
                          child: depolist(
                            snapshot.data!.docs[index]['DepoUrl'],
                            snapshot.data!.docs[index]['DepoName'],
                          ),
                        );
                      },
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  Widget depolist(String image, String text) {
    return Column(children: [
      Container(
          padding: const EdgeInsets.all(25),
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(color: grey),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: NetworkImage(image), fit: BoxFit.fill))),
      Text(
        text,
        softWrap: true,
        textAlign: TextAlign.center,
        style:
            TextStyle(color: blue, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    ]);
  }
}
