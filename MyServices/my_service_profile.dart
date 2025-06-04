import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyServiceProfile extends StatefulWidget {

  final String name;
  final String serviceType;
  final String serviceTime;
  final String serviceTakenBy;

  const MyServiceProfile({required this.name, required this.serviceType, required this.serviceTime, required this.serviceTakenBy, super.key});

  @override
  State<MyServiceProfile> createState() => _MyServiceProfileState();
}

class _MyServiceProfileState extends State<MyServiceProfile> {
  List<String> serviceTakenBYOtherFlats = ["B-105", "A-103"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*elevation: 5,*/
        title: const Text("Profile"),
      ),
      body: /*GradientBackground(
        child:*/ SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
            Row(
              children: [
                Image.asset(
                  'assets/home/my_services.png',
                  height: 60,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold)),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Text(widget.serviceType, style: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.schedule),
                        const SizedBox(width: 10),
                        Text(widget.serviceTime),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.home_outlined),
                        const SizedBox(width: 10),
                        Text(widget.serviceTakenBy),
                        const SizedBox(width: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButton<String>(
                              value: null,
                              hint: Text('${serviceTakenBYOtherFlats.length} more flats'),
                              items: serviceTakenBYOtherFlats.map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                              onChanged: (value) {},
                              isExpanded: false,
                              icon: const Icon(Icons.arrow_drop_down),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

                const Divider(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.card_membership),
                    SizedBox(width: 5,),
                    Text("Gate Pass"),
                    Spacer(),
                    Icon(Icons.call),
                    SizedBox(width: 5,),
                    Text("Call"),
                    Spacer(),
                    Icon(Icons.share),
                    SizedBox(width: 5,),
                    Text("Share"),
                  ],
                ),

                const SizedBox(height: 30,),
                const Divider(/*color: Colors.black,*/ thickness: 0.7,),
                const SizedBox(height: 30,),

                TableCalendar(
                  firstDay: DateTime.utc(2020, 01, 01),
                  lastDay: DateTime.now(),
                  focusedDay: DateTime.now(),
                ),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      /*),*/
    );
  }
}
