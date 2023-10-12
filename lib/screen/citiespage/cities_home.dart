import 'dart:async';

import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/screen/citiespage/cities.dart';
import 'package:ev_pmis_app/screen/citiespage/depot.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_appbar.dart';

class CitiesHome extends StatefulWidget {
  const CitiesHome({super.key});

  @override
  State<CitiesHome> createState() => _CitiesHomeState();
}

class _CitiesHomeState extends State<CitiesHome> {
  @override
  Widget build(BuildContext context) {
    print('Cities Home page');
    return Scaffold(
      drawer: const NavbarDrawer(),
      appBar: CustomAppBar(
        isCentered: true,
        title: 'Cities',
        height: 50,
        isSync: false,
        // haveupload: true,
      ),
      body: Row(
        children: [
          const CitiesPage(),
          DepotPage(),
        ],
      ),
    );
  }
}
