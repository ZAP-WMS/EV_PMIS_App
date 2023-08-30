import 'package:ev_pmis_app/screen/citiespage/cities_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screen/homepage/gallery.dart';
import '../style.dart';

class NavbarDrawer extends StatefulWidget {
  const NavbarDrawer({super.key});

  @override
  State<NavbarDrawer> createState() => _NavbarDrawerState();
}

class _NavbarDrawerState extends State<NavbarDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: blue),
            currentAccountPicture: const Icon(
              Icons.face,
              size: 48.0,
              color: Colors.white,
            ),
            // otherAccountsPictures: const [
            //   Icon(
            //     Icons.bookmark_border,
            //     color: Colors.white,
            //   ),
            // ],
            accountName: Text(userId!),
            accountEmail: const Text('test@gmail.com'),
          ),
          ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                  // DeviceOrientation.landscapeLeft,
                ]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CitiesHome(),
                  ),
                );
              }),
          ListTile(
              leading: const Icon(Icons.mood),
              title: const Text('Mood'),
              onTap: () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                  // DeviceOrientation.landscapeLeft,
                ]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CitiesHome(),
                  ),
                );
              }),
          ListTile(
              leading: const Icon(Icons.note_add),
              title: const Text('Note'),
              onTap: () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                  // DeviceOrientation.landscapeLeft,
                ]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CitiesHome(),
                  ),
                );
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                  // DeviceOrientation.landscapeLeft,
                ]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CitiesHome(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
