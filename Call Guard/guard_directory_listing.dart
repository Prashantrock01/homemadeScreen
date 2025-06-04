import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../CustomWidgets/configurable_widgets.dart';
import '../../Utils/app_string.dart';
import '../../Utils/constants.dart';
import '../bottom_navigation.dart';

class GuardDirectoryListing extends StatefulWidget {
  const GuardDirectoryListing({super.key});

  @override
  State<GuardDirectoryListing> createState() => _GuardDirectoryListingState();
}

class _GuardDirectoryListingState extends State<GuardDirectoryListing> {
  var userRole =  Constants.userRole;
  RxList<dynamic> recordList = [].obs;
  int page = 1;
  bool isMorePage = true;
  bool isLoading = true;
  final ScrollController _sc = ScrollController();
  final RxBool _showProgress = false.obs;
  RxBool retryData = false.obs;

  Future<void> openWhatsAppDirect(String phoneNumber) async {
    final Uri whatsappUri = Uri.parse("whatsapp://send?phone=$phoneNumber");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      throw "WhatsApp is not installed or cannot be launched.";
    }
  }

  Future<void> openSMS(String phoneNumber, {String? message}) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: message != null ? {'body': message} : null,
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch SMS app.";
    }
  }

  void initiateCall(String phoneNumber) async {
    final Uri callUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $callUri';
    }
  }

  fetchGuardDirectory() async {
    page != 1 ? isLoading = true : _showProgress.value = true;
    retryData.value = false;
    try {
      var response = await dioServiceClient.getCallGuardList(page: page,);
      if (response?.statuscode == 1 && response!.data!.records!.isNotEmpty) {
        // setState(() {
        //   for (int i = 0; i < response!.data!.records!.length; i++) {
        //     records.add(response.data!.records![i]);
        //   }
        recordList.addAll(response.data!.records!);
        isMorePage = response.data!.moreRecords!;
      }
      else {
        recordList.clear();
      }
    }catch (e) {
      retryData.value = true;
    }
    _showProgress.value = false;
  }

  checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      isConnected = connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.ethernet);

    });
  }

  refreshHandler() async {
    page = 1;
    recordList.clear();
    await fetchGuardDirectory();
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> connectivityResult) {
      if (mounted) {
        setState(() {
          isConnected = connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.ethernet);
        });
      } else {
        isConnected = connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.ethernet);
      }
    });
    fetchGuardDirectory();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        if (isMorePage) fetchGuardDirectory();
      }
    });

  }


  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guard Directory",),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const BottomNavigation(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),


      body:!isConnected
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(noInternetText)),
          ElevatedButton(
              onPressed: () {
                Get.to(() => const GuardDirectoryListing());
              },
              child: const Text("Retry")),
        ],
      )
        : Obx(() => _showProgress.isTrue
    ? const Center(child: CustomLoader())
        : retryData.isTrue
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text(retryToLoadDataText)),
                        const SizedBox(height: 10,),
                        ElevatedButton(
                            onPressed: () {
                              Get.to(() => const GuardDirectoryListing());
                            },
                            child:Text(retryText)),
                      ],
                    )
                  : recordList.isEmpty ? const Center(
        child: AutoSizeText(
            'Guard Directory is Empty'
        ))
        :
      RefreshIndicator(
        onRefresh:() {
         return refreshHandler();
          },
        child: Obx(
              () => ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            controller: _sc,
            itemCount: recordList.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AutoSizeText(recordList[index].guarddirName.toString()),
                            const SizedBox(height: 5),
                            AutoSizeText(recordList[index].phone.toString()),
                          ],
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            initiateCall(recordList[index].phone.toString());
                          },
                          child: const Icon(Icons.call),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      ),




      // floatingActionButton: userRole == "Facility Manager"
      //     ? FloatingActionButton(
      //   onPressed: ()  {
      //   Get.to(() => const CreateGuard());
      //   },
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Image.asset(
      //       'assets/images/guard_icon.png',
      //     ),
      //   ),
      // )
      //     : const SizedBox(
      //   height: 0,
      // ),
    );
  }

}
