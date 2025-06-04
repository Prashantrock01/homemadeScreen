import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/Polls/polls_Details.dart';
import 'package:biz_infra/Screens/Polls/polls_creation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CustomWidgets/CustomLoaders/custom_loader.dart';
import '../../Model/Polls/DetailsPollsModel.dart';
import '../../Model/Polls/PollsListingModel.dart';
import '../../Utils/constants.dart';

class PollsListing extends StatefulWidget {
  const PollsListing({super.key});

  @override
  State<PollsListing> createState() => _PollsListingState();
}

class _PollsListingState extends State<PollsListing> {
  DetailsPollsModel ? DetailsPollsModelData;
  final ScrollController  _scrollController = ScrollController();
   TextEditingController searchController = TextEditingController();
  List<Records> records =[];
  bool isLoading = true;
  bool isMoreLoading = false;
  int currentPage = 1;
  bool hasMoreRecord= true;
  List<Records> allRecords =[];
  bool searching =false;

  @override
  void initState(){
    super.initState();
    _fetchPollList(currentPage);
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchPollList(int page) async{
    try{
      final pollList = await dioServiceClient.pollsList(page:page);
      if( pollList != null && pollList.data?.records!= null){
        setState(() {
          if(page == 1){
            records = pollList.data!.records!;
            allRecords = List.from(records);
          }
          else{
            records.addAll(pollList.data!.records!);
            allRecords.addAll(pollList.data!.records!);
          }
          isLoading = false;
          isMoreLoading =false;
          hasMoreRecord = pollList.data!.moreRecords ?? false;
        });
      }
    }
    catch(e){
setState(() {
  isLoading = false;
  isMoreLoading = false;
});
    }
  }

  void _onScroll(){
    if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isMoreLoading && !hasMoreRecord){
      setState(() {
        isMoreLoading = true;
        currentPage++;
      });
      _fetchPollList(currentPage);
    }
  }

  void clearSearch(){
    searchController.clear();
    setState(() {
      searching = false;
      records = List.from(allRecords);
    });
  }

  void filterPollRecords(String filter){
    setState((){
      records = allRecords.where((record)=>
      (record.pollNo!= null && record.pollNo!.toLowerCase().contains(filter.toLowerCase()))||
          (record.pollType!= null && record.pollType!.toLowerCase().contains(filter.toLowerCase())) ||
              (record.pollTopic!= null && record.pollTopic!.toLowerCase().contains(filter.toLowerCase()))||
          (record.pollDescription!=null && record.pollDescription!.toLowerCase().contains(filter.toLowerCase()))
      || (record.pollstartDate!= null && record.pollstartDate!.toLowerCase().contains(filter.toLowerCase())) ||
          (record.pollendDate!= null && record.pollendDate!.toLowerCase().contains(filter.toLowerCase()))
          || (record.pollStatus!=null && record.pollStatus!.toLowerCase().contains(filter.toLowerCase()))||
          (record.pollid!=null && record.pollid!.toLowerCase().contains(filter.toLowerCase()))||
          (record.id!= null && record.id!.toLowerCase().contains(filter.toLowerCase()))
      ).toList();
    });
  }

  @override
  void dispose(){
    super.dispose();
    _scrollController.dispose();
  }

  Future<void>_onRefresh() async{
    setState(() {
      isLoading = true;
      currentPage =1;
      hasMoreRecord = true;
      records.clear();
    });
    await _fetchPollList(currentPage);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searching ?
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.black),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10)
                      ),
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black, fontSize: 16
            ),
            onChanged: (filter){
                      if(filter.isNotEmpty){
                        filterPollRecords(filter);
                      }
                      else {
                        clearSearch();
                      }
            }
                    ),
                  )
            ],
          ),
        )
      :Text('Poll List') ,

     actions: [
       if(searching)
         IconButton(
         icon: Icon(Icons.clear),
  onPressed: (){
           setState(() {
             searching =false;
             searchController.clear();
             records = List.from(allRecords);
           }
           );
  },
         )
  else
    IconButton(
  onPressed: (){
    setState(() {
      searching = !searching;
      if(!searching){
        clearSearch();
  }
    });
  }, icon: Icon(Icons.search,
  ),
  )
  ],
      ),
      body: isLoading ? const Center(child: CustomLoader()): records.isEmpty
        ? Center(
        child: Text('No Polls record Available'),
      ): Container(
        child: Column(
          children: [
            Expanded(
                child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: records.length,
                    itemBuilder: (context,index){
                    final polls = records[index];
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children:<Widget> [
                          GestureDetector(
                            onTap: () {
                              Get.to(() =>
                              PollsDetails(
                                recordId: polls.id!, pollId: polls.pollid!,
                              ),
                             // ChatScreen(),
                                transition: Transition.leftToRight,
                                popGesture: true,
                              );
                            },
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children:<Widget> [
                                    keyValues('Poll No',polls.pollid ?? ''),
                                    SizedBox(height: 10),
                                    keyValues('Poll Type', polls.pollType ?? ''),
                                    SizedBox(height: 10),
                                    keyValues('Poll Topic', polls.pollTopic ?? ''),
                                    SizedBox(height: 10),
                                    keyValues('Description', polls.pollDescription ?? ''),
                                    SizedBox(height: 10),
                                    keyValues('Start Date', polls.pollstartDate ?? ''),
                                    SizedBox(height: 10),
                                    keyValues('End Date', polls.pollendDate ?? ''),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                    })
            )
            ),
            if (isMoreLoading)
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
      // FutureBuilder(
      //   future: dioServiceClient.pollsList(page: null),
      //   builder: (context, snapshot) {
      //   if(snapshot.hasData) {
      //
      //       return ListView.builder(
      //         itemCount: snapshot.data!.data!.records!.length,
      //         itemBuilder: (context, index) {
      //           // print('start dateeeeeeeeee');
      //           // print(snapshot.data!.data!.records![index].pollstartDate.toString());
      //
      //           return Padding(
      //            padding: const EdgeInsets.all(10.0),
      //            child: InkWell(
      //              onTap: (){
      //                print('asdf');
      //                print(snapshot.data!.data!.records![index].id.toString());
      //                Get.to(()=>PollsDetails(
      //                    recordId: snapshot.data!.data!.records![index].id.toString()
      //                ));
      //              },
      //              child: Card(
      //
      //                  child:  Padding(
      //                    padding: const EdgeInsets.all(10.0),
      //                    child: Column(
      //                      children: [
      //                        keyValue('Poll Id', snapshot.data!.data!.records![index].pollid.toString()),
      //                        SizedBox(height: 10),
      //                        keyValue('Poll Type', snapshot.data!.data!.records![index].pollType.toString()),
      //                        SizedBox(height: 10),
      //                        keyValue('Poll Topic',snapshot.data!.data!.records![index].pollTopic.toString()),
      //                        SizedBox(height:10),
      //                        keyValue('Description',snapshot.data!.data!.records![index].pollDescription.toString()),
      //                        SizedBox(height: 20),
      //                        keyValue('Start Date',snapshot.data!.data!.records![index].pollstartDate.toString()),
      //                        SizedBox(height: 20),
      //                        keyValue('End Date', snapshot.data!.data!.records![index].pollendDate.toString()),
      //                        SizedBox(height: 20),
      //                        keyValue('Total Polling', snapshot.data!.data!.records![index].pollStatus.toString())
      //                       // keyValue('Poll Count', DetailsPollsModelData!.data!.record!.pollStatus ?? ''),
      //                      ]
      //                    ),
      //                  ),
      //              ),
      //            ),
      //          );
      //         },
      //       );
      //     }else {
      //     return Container();
      //   }
      //   },
      // ),
      floatingActionButton:
      (Constants.userRole == 'Owner' || Constants.userRole == 'Facility Manager') ?
      FloatingActionButton(
          backgroundColor: Colors.amber,
          child: const Icon(Icons.poll_sharp,color:Colors.white,size:30),
          onPressed: (){
            print("object");
            Get.to(()=> PollsCreation( appBarText: "appBarText", leading: true
            ));
          }
      )
          :null
      );


  }
  Widget ticketIdValue(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 0,
            child: AutoSizeText(
              key,
              minFontSize: 12.0,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 78, 97, 204),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const AutoSizeText(
            ' :',
            minFontSize: 12.0,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 0,
            child: AutoSizeText(
              value,
              minFontSize: 12.0,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 214, 85, 76),
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget keyValues(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AutoSizeText(
              key,
              minFontSize: 12.0,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 78, 97, 204),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const AutoSizeText(
            ':',
            minFontSize: 12.0,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: AutoSizeText(
              value,
              minFontSize: 12.0,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
