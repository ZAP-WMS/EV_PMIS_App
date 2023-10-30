import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/provider/cities_provider.dart';
import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CitiesPage extends StatefulWidget {
  const CitiesPage({super.key});

  @override
  State<CitiesPage> createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {
  Stream? _stream;
  bool isloading = true;
  List<bool> isActive = [true];
  @override
  void initState() {
    getCityBoolLen().whenComplete(() {
      _stream = FirebaseFirestore.instance
          .collection('CityName')
          .orderBy('CityName')
          .snapshots();

      isloading = false;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? const CircularProgressIndicator()
        : Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: grey),
                color: white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.elliptical(40, 40),
                ),
              ),
              child: StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // getCityBoolLen();
                          for (int i = 0; i < snapshot.data!.docs.length; i++) {
                            if (isActive[i] == true) {
                              isActive.insert(i, false);
                            }
                          }

                          Provider.of<CitiesProvider>(context, listen: false)
                              .saveCities(
                                  snapshot.data!.docs[index]['CityName']);
                          isActive.insert(index, true);
                          setState(() {});
                        },
                        child: citieslist(
                            snapshot.data!.docs[index]['ImageUrl'],
                            snapshot.data!.docs[index]['CityName'],
                            isActive[index]),
                      );
                    },
                  );
                },
              ),
            ),
          );
  }

  Future<void> getCityBoolLen() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('CityName').get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < tempList.length; i++) {
      // tempBool.add(false);
      isActive.add(false);
    }
  }

  Widget citieslist(String image, String text, bool active) {
    return Column(
      children: [
        Card(
            color: white,
            elevation: 5,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.elliptical(100, 100))),
            child: Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(image),
                        //  NetworkImage(image),
                        fit: BoxFit.fill)))),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: active ? blue : white,
          ),
          child: Text(text,
              textAlign: TextAlign.center,
              selectionColor: white,
              style: active
                  ? TextStyle(
                      color: white, fontWeight: FontWeight.bold, fontSize: 12)
                  : TextStyle(
                      color: blue, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ],
    );
  }
}
