import 'package:ev_pmis_app/model/menu_item.dart';
import 'package:ev_pmis_app/screen/citiespage/cities_home.dart';
import 'package:ev_pmis_app/screen/homepage/gallery.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

BuildContext? testContext;

class HomePage extends StatefulWidget {
  String? role;
  HomePage({super.key, this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> menuwidget = [
    CitiesHome(),
    GalleryPage(),
    GalleryPage(),
    // OverviewPage(),
  ];

  final menuItemlist = <MenuItem>[
    MenuItem(Icons.home, 'Home'),
    MenuItem(Icons.person, 'Person'),
    MenuItem(Icons.settings, 'Setting'),
  ];
  PersistentTabController? _controller;
  bool? _hideNavBar;
  @override
  void initState() {
    print('HomePage - ${widget.role}');
    _controller = PersistentTabController();
    _hideNavBar = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // List<PersistentBottomNavBarItem> _navBarsItems() => [
    //       PersistentBottomNavBarItem(
    //         icon: const Icon(Icons.home),
    //         title: "Home",
    //         activeColorPrimary: Colors.blue,
    //         inactiveColorPrimary: Colors.grey,
    //         inactiveColorSecondary: Colors.purple,
    //         routeAndNavigatorSettings: RouteAndNavigatorSettings(
    //           initialRoute: "/",
    //           routes: {
    //             "/first": (final context) => const HomePage(),
    //             "/second": (final context) => const CitiesHome(),
    //             "/depotOverview": (final context) => const DepotOverview()
    //           },
    //         ),
    //       ),
    //       PersistentBottomNavBarItem(
    //         icon: const Icon(Icons.search),
    //         title: "Search",
    //         activeColorPrimary: Colors.teal,
    //         inactiveColorPrimary: Colors.grey,
    //         routeAndNavigatorSettings: RouteAndNavigatorSettings(
    //           initialRoute: "/",
    //           routes: {
    //             "/first": (final context) => const HomePage(),
    //             "/second": (final context) => const CitiesHome()
    //           },
    //         ),
    //       ),
    //       PersistentBottomNavBarItem(
    //         icon: const Icon(Icons.add),
    //         title: "Add",
    //         activeColorPrimary: Colors.blueAccent,
    //         inactiveColorPrimary: Colors.grey,
    //         routeAndNavigatorSettings: RouteAndNavigatorSettings(
    //           initialRoute: "/",
    //           routes: {
    //             "/first": (final context) => const HomePage(),
    //             "/second": (final context) => const HomePage()
    //           },
    //         ),
    //       ),
    //     ];

    // bool _hideNavBar = false;
    return Scaffold(
      body: CitiesHome(role: widget.role),
    );
  }
}

 
      // ),