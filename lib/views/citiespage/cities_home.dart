import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:ev_pmis_app/views/authentication/authservice.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/custom_appbar.dart';
import 'cities.dart';
import 'depot.dart';

class CitiesHome extends StatefulWidget {
  final String? userId;
  final String? role;
  final String? roleCentre;
  const CitiesHome({super.key, this.role, this.userId, this.roleCentre});

  @override
  State<CitiesHome> createState() => _CitiesHomeState();
}

class _CitiesHomeState extends State<CitiesHome> {
  String role = '';
  bool isLoading = true;
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    getUserRole().whenComplete(() async {
      sharedPreferences = await SharedPreferences.getInstance();
      role = sharedPreferences!.getString('role') ?? '';
      isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavbarDrawer(role: role),
      appBar: CustomAppBar(
        depoName: '',
        isCentered: true,
        title: 'Cities',
        height: 50,
        isSync: false,
        // haveupload: true,
      ),
      body: isLoading
          ? const LoadingPage()
          : Row(
              children: [
                CitiesPage(
                  role: role,
                ),
                DepotPage(
                  role: role,
                  userId: widget.userId,
                  roleCentre: widget.roleCentre,
                ),
              ],
            ),
    );
  }

  Future<void> getUserRole() async {
    final AuthService authService = AuthService();
    role = await authService.getUserRole();
  }
  
}
