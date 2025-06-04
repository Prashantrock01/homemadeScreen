import 'package:biz_infra/Controller/DomesticHelpController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../Network/dio_service_client.dart';
import '../../../Utils/app_styles.dart';

class DomesticTypeListFilterComponent extends StatelessWidget {
  final bool? isAllHelper;

  const DomesticTypeListFilterComponent({super.key, this.isAllHelper = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.put(DomesticHelpController()),
        builder: (domesticHelpController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("All New Service", style: Styles.textLargeBoldLabel),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                            domesticHelpController.page = 1;
                            domesticHelpController.onListRefresh();
                          },
                          child: const Text('Reset', style: Styles.textBoldLabel),
                        ),
                        const CloseButton(),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: FutureBuilder(
                      future: dioServiceClient.getDomesticHelpTypeApi(),
                      builder: (context, snap) {
                        if (snap.hasData && snap.data != null) {
                          if (snap.data!.data!.domhelpType != null) {
                            return ListView.separated(
                                shrinkWrap: true,
                                itemCount: snap.data!.data!.domhelpType!.length,
                                separatorBuilder: (c, i) {
                                  return const Divider(height: 26);
                                },
                                itemBuilder: (context, serviceIndex) {
                                  return GestureDetector(
                                    onTap: () async {
                                      domesticHelpController.filterString = snap.data!.data!.domhelpType![serviceIndex].domhelpType;
                                      EasyLoading.show();
                                      Get.back();
                                      domesticHelpController.page = 1;
                                      domesticHelpController.domesticHelperList.clear();
                                      await domesticHelpController.getFilterListApiCall(filterString: domesticHelpController.filterString);
                                      EasyLoading.dismiss();
                                    },
                                    child: Text(
                                      snap.data!.data!.domhelpType![serviceIndex].domhelpType.toString(),
                                      style: Styles.textHeadLabel,
                                      textAlign: TextAlign.start,
                                    ),
                                  );
                                });
                          } else {
                            return const Text('No Domestic helper found');
                          }
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      }),
                )
              ],
            ),
          );
        });
  }
}
