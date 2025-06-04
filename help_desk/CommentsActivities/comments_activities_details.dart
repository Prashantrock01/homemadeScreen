import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
// import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Model/HelpDesk/comments/messge_listing_model.dart';
import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../CustomWidgets/playVideo.dart';
import '../../../CustomWidgets/preview_pdf.dart';
// import '../../../CustomWidgets/video_player.dart';
import '../../../Network/dio_service_client.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/debugger.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:get/get.dart';


class CommentsActivityDetailsScreen extends StatefulWidget {

  final String recordID;
  final Function onChange;

  const CommentsActivityDetailsScreen( {super.key, required this.recordID, required this.onChange});

  @override
  State<CommentsActivityDetailsScreen> createState() => _CommentsActivityDetailsScreenState();
}

class _CommentsActivityDetailsScreenState extends State<CommentsActivityDetailsScreen> {

  // String recordID;
  //_CommentsActivityDetailsScreenState();

  final _formKey = GlobalKey<FormState>();

  List listOfFile = [];
  List<File?> imageFile=[];
  int count=0;
  var albumName = "/storage/emulated/0/Download/InfraEye Downloads";

  final displayCommentController = TextEditingController();

  XFile? pickedFile;

  previewVideo(String url, String name) async{

    final response = await http.get(Uri.parse(url));

    final documentDirectory = await getApplicationDocumentsDirectory();

    File videoFile = File('${documentDirectory.path}/ $name');

    videoFile.writeAsBytesSync(response.bodyBytes);

    Get.to(() => PlayVideo(videoFile));
  }

   showImagePreviewAlert(BuildContext context, String imageName, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     const Text(''),
                      // const Spacer(),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                           downloadImage(url, imageName);
                          },
                          style: ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width/5, 0 )),),
                          child: const Text("Download", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close)),
                    ],
                  ),
                const SizedBox(height: 20,),
                InteractiveViewer(
                  child: Image.network(url.toString().replaceAll("https", "http"),
                    width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7,
                                 // fit: BoxFit.fitWidth,
                  //  height: MediaQuery.of(context).size.height * 0.8
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void downloadImage(String imageUrl, String imageName) async{
    String path = '';
    if (Platform.isAndroid) {
      path = '/storage/emulated/0/Download/';
    } else if (Platform.isIOS) {
      Directory? documents = await getApplicationDocumentsDirectory();
      path = '${(documents.path)}/';
      debugger.printLogs('iOS Path : $path');
    }

    var img = imageName.split('.');
    //print(img[0]);
    while(img.length>2)
      {
       // print(img[0]);
      //print(img[1]);
        img[0] = "${img[0]}.${img[1]}";
        img.removeAt(1);
      }
    String filePath = "$path${img[0]}.${img[1]}";
    int i=1;
    while(await File(filePath).exists())
      {

        filePath = "$path${img[0]}($i).${img[1]}";
        i++;
      }
    //print("FinalFILEEEE $filePath");

    try {
      await Dio().download(
          imageUrl,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {

              //print("${(received / total * 100).toStringAsFixed(0)}%");
              //you can build progressbar feature too
            }
          });
      //print("File is saved to download folder.");
      String fileName=filePath.replaceAll(path, "");
      Fluttertoast.showToast(
          msg: "$fileName is saved to download folder",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black87,
          fontSize: 16.0
      );
    } on DioException catch (e) {
      //print("ERRRRRRRRRRRR");

      debugger.printLogs(e.message);
    }
  }

  Widget recentCommentListUI() {
    return FutureBuilder<MessageListModel?>(
      future: dioServiceClient.getMessageLists(record: widget.recordID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          MessageListModel? data = snapshot.data;

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data!.data!.length,
            itemBuilder: (context, index) {

              bool isCurrentUser = data.data![index].userName.toString() == Constants.userName;
              // print("aaaaaaaa");
              // print(data.data![index].userName.toString());
              // print(Constants.userName);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: isCurrentUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!isCurrentUser)
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(35),
                                  child: (data.data![index].userImage == null ||
                                      data.data![index].userImage!.isEmpty ||
                                      data.data![index].userImage!
                                          .toString() ==
                                          'null')
                                      ? const Image(
                                    image: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrLAk20Ifp4rbJnrPog675lcCns1f1rsafE0hVfdCoWR1Yiza1Fl3_7zg&s=10"),
                                    fit: BoxFit.cover,
                                  )
                                      : Image.network(
                                    data.data![index].userImage!
                                        .toString()
                                        .replaceAll("https", "http"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:  Theme.of(context).brightness == Brightness.light ?
              isCurrentUser
              ? Colors.blue[100]
                  : Colors.grey[200]:
              isCurrentUser
              ? Colors.blue[900]
                  : Colors.grey[900],


                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: isCurrentUser
                                    ? const Radius.circular(12)
                                    : Radius.zero,
                                bottomRight: isCurrentUser
                                    ? Radius.zero
                                    : const Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: AutoSizeText(
                                        data.data![index].userName.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    AutoSizeText(
                                      data.data![index].createdtime.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                AutoSizeText(
                                  data.data![index].commentcontent.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 10),




                          ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.data![index].imagename!.length,
                          itemBuilder: (context, imageIndex) {
                            String fileName = data.data![index].imagename![imageIndex].name.toString();
                            String fileUrl = data.data![index].imagename![imageIndex].url.toString();

                            Widget fileWidget;

                            if (fileName.endsWith(".pdf")) {
                              fileWidget = InkWell(
                                onTap: () {
                                  Get.to(() => PreviewPdf(
                                    pdfUrl: fileUrl,
                                    pdfName: fileName,
                                  ));
                                },
                                child: Column(
                                  children: [
                                    const Icon(Icons.picture_as_pdf, size: 50, color: Colors.red),
                                    Text(fileName, style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              );
                            }
                            else if (fileName.endsWith(".mp4")) {
                              fileWidget = InkWell(
                                onTap: () {
                                //  Get.to(() => PlayVideo(fileUrl));
                                },
                                child: const Align(
                                  alignment: Alignment.center,
                                  child:
                                    Icon(Icons.play_circle_fill, size: 40, color: Colors.white),
                                ),
                              );
                            } else if ([".jpg", ".png", ".jpeg", ".webp", ".bmp", ".ico", ".tiff", ".gif"]
                                .any((ext) => fileName.endsWith(ext))) {
                              fileWidget = InkWell(
                                onTap: () {
                                  showImagePreviewAlert(context, fileName, fileUrl);
                                },
                                child: Image.network(
                                  fileUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              fileWidget = InkWell(
                                onTap: () {
                                  downloadImage(fileUrl, fileName);
                                },
                                child: Column(
                                  children: [
                                    const Icon(Icons.insert_drive_file, size: 50, color: Colors.blue),
                                    Text(fileName, style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: fileWidget,
                            );
                          },
                        ),
                              ],
                            ),
                          ),
                        ),
                        if (isCurrentUser)
                          const SizedBox(width: 10),
                        if (isCurrentUser)
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(35),
                                  child: (data.data![index].userImage == null ||
                                      data.data![index].userImage!.isEmpty ||
                                      data.data![index].userImage!.toString() == 'null')
                                      ? const Image(
                                    image: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrLAk20Ifp4rbJnrPog675lcCns1f1rsafE0hVfdCoWR1Yiza1Fl3_7zg&s=10"),
                                    fit: BoxFit.cover,
                                  )
                                      : Image.network(
                                    data.data![index].userImage!.toString().replaceAll("https", "http"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(child: CustomLoader());
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: imageFile.length,
                      itemBuilder: (context, kk){
                        return imageFile[kk]== null? const Text(""):
                        Row(
                          children: [
                            Expanded(child: Text(imageFile[kk]!.path.split('/').last)),
                            InkWell(
                                onTap: (){
                                  setState(() {
                                    imageFile[kk]=null;
                                  });
                                },
                                child: const Icon(Icons.close)),
                          ],
                        );
                      }),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                recentCommentListUI(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
