import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/screen/qualitychecklist/electrical/electrical_table.dart';
import 'package:ev_pmis_app/screen/qualitychecklist/quality_checklist.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../widgets/activity_headings.dart';
import '../../../widgets/custom_textfield.dart';

class ElectricalField extends StatefulWidget {
  String? depoName;
  String? title;
  String? fielClnName;
  int? titleIndex;
  ElectricalField(
      {super.key,
      required this.depoName,
      required this.title,
      required this.fielClnName,
      required this.titleIndex});

  @override
  State<ElectricalField> createState() => _ElectricalFieldState();
}

class _ElectricalFieldState extends State<ElectricalField> {
  late TextEditingController nameController,
      docController,
      vendorController,
      dateController,
      olaController,
      panelController,
      depotController,
      customerController;

  void initializeController() {
    nameController = TextEditingController();
    docController = TextEditingController();
    vendorController = TextEditingController();
    dateController = TextEditingController();
    // dateController = TextEditingController();
    olaController = TextEditingController();
    panelController = TextEditingController();
    depotController = TextEditingController();
    customerController = TextEditingController();
  }

  @override
  void initState() {
    initializeController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavbarDrawer(),
      appBar: CustomAppBar(
          title: '${widget.depoName!}/${widget.title}',
          height: 50,
          isSync: true,
          store: () {
            FirebaseFirestore.instance
                .collection('ElectricalChecklistField')
                .doc('${widget.depoName}')
                .collection('userId')
                .doc(userId)
                .collection(widget.fielClnName!)
                .doc(currentDate)
                .set({
              'EmployeeName': nameController,
              'DocNo': docController,
              'VendorName': vendorController,
              'Date': dateController,
              'Ola No': olaController,
              'Panel No': panelController,
              'Depot Name': depotController,
              'Customer Name': customerController
            });
          },
          isCentered: false),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('CivilQualityChecklistCollection')
            .doc('${widget.depoName}')
            .collection('userId')
            .doc('widget.currentDate')
            .snapshots(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: [
                electricalField(nameController, 'Employee Name'),
                electricalField(docController, 'Dist EV'),
                electricalField(vendorController, 'Vendor Name'),
                electricalField(dateController, 'Date'),
                electricalField(olaController, 'Ola No'),
                electricalField(panelController, 'Panel No'),
                electricalField(depotController, 'Depot Name'),
                electricalField(customerController, 'Customer Name'),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ElectricalTable(
                  depoName: widget.depoName,
                  title: widget.title,
                  titleIndex: widget.titleIndex,
                ),
              ));
        },
        child: const Text('Next'),
      ),
    );
  }

  Widget electricalField(TextEditingController controller, String title) {
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
}
