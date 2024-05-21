import 'package:ev_pmis_app/components/Loading_page.dart';
import 'package:flutter/material.dart';

void showProgressDilogue(BuildContext context) async {
  await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            child: Container(
          height: 100,
          width: 100,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: const LoadingPage(),
              )
            ],
          ),
        ));
      });
}
