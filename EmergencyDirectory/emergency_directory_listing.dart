import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CustomWidgets/CustomLoaders/custom_loader.dart';
import '../../CustomWidgets/configurable_widgets.dart';
import '../../Utils/constants.dart';
import 'create_emergency_directory.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;


class EmergencyDirectoryListing extends StatefulWidget {
  const EmergencyDirectoryListing({super.key});

  @override
  State<EmergencyDirectoryListing> createState() => _EmergencyDirectoryListingState();
}

class _EmergencyDirectoryListingState extends State<EmergencyDirectoryListing> {

  var userRole = Constants.userRole;

  RxList<dynamic> records = [].obs;
  int page = 1;
  bool isMorePage = true;
  bool isLoading = true;
  final ScrollController _sc = ScrollController();
  final RxBool _showProgress = false.obs;
  RxBool retryData = false.obs;

   fetchEmergencyDirectory() async {
    page != 1 ? isLoading = true : _showProgress.value = true;
    retryData.value = false;
    try {
      var response = await dioServiceClient.getEmergencyDirectoryList(true, page: page++);
      if (response?.statuscode == 1) {
        setState(() {
          for (int i = 0; i < response!.data!.records!.length; i++) {
            records.add(response.data!.records![i]);
          }
          isMorePage = response.data!.moreRecords!;
        });
      }
    }
    catch (e) {
      setState(() {
        retryData.value = true;
      });
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
    records.clear();
    await fetchEmergencyDirectory();
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
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
    fetchEmergencyDirectory();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        if (isMorePage) fetchEmergencyDirectory();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Directory"),
      ),
      body: !isConnected
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text("No internet connection. Please try again later.")),
          ElevatedButton(
              onPressed: () {
                Get.to(() => const EmergencyDirectoryListing());
              },
              child: const Text("Retry")),
        ],
      )
          :Obx(
            () => _showProgress.isTrue
            ? const Center(child: CustomLoader())
            : retryData.isTrue
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Text("Retry to load the data")),
            const SizedBox(
              height: 10,
            ),
            textButton(
                onPressed: () {
                  Get.to(()=> const EmergencyDirectoryListing());
                },
                widget: const Text("Retry")),
          ],
        )
            : records.isEmpty
            ? const Center(
            child: AutoSizeText(
              "Oops!! Emergency Directory is Empty",
            ))
            : RefreshIndicator(
          onRefresh: () {
            return refreshHandler();
          },
          child: Obx(
                () => ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _sc,
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Card(
                            child: ListTile(
                              leading: const Icon(Icons.phone),
                              title: Text(record.emergencydirName ?? 'Unknown'),
                              subtitle:
                              Text(record.emergencydirMobile ?? 'No number'),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                url_launcher.launchUrl(Uri.parse('tel:+91 ${record.emergencydirMobile}'));
                                },
                            ),
                          ),
                          isMorePage
                              ? (index == records.length - 1)
                              ? const CircularProgressIndicator()
                              : const SizedBox(
                            height: 0,
                          )
                              : const SizedBox(
                            height: 0,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),

    ),

        floatingActionButton:
        userRole == 'Facility Manager' ?
        FloatingActionButton(
        onPressed: () {
          Get.off(()=> const CreateEmergencyDirectory());
        },
        child: const Icon(Icons.contact_emergency),

      ): const SizedBox(height: 0,)
    );
  }

}
