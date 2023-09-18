import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_pmis_app/screen/homepage/gallery.dart';
import 'package:ev_pmis_app/screen/qualitychecklist/civil/civil_table.dart';
import 'package:ev_pmis_app/widgets/activity_headings.dart';
import 'package:ev_pmis_app/widgets/custom_appbar.dart';
import 'package:ev_pmis_app/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../widgets/custom_textfield.dart';

class CivilField extends StatefulWidget {
  String? depoName;
  String? title;
  int? index;
  String fieldclnName;
  bool isloading = true;
  String? currentDate;

  CivilField(
      {super.key,
      required this.depoName,
      required this.title,
      required this.fieldclnName,
      required this.index});

  @override
  State<CivilField> createState() => _CivilFieldState();
}

class _CivilFieldState extends State<CivilField> {
  late TextEditingController projectController,
      locationController,
      vendorController,
      drawingController,
      dateController,
      componentController,
      gridController,
      fillingController;
  void initializeController() {
    projectController = TextEditingController();
    locationController = TextEditingController();
    vendorController = TextEditingController();
    drawingController = TextEditingController();
    dateController = TextEditingController();
    componentController = TextEditingController();
    gridController = TextEditingController();
    fillingController = TextEditingController();
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
                .collection('QualityChecklistCollection')
                .doc('${widget.depoName}')
                .collection('userId')
                .doc(userId)
                .collection(widget.fieldclnName)
                .doc(currentDate)
                .set({
              'ProjectName': projectController,
              'Location': locationController,
              'VendorName': vendorController,
              'Drawing No': drawingController,
              'Date': dateController,
              'Component': componentController,
              'Grid': gridController,
              'Filling': fillingController
            });
          },
          isCentered: false),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('CivilQualityChecklistCollection')
            .doc('${widget.depoName}')
            .collection('userId')
            .doc(currentDate)
            .snapshots(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: [
                safetyField(projectController, 'Project Name'),
                safetyField(locationController, 'Location'),
                safetyField(vendorController, 'Vendor / SubVendor'),
                safetyField(drawingController, 'Drawing No.'),
                safetyField(dateController, 'Date'),
                safetyField(componentController, 'Component of the Structure'),
                safetyField(gridController, 'Grid / Axis Level'),
                safetyField(fillingController, 'Type of Filling'),
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
                builder: (context) => CivilTable(
                  depoName: widget.depoName,
                  title: widget.title,
                  titleIndex: widget.index,
                ),
              ));
        },
        child: const Text('Next'),
      ),
    );
  }

  Widget safetyField(TextEditingController controller, String title) {
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
