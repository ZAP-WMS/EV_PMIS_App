import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/svg.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/split_screen/background_logo.jpeg'),
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
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        'assets/app_logo.png',
                      )),
                  Text('EV Monitoring', style: splitscreenStyle),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Image.asset('assets/pmis.png'),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Image.asset('assets/o&m.png'),

            // Container(
            //   margin: const EdgeInsets.only(
            //     top: 50,
            //     bottom: 20,
            //   ),
            //   height: MediaQuery.of(context).size.height * 0.2,
            //   width: MediaQuery.of(context).size.width,
            //   child: Row(
            //     children: [
            //       SizedBox(
            //         height: 200,
            //         width: MediaQuery.of(context).size.width,
            //         child: InkWell(
            //           overlayColor:
            //               const MaterialStatePropertyAll(Colors.transparent),
            //           onTap: () {
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) => LoginRegister(),
            //                 ));
            //           },
            //           child: Stack(
            //             children: [
            //               Positioned(
            //                 top: 10,
            //                 child: Container(
            //                     margin: const EdgeInsets.only(top: 50),
            //                     decoration: BoxDecoration(
            //                         color: HexColor("#2651A1"),
            //                         borderRadius: BorderRadius.circular(10)),
            //                     alignment: Alignment.center,
            //                     height: 100,
            //                     width: MediaQuery.of(context).size.width * 0.55,
            //                     child: const Align(
            //                       alignment: Alignment.centerLeft,
            //                       child: Padding(
            //                         padding: EdgeInsets.only(left: 20),
            //                         child: Text(
            //                           'P M I S',
            //                           textAlign: TextAlign.start,
            //                           style: TextStyle(
            //                               color: Colors.white,
            //                               fontSize: 25,
            //                               letterSpacing: 0.0,
            //                               fontWeight: FontWeight.bold),
            //                         ),
            //                       ),
            //                     )),
            //               ),
            //               Positioned(
            //                 right: MediaQuery.of(context).size.width * 0.37,
            //                 child: HexagonWidget(
            //                   size: 20.0,
            //                   color: Colors.white,
            //                   borderColor: HexColor("#1C5177"),
            //                   borderWidth: 10.0,
            //                   imagePath: 'assets/image1.png',
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),

            // //Second Lable with Icon

            // Container(
            //   height: MediaQuery.of(context).size.height * 0.25,
            //   width: MediaQuery.of(context).size.width,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       InkWell(
            //         overlayColor:
            //             const MaterialStatePropertyAll(Colors.transparent),
            //         onTap: () {},
            //         child: SizedBox(
            //           height: 200,
            //           width: MediaQuery.of(context).size.width,
            //           child: Stack(
            //             alignment: Alignment.centerRight,
            //             children: [
            //               Positioned(
            //                 top: 100,
            //                 child: Container(
            //                   decoration: BoxDecoration(
            //                       color: HexColor("#5DAF17"),
            //                       borderRadius: BorderRadius.circular(10)),
            //                   margin: const EdgeInsets.only(right: 0),
            //                   alignment: Alignment.center,
            //                   height: 100,
            //                   width: MediaQuery.of(context).size.width * 0.55,
            //                   child: const Padding(
            //                     padding: EdgeInsets.only(left: 50, top: 10),
            //                     child: Text(
            //                       'O & M',
            //                       textAlign: TextAlign.start,
            //                       style: TextStyle(
            //                           color: Colors.white,
            //                           fontSize: 25,
            //                           letterSpacing: 0.0,
            //                           fontWeight: FontWeight.bold),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               Positioned(
            //                 left: MediaQuery.of(context).size.width * 0.37,
            //                 child: HexagonWidget(
            //                   size: 100.0,
            //                   color: Colors.white,
            //                   borderColor: HexColor("#448F1C"),
            //                   borderWidth: 1.0,
            //                   imagePath: 'assets/image2.png',
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    ));
  }
}

class HexagonWidget extends StatelessWidget {
  final double size;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final String imagePath;

  HexagonWidget(
      {required this.size,
      required this.color,
      required this.borderColor,
      required this.borderWidth,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        size: Size(size, size),
        painter: HexagonPainter(
          color: color,
          borderColor: borderColor,
          borderWidth: borderWidth,
        ),
        child: Image.asset(
          imagePath,
          scale: 4.0,
        ));
  }
}

class HexagonPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;

  HexagonPainter({
    required this.color,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double sideLength = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    const double angle = math.pi / 3;

    final path = Path();
    path.moveTo(centerX + sideLength * math.cos(0.0),
        centerY + sideLength * math.sin(0.0));

    for (int i = 1; i <= 6; i++) {
      path.lineTo(
        centerX + sideLength * math.cos(angle * i),
        centerY + sideLength * math.sin(angle * i),
      );
    }
    path.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
