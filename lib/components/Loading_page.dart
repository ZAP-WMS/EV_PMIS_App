import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: blue,
        )
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Image.asset('animations/loading_animation.gif'),
        //     const SizedBox(height: 10),
        //     const Text(
        //       'Loading...',
        //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //     )
        //   ],
        // )
        // Lottie.asset('animations/loading.json'),
        );
  }
}
