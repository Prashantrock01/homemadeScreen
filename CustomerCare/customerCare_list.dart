// import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';
import '../../CustomWidgets/configurable_widgets.dart';
import '../../Model/CustomerCare/customerCare_list_modal.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';


class CustomerCare extends StatefulWidget {
  const CustomerCare({super.key});

  @override
  State<CustomerCare> createState() => _CustomerCareState();
}

class _CustomerCareState extends State<CustomerCare> {
  //final DioServiceClient _dioClient = DioServiceClient();
  final ScrollController _scrollController = ScrollController();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;


  List<Records> records = [];
  bool isLoading = true;
  bool isMoreLoading = false;
  int currentPage = 1;
  bool hasMoreRecords = true;

  /// Initialize connectivity status
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (_) {
      return;
    }

    if (!mounted) return;
    _updateConnectionStatus(result);
  }

  /// Update the internet connection status
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    setState(() {
      _connectionStatus = result.isNotEmpty ? result : [ConnectivityResult.none];
    });
  }

  @override
  void initState() {
    super.initState();
    customerList(currentPage);
    _scrollController.addListener(_onScroll);

    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        _updateConnectionStatus(results);
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _scrollController.dispose();
    super.dispose();
  }


  Future<void> customerList(int page) async {
    try {
      final customerCareList = await dioServiceClient.getCustomer(page: page);
      if (customerCareList != null && customerCareList.data?.records != null) {
        setState(() {
          if (page == 1) {
            records = customerCareList.data!.records!;
          } else {
            records.addAll(customerCareList.data!.records!);
          }
          isLoading = false;
          isMoreLoading = false;
          hasMoreRecords = customerCareList.data!.moreRecords ?? false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isMoreLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !isMoreLoading &&
        hasMoreRecords) {
      setState(() {
        isMoreLoading = true;
        currentPage++;
      });
      customerList(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Care List'),
      ),
      body:_connectionStatus.contains(ConnectivityResult.none)?
      checkInternetConnection(initConnectivity):
      isLoading
          ? const Center(child: CustomLoader())
          : records.isEmpty
          ? Center(
        child: Text(
          'No Customer Care records available.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      )
          : Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: records.length,
              itemBuilder: (context, index) {
                final customerCareList = records[index];
                return Card(
                  //elevation: 5,
                 // margin: const EdgeInsets.all(12.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            const Text("Customer Executive", style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(customerCareList.customercareName.toString()),
                            GestureDetector(
                                onTap: (){
                                  launchUrl(Uri.parse("tel:${customerCareList.customercareMobile.toString()}"));
                                  },
                                child: Text(customerCareList.customercareMobile.toString())
                            ),

                          ],
                        ),
                        const Icon(Icons.support_agent, size: 50)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
    );
  }
}
