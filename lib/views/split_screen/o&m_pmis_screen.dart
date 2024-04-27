import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';

class PmisAndOAndMScreen extends StatelessWidget {
  final String roleCentre;
  final String role;
  final String userId;

  const PmisAndOAndMScreen(
      {required this.role,
      required this.userId,
      required this.roleCentre,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/split_screen/paper.jpeg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 200,
              alignment: Alignment.center,
              //  decoration: BoxDecoration(color: splitscreenColor),
              child: Column(
                children: [
                  Container(
                    height: 130,
                    width: 130,
                    child: Image.asset(
                      'assets/app_logo.png',
                    ),
                  ),
                  Text(
                    'EV Monitoring',
                    style: splitscreenStyle,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            roleCentre == "PMIS"
                ? InkWell(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/splitDashboard',
                          arguments: {
                            "roleCentre": roleCentre,
                            'userId': userId,
                            "role": role
                          },
                          (route) => false);
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/split_screen/pmis.png',
                        height: 150,
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/split_screen/pmis_diable.png',
                    ),
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            roleCentre == "PMIS"
                ? InkWell(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/cities-page',
                          arguments: {
                            // "roleCentre": roleCentre,
                            'userId': userId,
                            "role": role
                          },
                          (route) => false);
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        'assets/split_screen/o&m.png',
                        height: 150,
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      'assets/split_screen/oAndM_disable.png',
                      height: 150,
                    ),
                  ),
          ],
        ),
      ),
    ));
  }
}
