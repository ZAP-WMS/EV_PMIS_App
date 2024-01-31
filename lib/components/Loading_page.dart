import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 70,
                width: 70,
                child: Image.asset(
                  'animations/loading_animation.gif',
                )),
            const Text(
              'Loading...',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )
          ],
        )
        // Lottie.asset('animations/loading.json'),

        );
  }
}
