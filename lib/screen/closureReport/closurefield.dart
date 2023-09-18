import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/screen/safetyreport/safetyfield.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';

import '../../style.dart';
import '../../widgets/activity_headings.dart';
import '../../widgets/custom_textfield.dart';
import '../homepage/gallery.dart';

class ClosureField extends StatefulWidget {
  String? depoName;
  ClosureField({super.key, required this.depoName});

  @override
  State<ClosureField> createState() => _ClosureFieldState();
}

class _ClosureFieldState extends State<ClosureField> {
  late TextEditingController depotController,
      longitudeController,
      latitudeController,
      stateController,
      busesController,
      loaController;

  void initializeController() {
    depotController = TextEditingController();
    longitudeController = TextEditingController();
    latitudeController = TextEditingController();
    stateController = TextEditingController();
    busesController = TextEditingController();
    loaController = TextEditingController();
  }

  @override
  void initState() {
    _fetchUserData();
    initializeController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavbarDrawer(),
        appBar: CustomAppBar(
          title: 'Closure Report/${widget.depoName}',
          height: 50,
          isSync: true,
          isCentered: false,
          store: () {
            FirebaseFirestore.instance
                .collection('ClosureReport')
                .doc('${widget.depoName}')
                .collection("ClosureData")
                .doc(userId)
                .set(
              {
                'DepotName': depotController.text,
                'Longitude': loaController.text,
                'Latitude': latitudeController.text,
                'State': stateController.text,
                'Buses': busesController.text,
                'LaoNo': loaController.text,
              },
            ).whenComplete(() {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Data are synced'),
                backgroundColor: blue,
              ));
            });
          },
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('ClosureReport')
              .doc('${widget.depoName}')
              .collection('ClosureData')
              .doc(currentDate)
              .snapshots(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  closureField(depotController, 'Depot Name'),
                  closureField(longitudeController, 'Longitude'),
                  closureField(latitudeController, 'Latitude'),
                  closureField(stateController, 'State'),
                  closureField(busesController, 'No. of Buses'),
                  closureField(loaController, 'LOA No.'),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/closure-table',
                arguments: widget.depoName);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => CivilTable(
            //         depoName: widget.depoName,
            //         title: widget.title,
            //         titleIndex: widget.index,
            //       ),
            //     ));
          },
          child: const Text('Next'),
        ));
  }

  Widget closureField(TextEditingController controller, String title) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: CustomTextField(
          controller: controller,
          labeltext: title,
          validatortext: '$title is Required',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next),
    );
  }

  void _fetchUserData() async {
    await FirebaseFirestore.instance
        .collection('ClosureReport')
        .doc(widget.depoName)
        .collection("ClosureData")
        .doc(userId)
        .get()
        .then((ds) {
      setState(() {
        // managername = ds.data()!['ManagerName'];
        depotController.text = ds.data()!['DepotName'];
        longitudeController.text = ds.data()!['Longitude'];
        latitudeController.text = ds.data()!['Latitude'];
        stateController.text = ds.data()!['State'];
        busesController.text = ds.data()!['Buses'];
        loaController.text = ds.data()!['LaoNo'];
      });
    });
  }
}
