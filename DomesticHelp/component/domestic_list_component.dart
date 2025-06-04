import 'dart:developer';

import 'package:biz_infra/Controller/DomesticHelpController.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../CustomWidgets/CustomLoaders/custom_loader.dart';
import '../domestic_help_creation.dart';
import 'domestic_help_component.dart';
import 'my_domestic_helper_component.dart';

class DomesticListComponent extends StatelessWidget {
  final bool? isAllHelper;
  final VoidCallback? onBackCall;

  const DomesticListComponent({super.key, this.isAllHelper = false, this.onBackCall});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        initState: (state) => DomesticHelpController(),
        init: Get.put(DomesticHelpController()),
        builder: (domesticHelpController) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () {
                if (isAllHelper == true) {
                  domesticHelpController.onListRefresh(isAllHelper: true);
                } else {
                  domesticHelpController.onListRefresh(isAllHelper: false);
                }
                return Future.value();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(), // Ensures the list can be pulled down
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (domesticHelpController.showProgress.isTrue || domesticHelpController.myServiceShowProgress.isTrue)
                      SizedBox(height: MediaQuery.of(context).size.height * 0.6, child: const Center(child: CustomLoader()))
                    else if (isAllHelper == true)
                      domesticHelpController.domesticHelperList.isNotEmpty
                          ? ListView.builder(
                              controller: domesticHelpController.scrollController,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: domesticHelpController.domesticHelperList.length,
                              padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 60),
                              itemBuilder: (c, i) {
                                return DomesticHelpComponent(
                                  domesticHelper: domesticHelpController.domesticHelperList[i],
                                  onDeleteCall: () => domesticHelpController.onListRefresh(isAllHelper: true),
                                  onEditCall: () => domesticHelpController.onListRefresh(isAllHelper: true),
                                  onAddTFlatCall: () {
                                    if (Constants.userRole == Constants.owner || Constants.userRole == Constants.tenant) {
                                      onBackCall!();
                                      domesticHelpController.onListRefresh(isAllHelper: false);
                                    }
                                    domesticHelpController.onListRefresh(isAllHelper: true);
                                  },
                                );
                              },
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: const Center(child: Text('Domestic helper list is empty')),
                            )
                    else
                      domesticHelpController.domesticMyServiceHelperList.isNotEmpty
                          ? ListView.builder(
                              controller: domesticHelpController.myServiceScrollController,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: domesticHelpController.domesticMyServiceHelperList.length,
                              padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 60),
                              itemBuilder: (c, i) {
                                return MyDomesticHelperComponent(
                                  domesticHelper: domesticHelpController.domesticMyServiceHelperList[i],
                                  onDeleteCall: () => domesticHelpController.onListRefresh(bothList: true),
                                );
                              },
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.65,
                              child: const Center(child: Text(' Your Domestic helper list is empty')),
                            ),
                    Visibility(
                      visible: isAllHelper == true ? domesticHelpController.isMoreLoading.isTrue : domesticHelpController.isMoreMySLoading.isTrue,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Center(
                          child: CircularProgressIndicator(backgroundColor: Colors.transparent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: isAllHelper == true && Constants.userRole == Constants.securitySupervisor
                ? FloatingActionButton(
                    onPressed: () async {
                      bool? res = await Get.to(DomesticHelpCreation());
                      if (res == true) domesticHelpController.onListRefresh(isAllHelper: true);
                    },
                    child: Icon(Icons.person, color: Get.iconColor),
                  )
                : const SizedBox(),
          );
        });
  }
}
