import 'dart:io';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
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
import '../../../Network/dio_service_client.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/debugger.dart';


class MessageGuardDetails extends StatefulWidget {

  final String recordID;
  final String name;

  const MessageGuardDetails( {super.key, required this.recordID, required this.name});

  @override
  State<MessageGuardDetails> createState() => _MessageGuardDetailsState();
}

class _MessageGuardDetailsState extends State<MessageGuardDetails> {

  // String recordID;
  _MessageGuardDetailsState();

  final _formKey = GlobalKey<FormState>();
  final List<bool> _isReplyVisible = [] ;
  final List<bool> _isReplyVisibleInside = [] ;
  final List<bool> _isEditVisible = [];
  final List<bool> _isEditVisibleInside = [];
  List listOfFileInside = [];
  List<TextEditingController?> listOfReplyTextController = [];
  List<TextEditingController?> listOfReplyTextControllerInside = [];
  List<TextEditingController?> listOfEditTextController = [];
  List<TextEditingController?> listOfEditTextControllerInside = [];
  List listOfFile = [];
  List<File?> imageFile=[];
  int count=0;
  var albumName = "/storage/emulated/0/Download/InfraEye Downloads";

  final displayCommentController = TextEditingController();


  XFile? pickedFile;
  // File? imageFile;

  // @override
  // void initState() {
  //   _getUser();
  //   super.initState();
  // }


  // _getUser()async{
  //   ProfileModel? response = await _dioClient.getprofile(
  //       uid: ConstantValue.PREUSERID!,
  //       acctoken: ConstantValue.PRETOKEN!,);
  //   String name = response?.data?.profileInfo?.serviceEngineerName ?? '';
  //   ConstantValue.USERNAME = name;

  //}
  // _getFromGallery() async {
  //
  //   pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   ); pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile.add(File(pickedFile!.path));
  //     });
  //   }
  // }

 // List<String> filePaths = [];

  // Future<void> _getFiles() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowMultiple: true,
  //     type: FileType.custom,
  //     allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'pdf'],
  //   );
  //
  //   if (result != null) {
  //     setState(() {
  //      // filePaths = result.paths.map((path) => path!).toList();
  //       imageFile = result.paths.map((path) => File(path!)).toList();
  //     });
  //   }
  // }

  previewVideo(String url, String name) async{

    final response = await http.get(Uri.parse(url));

    final documentDirectory = await getApplicationDocumentsDirectory();

    File videoFile = File('${documentDirectory.path}/ $name');

    videoFile.writeAsBytesSync(response.bodyBytes);

    Get.to(() => PlayVideo(videoFile));
  }


  // _getFromGalleryToFile(int i) async {
  //   pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       ListOfFileInside[i] = File(pickedFile!.path);
  //     });
  //   }
  // }
  //
  //
  // _getFromGalleryForComment(int i) async {
  //   debugger.printLogs("PICKIMAGE");
  //   pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //
  //       ListOfFile[i] = File(pickedFile!.path);
  //       debugger.printLogs(pickedFile!.path);
  //     });
  //   }
  // }


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
                      Expanded(child: Text(imageName)),
                      TextButton(
                        onPressed: () {
                         downloadImage(url, imageName);
                        },
                        style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width/5, 0 )),),
                        child: const Text("Download"),
                      ),
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
                  height: MediaQuery.of(context).size.height / 1.5,
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


  _getChildReplies(Replies reply, int i) {
    return Column(
      children: [
        Row(
          children: [
            ClipOval(
              //borderRadius: BorderRadius.circular(20), // Image border
              child: SizedBox.fromSize(
                  size: const Size.fromRadius(30), // Image radius
                child: (reply.userImage??"").isEmpty ?
                    const Image( image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrLAk20Ifp4rbJnrPog675lcCns1f1rsafE0hVfdCoWR1Yiza1Fl3_7zg&s=10"), fit: BoxFit.cover)
               : Image(image: NetworkImage(reply.userImage?.replaceAll("https", "http") ?? ''), fit: BoxFit.cover ),
              ),
            ),
            const SizedBox(width: 20,),

            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(reply.userName.toString(),),
                      ),
                      Text(reply.createdtime.toString()),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Text(reply.commentcontent.toString()),
                  const SizedBox(height: 10,),


                  Row(
                    children: [
                      InkWell(
                          onTap: (){
                            setState(() {
                              _isReplyVisibleInside[i] = true;
                              _isEditVisibleInside[i] = false;
                              //print("REPLY$i -$_isReplyVisibleInside");
                            });
                            if(listOfReplyTextControllerInside[i]!.text=="") {
                              listOfReplyTextControllerInside[i]!.text =
                              "@${reply.userName} ";
                            }
                          },
                          child: const Text("Reply")),


                      const SizedBox(width: 10,),
                      Visibility(
                        visible: Constants.userName == reply.userName,
                        child: InkWell(
                            onTap: (){
                              setState(() {
                                _isEditVisibleInside[i] = true;
                                _isReplyVisibleInside[i] = false;
                              });
                            },
                            child: const Text("Edit")),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20,),
        //replySection
        Visibility(
          visible: _isReplyVisibleInside[i],
          child: Column(
            children: [
              TextFormField(
                controller: listOfReplyTextControllerInside[i]!,
                maxLines: 5,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Please add comments";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(),
                  errorBorder:  OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red,),
                  ),
                  disabledBorder: OutlineInputBorder(),
                  hintText: "Add comments",
                  //labelText: snapshot.data.data.
                  // labelStyle: Styles.TextLabel,
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                            setState(() {
                              var replyValue = {"commentcontent" :listOfReplyTextControllerInside[i]!.text, "related_to": widget.recordID,"assigned_user_id" :Constants.userUniqueId ,"parent_comments":reply.modcommentsid.toString()};
                              dioServiceClient.replyMessageGuard( values: replyValue, imagePath: listOfFileInside[i], recordID: widget.recordID,name: widget.name);
                              listOfFileInside[i] = null;
                              _isReplyVisibleInside[i] = false;
                            });
                          },
                        style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width/5, 40 )),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),),
                           // backgroundColor: WidgetStateProperty.all(Colors.deepPurple)
                        ),
                        child: const Text("Post"),
                      ),
                      const SizedBox(width: 10,),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isReplyVisibleInside[i] = false;
                            listOfFileInside[i]=null;
                          });
                        },
                        style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width/5, 40 )),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),),
                            //backgroundColor: WidgetStateProperty.all(Colors.red.shade100)
                        ),
                        child: const Text("Cancel"),
                      ),

                    ],),

                ],
              ),
              const SizedBox(height: 10,),
              listOfFileInside[i]== null? const Text(""):
              Row(
                children: [
                  Expanded(child: Text(listOfFileInside[i]!.path.split('/').last)),
                  InkWell(
                      onTap: (){
                        setState(() {
                          listOfFileInside[i]=null;
                        });

                      },
                      child: const Icon(Icons.close)),
                ],
              )
            ],
          ),
        ),
        // edit section
        Visibility(
          visible: _isEditVisibleInside[i],
          child: Column(
            children: [
              TextFormField(
                controller: listOfEditTextControllerInside[i]!,
                maxLines: 5,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Please add comments";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(),
                  errorBorder:  OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red,),
                  ),
                  disabledBorder: OutlineInputBorder(),
                  hintText: "Edit comment message",
                  // labelText: data.data?[index].replies?.length == 0? "": data.data?[index].replies?[index].commentcontent.toString(),
                ),
              ),
              const SizedBox(height: 10,),


              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            var editValues = {"commentcontent" : listOfEditTextControllerInside[i]!.text, "related_to": widget.recordID, "assigned_user_id":  Constants.userUniqueId,"reasontoedit":"Rejected"};
                            dioServiceClient.editMessagesCallGuard( values: editValues, model: 'ModComments', record: reply.modcommentsid.toString(), imagePath: imageFile, recordID: widget.recordID,name: widget.name);
                            listOfFileInside[i] = null;
                            _isEditVisibleInside[i] = false;
                          });
                          },
                        style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width/5, 40 )),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),),
                            //backgroundColor: WidgetStateProperty.all(Colors.deepPurple)
                        ),
                        child: const Text('Post'),
                      ),
                      const SizedBox(width: 10,),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isEditVisibleInside[i]= false;
                          });

                        },
                        // style: ButtonStyle(
                        //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        //     minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width/5, 0 )),
                        //     shape: WidgetStateProperty.all(
                        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),),
                        //     backgroundColor: WidgetStateProperty.all(Colors.red.shade100)
                        // ),
                        child: const Text("Cancel"),
                      ),

                    ],),
                ],
              ),
              const SizedBox(height: 10,),
              listOfFileInside[i]== null? const Text(""):
              Row(
                children: [
                  Expanded(child: Text(listOfFileInside[i]!.path.split('/').last)),
                  InkWell(
                      onTap: (){
                        setState(() {
                          listOfFileInside[i]=null;
                        });

                      },
                      child: const Icon(Icons.close)),
                ],
              )
            ],
          ),
        ),

        const SizedBox(height: 20,),
        ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
          itemCount: reply.replies!.length,
            itemBuilder: (context, index){
              if(_isReplyVisibleInside.length<=count)
                {
                  listOfFileInside.add(null);
              _isReplyVisibleInside.add(false);
              _isEditVisibleInside.add(false);

                  listOfEditTextControllerInside.add(TextEditingController());
                  listOfReplyTextControllerInside.add(TextEditingController());
                }
             return  _getChildReplies(reply.replies![index], count++);
        })
      ],
    );
  }

  Widget recentCommentListUI() {
    return FutureBuilder<MessageListModel?>(
      future: dioServiceClient.getMessageLists(record:widget.recordID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          MessageListModel? data = snapshot.data;

         if(_isReplyVisible.length!=snapshot.data!.data!.length){
          _isReplyVisible.clear();
          _isEditVisible.clear();
          listOfFile.clear();
          listOfReplyTextController.clear();
          listOfEditTextController.clear();
          // ListOfFile =  List.filled(snapshot.data!.data!.length, null, growable: false);
          for(int i=0; i<snapshot.data!.data!.length;i++)
            {
              _isReplyVisible.add(false);
              _isEditVisible.add(false);
              listOfFile.add(null);
              listOfReplyTextController.add(TextEditingController());
              listOfEditTextController.add(TextEditingController());
            }}
          count=0;

          // BUILDING THE UI HERE  ///
          return ListView.builder(
           physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data!.data!.length,
              itemBuilder: (context, index){
                return  Column(
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          //borderRadius: BorderRadius.circular(20),
                          // Image border
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(30),
                            // Image radius
                            //child:( data.data![index].userImage!.isEmpty || data.data![index].userImage.toString() == 'null')? Container(color: Colors.grey):Image.network( data.data![index].userImage.toString().replaceAll("https", "http") , fit: BoxFit.cover,) ,
                            child: (data.data![index].userImage == null ||
                                    data.data![index].userImage!.isEmpty ||
                                    data.data![index].userImage!
                                            .toString() ==
                                        'null')
                                ? const Image(
                                    image: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrLAk20Ifp4rbJnrPog675lcCns1f1rsafE0hVfdCoWR1Yiza1Fl3_7zg&s=10"),
                                    fit: BoxFit.cover)
                                : Image.network(
                                    data.data![index].userImage!
                                        .toString()
                                        .replaceAll("https", "http"),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            physics: const ScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data.data![index].userName.toString(),

                                      ),
                                    ),
                                    Text(
                                      data.data![index].createdtime
                                          .toString(),

                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  data.data![index].commentcontent.toString(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        data.data![index].imagename!.length,
                                    itemBuilder: (context, imageindex) {
                                      return InkWell(
                                        onTap: () {
                                          if(data.data![index].imagename![imageindex].name.toString().endsWith(".pdf")){
                                           // PreviewPdf(pdfUrl: data.data![index].imagename![imageindex].url.toString(), pdfName: data.data![index].imagename![imageindex].name.toString(),);
                                            Get.to(() => PreviewPdf(
                                              pdfUrl:data.data![index].imagename![imageindex].url.toString(),
                                              pdfName: data.data![index].imagename![imageindex].name.toString(),
                                            ));

                                          }
                                          else if(data.data![index].imagename![imageindex].name.toString().endsWith(".mp4")){
                                               previewVideo(data.data![index].imagename![imageindex].url.toString(), data.data![index].imagename![imageindex].name.toString());
                                          }
                                          else if(
                                          data.data![index].imagename![imageindex].name.toString().endsWith(".jpg")||
                                          data.data![index].imagename![imageindex].name.toString().endsWith(".png")||
                                          data.data![index].imagename![imageindex].name.toString().endsWith(".jpeg")||
                                          data.data![index].imagename![imageindex].name.toString().endsWith(".webp")||
                                          data.data![index].imagename![imageindex].name.toString().endsWith(".bmp")||
                                          data.data![index].imagename![imageindex].name.toString().endsWith(".ico")||
                                          data.data![index].imagename![imageindex].name.toString().endsWith(".tiff")||
                                          data.data![index].imagename![imageindex].name.toString().endsWith(".gif") ) {

                                           showImagePreviewAlert(context, data.data![index].imagename![imageindex].name.toString(), data.data![index].imagename![imageindex].url.toString());
                                         }
                                          else{
                                            downloadImage(data.data![index].imagename![imageindex].url.toString(), data.data![index].imagename![imageindex].name.toString());
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.attachment_sharp,
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(child: Text(data.data![index].imagename![imageindex].name.toString())),
                                          ],
                                        ),
                                      );
                                    }),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            _isReplyVisible[index] = true;
                                            _isEditVisible[index] = false;
                                          });
                                          if (listOfReplyTextController[
                                                      index]!
                                                  .text ==
                                              "") {
                                            listOfReplyTextController[index]!
                                                    .text =
                                                "@${snapshot.data!.data![index].userName} ";
                                          }
                                          //print(_isReplyVisible.toString());
                                        },
                                        child: const Text(
                                          "Reply",
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Visibility(
                                      visible: Constants.userName ==
                                          data.data![index].userName,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _isEditVisible[index] = true;
                                              _isReplyVisible[index] = false;
                                            });
                                            //print(_isEditVisible.toString());
                                          },
                                          child: const Text(
                                            "Edit",
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20,),
                Visibility(
                  visible: _isReplyVisible[index],
                  child: Column(
                    children: [
                      TextFormField(
                        controller: listOfReplyTextController[index]!,
                        maxLines: 5,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Please add comments";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(),
                          errorBorder:  OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red,),
                          ),
                          disabledBorder: OutlineInputBorder(),
                          hintText: "Add Comments",
                          //labelText: snapshot.data.data.
                          // labelStyle: Styles.TextLabel,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              textButton(
                                onPressed: () {
                                  var replyValue = {"commentcontent" :listOfReplyTextController[index]!.text, "related_to": widget.recordID,"assigned_user_id" : Constants.userUniqueId ,"parent_comments":data.data![index].modcommentsid.toString()};
                                  dioServiceClient.replyMessageGuard(values: replyValue, imagePath: listOfFile[index], recordID: widget.recordID,name: widget.name);
                                  listOfFile[index] = null;
                                  _isReplyVisible[index] = false;
                                },
                                style: ButtonStyle(
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width/5, 40 )),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),),
                                    //backgroundColor: WidgetStateProperty.all(Colors.deepPurple)
                                ),
                                widget: const Text("Post"),
                              ),
                              const SizedBox(width: 10,),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isReplyVisible[index] = false;
                                    listOfFile[index]=null;
                                  });
                                },
                                // style: ButtonStyle(
                                //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                //     minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width/5, 0 )),
                                //     shape: WidgetStateProperty.all(
                                //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),),
                                //     backgroundColor: WidgetStateProperty.all(Colors.red.shade100)
                                // ),
                                child: const Text("Cancel"),
                              ),

                            ],),

                        ],
                      ),
                      const SizedBox(height: 10,),
                      listOfFile[index]== null? const Text(""):
                      Row(
                        children: [
                          Expanded(child: Text(listOfFile[index]!.path.split('/').last)),
                          InkWell(
                              onTap: (){
                                setState(() {
                                  listOfFile[index]=null;
                                });

                              },
                              child: const Icon(Icons.close)),
                        ],
                      )
                    ],
                  ),
                ),


                // edit section
                Visibility(
                  visible: _isEditVisible[index],
                  child: Column(
                    children: [
                      TextFormField(
                        controller: listOfEditTextController[index]!,
                        maxLines: 5,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Please add comments";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(),
                          errorBorder:  OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red,),
                          ),
                          disabledBorder: OutlineInputBorder(),
                          hintText: "Edit comment message",
                          // labelText: data.data?[index].replies?.length == 0? "": data.data?[index].replies?[index].commentcontent.toString(),
                        ),
                      ),
                      const SizedBox(height: 10,),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                 // print("Edit Button pressed");
                                  var editValues = {"commentcontent" : listOfEditTextController[index]!.text, "related_to": widget.recordID, "assigned_user_id":  Constants.userUniqueId,"reasontoedit":"Rejected"};
                                  dioServiceClient.editMessagesCallGuard(values: editValues, model: 'ModComments', record: data.data![index].modcommentsid.toString(), imagePath: imageFile, recordID: widget.recordID,name: widget.name, );
                                  _isEditVisible[index] = false;
                                },
                                // style: ButtonStyle(
                                //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                //     minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width/5, 0 )),
                                //     shape: WidgetStateProperty.all(
                                //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),),
                                //     backgroundColor: WidgetStateProperty.all(Colors.deepPurple)
                                // ),
                                child: const Text("Post"),
                              ),
                              const SizedBox(width: 10,),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditVisible[index] = false;
                                  });

                                },
                                // style: ButtonStyle(
                                //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                //     minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width/5, 0 )),
                                //     shape: WidgetStateProperty.all(
                                //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),),
                                //     backgroundColor: WidgetStateProperty.all(Colors.red.shade100)
                                // ),
                                child: const Text("Cancel"),
                              ),

                            ],),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      listOfFile[index]== null? const Text(""):
                      Row(
                        children: [
                          Expanded(child: Text(listOfFile[index]!.path.split('/').last)),
                          InkWell(
                              onTap: (){
                                setState(() {
                                  listOfFile[index]=null;
                                });

                              },
                              child: const Icon(Icons.close)),
                        ],
                      ),
                    ],
                  ),
                ),//

                const SizedBox(height: 20,),
                ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                    itemCount: data.data![index].replies!.length,
                    itemBuilder: (context, index1){
                  //print("Length:${_isReplyVisibleInside.length}");
                  //print("Count:$count");
                  if(_isReplyVisibleInside.length<=count)
                    {
                      listOfFileInside.add(null);
                      _isReplyVisibleInside.add(false);
                      _isEditVisibleInside.add(false);
                      listOfEditTextControllerInside.add(TextEditingController());
                      listOfReplyTextControllerInside.add(TextEditingController());
                      //print("newLength:${_isReplyVisibleInside.length}");
                    }
                      return _getChildReplies(data.data![index].replies![index1], count++);
                    })
                                ],


                              );
          });
        } else if (snapshot.hasError) {
          //print("Error while fetching detailsview !");
          return Text("${snapshot.error}");
        }
        return const Center(child: CircularProgressIndicator());
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
                  // Text(comment_text),

                  //  const SizedBox(height: 10,),

                  /// need to move to the bottom// need to display outside Single Child ScrollView - STARTS
                  // TextFormField(
                  //   controller: displayCommentController,
                  //   maxLines: 5,
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   keyboardType: TextInputType.text,
                  //   validator: (value){
                  //     if(value == null || value.isEmpty){
                  //       return please_enter_comment_error_message;
                  //     }
                  //     return null;
                  //   },
                  //   decoration: InputDecoration(
                  //     border: const OutlineInputBorder(),
                  //     focusedBorder: const OutlineInputBorder(),
                  //     enabledBorder: const OutlineInputBorder(),
                  //     errorBorder:  const OutlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.red,),
                  //     ),
                  //     disabledBorder: const OutlineInputBorder(),
                  //     hintText: post_comment_text,
                  //     // labelStyle: Styles.TextLabel,
                  //   ),
                  // ),

                  // const SizedBox(height: 10,),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     TextButton(
                  //       onPressed: _getFiles,
                  //       style: ButtonStyle(
                  //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //           minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width/5, 0 )),
                  //           shape: WidgetStateProperty.all(
                  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),),
                  //           backgroundColor: WidgetStateProperty.all(Colors.deepPurple.shade100)
                  //       ),
                  //       child: Text(attach_file_text, style: Styles.DeepPurpleText),
                  //     ),
                  //     TextButton(
                  //       onPressed: () {
                  //         if (_formKey.currentState!.validate()) {
                  //           var commentsValue = {"commentcontent" :displayCommentController.text, "related_to": widget.recordID,"assigned_user_id" : Constants.userUniqueId };
                  //          _dioClient.createDiscussionBlogCommentsData(displayCommentControllerValue: commentsValue, ImagePath: imageFile, recordID: widget.recordID, redirect: false);
                  //         }
                  //       },
                  //       style: ButtonStyle(
                  //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //           minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width/5, 0 )),
                  //           shape: WidgetStateProperty.all(
                  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),),
                  //           backgroundColor: WidgetStateProperty.all(Colors.deepPurple)
                  //       ),
                  //       child: Text(post_text, style: Styles.WhiteText),
                  //     ),
                  //
                  //   ],),

                  ///need to move to the bottom// need to display outside Single Child ScrollView - ENDS

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

                  //
                  // const SizedBox(height: 20,),
                  //
                  // Divider(
                  //   color: Colors.grey.shade400,
                  //   thickness: 1,
                  // ),
                ],
              ),
            ),

           // const SizedBox(height: 20,),

            // Text(recent_comments_text, style: Styles.BlackText_20,),
            //
            // const SizedBox(height: 20,),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //const SizedBox(height: 20,),
                recentCommentListUI(),


              //  const SizedBox(height: 20,),



              //  Divider(color: Colors.grey.shade300, thickness: 1,),
              ],
            ),


          ],
        ),
      ),
    );
  }
}
