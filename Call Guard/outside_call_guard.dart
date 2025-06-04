import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:flutter/material.dart';

class OutsideCallGuard extends StatefulWidget {
  const OutsideCallGuard({super.key});

  @override
  State<OutsideCallGuard> createState() => _OutsideCallGuardState();
}

class _OutsideCallGuardState extends State<OutsideCallGuard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: dioServiceClient.getCallGuardList(page: 1),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.data != null) {
            var records = snapshot.data!.data!.records ?? [];
            return ListView.builder(
              itemCount: records.length,
              itemBuilder: (BuildContext context, int index) {
                var record = records[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: Row(
                        children: [
                          Image.asset("assets/images/call_guard.png", height: 30,),
                          const SizedBox(width: 30),
                          Text(record.guarddirName ?? ""),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }

}
