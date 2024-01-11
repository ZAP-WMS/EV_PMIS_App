import 'package:ev_pmis_app/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class SplitScreen extends StatelessWidget {
  const SplitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        centerTitle: true,
        title: const Text('Dashboard',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        height: context.height * 0.8,
        child: Column(
          children: [
            Expanded(
                child: Container(
              margin: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/evDashboard');
                    },
                    child: Card(
                      elevation: 10,
                      child: Container(
                        height: context.height * 0.3,
                        width: context.width * 0.9,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/ev_dashboard.jpeg'),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: context.width * 0.9,
                    height: 40,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(blue)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/evDashboard');
                        },
                        child: const Text(
                          'EV Bus Project Analysis Dashboard',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            )),
            Divider(
              color: blue,
              thickness: 2,
            ),
            Expanded(
                child: Container(
              margin: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/demand');
                    },
                    child: Card(
                      elevation: 10,
                      child: Container(
                        height: context.height * 0.3,
                        width: context.width * 0.9,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/demand_energy.jpeg'),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: context.width * 0.9,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(blue)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/demand');
                        },
                        child: const Text(
                          'EV Bus Depot Management System',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            )),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(blue)),
          onPressed: () {
            Navigator.pushNamed(context, '/cities-page');
          },
          child: const Text(
            'Proceed to cities',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )),
    );
  }
}
