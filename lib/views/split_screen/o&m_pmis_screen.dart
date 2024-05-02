import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/views/authentication/login_register.dart';
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginRegister(),
                    )),
                child: Image.asset('assets/o&m.png')),
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
