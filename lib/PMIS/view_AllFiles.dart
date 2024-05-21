import 'package:ev_pmis_app/style.dart';
import 'package:ev_pmis_app/PMIS/authentication/authservice.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../FirebaseApi/firebase_api.dart';
import '../components/Loading_page.dart';
import 'widgets/custom_appbar.dart';
import 'common_screen/overviewpage/image_page.dart';

class ViewAllPdf extends StatefulWidget {
  String? title;
  bool isOverview;
  String? subtitle;
  String? cityName;
  String? depoName;
  dynamic userId;
  String? fldrName;
  String? date;
  int? srNo;
  dynamic docId;
  String? role;
  ViewAllPdf(
      {super.key,
      required this.title,
      this.subtitle,
      required this.cityName,
      required this.depoName,
      required this.userId,
      this.fldrName,
      this.date,
      this.srNo,
      this.docId,
      this.role,
      this.isOverview = false});

  @override
  State<ViewAllPdf> createState() => _ViewAllPdfState();
}

class _ViewAllPdfState extends State<ViewAllPdf> {
  final AuthService authService = AuthService();
  List<String> assignedDepots = [];
  bool isFieldEditable = false;
  String role = '';
  Future<List<FirebaseFile>>? futureFiles;
  List<String> pdfFiles = [];
  bool _isload = true;
  List<dynamic> drawingRef = [];
  List<dynamic> drawingId = [];
  List<dynamic> drawingfullpath = [];

  @override
  void initState() {
    getCurrentUserRole();
    getAssignedDepots();

    futureFiles = FirebaseApi.listAll(
        '${widget.title}/${widget.cityName}/${widget.depoName}/null/${widget.docId}');
    if ((widget.title == 'DetailedEngRFC' ||
            widget.title == 'DetailedEngEV' ||
            widget.title == 'DetailedEngShed') &&
        (widget.role == 'admin' || widget.role == 'projectManager')) {
      getrefdata().whenComplete(() {
        for (int i = 0; i < drawingRef.length; i++) {
          for (int j = 0; j < drawingfullpath.length; j++) {
            if (drawingfullpath[j] ==
                '${widget.title}/${widget.cityName}/${widget.depoName}/${drawingRef[i]}/${widget.docId}') {
              futureFiles = FirebaseApi.listAll(drawingfullpath[j]);
            }
          }
        }
      }).whenComplete(() {
        _isload = false;
        setState(() {});
      });
    } else if (widget.title == 'DetailedEngRFC' ||
        widget.title == 'DetailedEngEV' ||
        widget.title == 'DetailedEngShed' && widget.role == 'user') {
      futureFiles = FirebaseApi.listAll(
              '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.docId}')
          .whenComplete(() {
        _isload = false;
        setState(() {});
      });
    } else if (widget.title == 'jmr') {
      futureFiles = FirebaseApi.listAll(widget.fldrName!);
      _isload = false;
      setState(() {});
    } else {
      futureFiles = widget.title == 'QualityChecklist'
          ? FirebaseApi.listAll(
              '${widget.title}/${widget.subtitle}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.fldrName}/${widget.date}/${widget.srNo}')
          : widget.title == 'ClosureReport'
              ? FirebaseApi.listAll(
                  '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.docId}')
              : widget.title == 'Overview Page'
                  ? FirebaseApi.listAll(
                      '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.userId}')
                  : widget.title == 'Key Events'
                      ? FirebaseApi.listAll(
                          '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.docId}')
                      : widget.title == '/BOQSurvey' ||
                              widget.title == '/BOQElectrical' ||
                              widget.title == '/BOQCivil'
                          ? FirebaseApi.listAll(
                              '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.docId}')
                          : widget.title == 'Depot Insights'
                              ? FirebaseApi.listAll(
                                  '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.docId}')
                              : FirebaseApi.listAll(
                                  '${widget.title}/${widget.cityName}/${widget.depoName}/${widget.userId}/${widget.date}/${widget.docId}');
      _isload = false;
      setState(() {});
    }
    super.initState();
  }

// /DetailedEngRFC/Bengaluru/BMTC KR Puram-29/ ZW3210
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          depoName: widget.depoName ?? '',
          title: 'File List',
          height: 50,
          isSync: false,
          isCentered: true,
        ),
      ),
      body: _isload
          ? const LoadingPage()
          : FutureBuilder<List<FirebaseFile>>(
              future: futureFiles,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const LoadingPage();
                  default:
                    if (snapshot.hasError) {
                      return const Center(child: Text('Some error occurred!'));
                    } else {
                      final files = snapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildHeader(files.length),
                          const SizedBox(height: 12),
                          Expanded(
                              child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemCount: files.length,
                            itemBuilder: (context, index) {
                              final file = files[index];
                              return buildFile(
                                  context, file, role, widget.isOverview);
                            },
                          )),
                        ],
                      );
                    }
                }
              },
            ),
    );
  }

  Future getrefdata() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('${widget.title}/${widget.cityName}/${widget.depoName}');
    final listResult = await storageRef.listAll();
    print(listResult.prefixes[0]);
    for (var prefix in listResult.prefixes) {
      drawingRef.add(prefix.name);
      print(drawingRef);

      final storageRef1 = FirebaseStorage.instance.ref().child(
          '${widget.title}/${widget.cityName}/${widget.depoName}/${prefix.name}');
      final listResult1 = await storageRef1.listAll();

      for (var prefix in listResult1.prefixes) {
        drawingId.add(prefix.fullPath);

        final storageRef2 =
            FirebaseStorage.instance.ref().child('${prefix.fullPath}');
        final listResult2 = await storageRef2.listAll();
        for (var prefix in listResult2.prefixes) {
          drawingfullpath.add('${storageRef2.fullPath}/${prefix.name}');

          print(drawingfullpath[0]);
        }
      }
    }
  }

  Widget buildFile(
      BuildContext context, FirebaseFile file, String role, bool isOverview) {
    final isImage = ['.jpeg', '.jpg', '.png'].any(file.name.contains);
    final isPdf = ['.pdf'].any(file.name.contains);
    final isexcel = ['.xlsx'].any(file.name.contains);
    final isVideo = ['.mp4'].any(file.name.contains);
    return Column(
      children: [
        InkWell(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            height: 120,
            width: 120,
            child: isImage
                ? Image.network(
                    file.url,
                    fit: BoxFit.fill,
                  )
                : isVideo
                    ? Image.asset(
                        'assets/video_image.jpg',
                      )
                    : Image.asset(
                        'assets/pdf_logo.png',
                      ),
          ),
          //PdfThumbnail.fromFile(file.ref.fullPath, currentPage: 2)),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ImagePage(
                isOverview: isOverview,
                isFieldEditable: isFieldEditable,
                file: file,
                role: role,
              ),
            ),
          ),
        ),
        Expanded(
            child: Text(
          file.name,
          textAlign: TextAlign.center,
          style: appTextStyle,
        ))
      ],
    );
  }

  Widget buildHeader(int length) => ListTile(
        tileColor: Colors.blue,
        leading: const SizedBox(
          width: 52,
          height: 52,
          child: Icon(
            Icons.file_copy,
            color: Colors.white,
          ),
        ),
        title: Text(
          '$length Files',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );

  getCurrentUserRole() async {
    role = await authService.getUserRole();
  }

  Future getAssignedDepots() async {
    assignedDepots = await authService.getDepotList();
    isFieldEditable =
        authService.verifyAssignedDepot(widget.depoName!, assignedDepots);
  }
}
