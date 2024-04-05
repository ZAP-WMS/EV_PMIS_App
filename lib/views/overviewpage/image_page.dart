import 'package:ev_pmis_app/components/loading_pdf.dart';
import 'package:ev_pmis_app/views/overviewpage/viewFIle.dart';
import 'package:ev_pmis_app/views/overviewpage/view_excel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import '../../FirebaseApi/firebase_api.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../style.dart';

class ImagePage extends StatelessWidget {
  final FirebaseFile file;
  final String role;
  final bool isFieldEditable;
  final bool isOverview;

  const ImagePage(
      {Key? key,
      required this.file,
      required this.role,
      required this.isFieldEditable,
      this.isOverview = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = ['.jpeg', '.jpg', '.png'].any(file.name.contains);
    final isPdf = ['.pdf'].any(file.name.contains);
    final isVideo = ['.mp4'].any((file.name.contains));
    // Assuming file is a VideoFile object containing the video URL
    ChewieController? _chewieController;
    if (isVideo) {
      VideoPlayerController _videoPlayerController =
          // ignore: deprecated_member_use
          VideoPlayerController.network(file.url);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            file.name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          backgroundColor: blue,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () async {
                final pr = ProgressDialog(context);

                pr.style(
                    progressWidgetAlignment: Alignment.center,
                    message: 'Downloading file...',
                    borderRadius: 10.0,
                    backgroundColor: Colors.white,
                    progressWidget: const LoadingPdf(),
                    elevation: 10.0,
                    insetAnimCurve: Curves.easeInOut,
                    maxProgress: 100.0,
                    progressTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400),
                    messageTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600));

                pr.show();

                await FirebaseApi.downloadFile(file.ref).whenComplete(() {
                  pr.hide();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actionsAlignment: MainAxisAlignment.center,
                          actionsPadding:
                              const EdgeInsets.only(top: 20, bottom: 20),
                          actions: [
                            const Image(
                              image: AssetImage('assets/downloaded_logo.png'),
                              height: 40,
                              width: 40,
                            ),
                            Text(
                              'File Downloaded',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.blue[900]!),
                            )
                          ],
                        );
                      });
                });
              },
            ),
            (role == "projectManager" && isFieldEditable && isOverview)
                ? IconButton(
                    onPressed: () async {
                      await FirebaseStorage.instance
                          .refFromURL(file.url)
                          .delete()
                          .then((value) {
                        print('Delete Successfull');
                        Navigator.pop(context);
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                    ),
                  )
                : (role == "user" && isFieldEditable && !isOverview)
                    ? IconButton(
                        onPressed: () async {
                          await FirebaseStorage.instance
                              .refFromURL(file.url)
                              .delete()
                              .then((value) {
                            print('Delete Successfull');
                            Navigator.pop(context);
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                        ),
                      )
                    : Container()
          ],
        ),
        body: isImage
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    child: PhotoView(
                      backgroundDecoration:
                          const BoxDecoration(color: Colors.white),
                      imageProvider: NetworkImage(file.url),
                    ),
                  )
                ],
              )
            : isPdf
                ? ViewFile(path: file.url)
                : isVideo
                    ? Chewie(controller: _chewieController!)
                    : ViewExcel(
                        path: file.ref,
                      )
        //  const Center(
        //     child: Text(
        //       'Cannot be displayed',
        //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //     ),
        //   ),
        );
  }
}
