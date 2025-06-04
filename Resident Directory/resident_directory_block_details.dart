import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/Resident%20Directory/resident_inapp_calling.dart';
import 'package:biz_infra/Screens/Resident%20Directory/resident_inapp_messaging.dart';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CustomWidgets/configurable_widgets.dart';

class ResidentDirectoryBlockDetails extends StatefulWidget {
  final String blockName;

  const ResidentDirectoryBlockDetails({required this.blockName, super.key});

  @override
  State<ResidentDirectoryBlockDetails> createState() => _ResidentDirectoryBlockDetailsState();
}

class _ResidentDirectoryBlockDetailsState extends State<ResidentDirectoryBlockDetails> {

  final Set<String> _blockedUsers = {};

  Future<bool> _showBlockConfirmationDialog(String memberName) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const AutoSizeText('Confirm Block'),
          content: AutoSizeText('Are you sure you want to block $memberName?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const AutoSizeText('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const AutoSizeText('Yes'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Future<bool> _showUnblockConfirmationDialog(String memberName) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const AutoSizeText('Confirm Unblock'),
          content: AutoSizeText('Are you sure you want to unblock $memberName?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const AutoSizeText('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const AutoSizeText('Yes'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Future<bool> _showSaveConfirmationDialog(String memberName) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const AutoSizeText('Saving Contact'),
          content: AutoSizeText('Do you want to save $memberName to your phonebook?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const AutoSizeText('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const AutoSizeText('Yes'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Future<void> _showCallConfirmationDialog(String memberName) async {
    bool shouldCall = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const AutoSizeText('Confirm Call'),
          content: AutoSizeText('Do you want to call $memberName?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const AutoSizeText('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const AutoSizeText('Yes'),
            ),
          ],
        );
      },
    ) ?? false;

    if (shouldCall) {
      Get.to(() => ResidentInAppCalling(residentName: memberName));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("Residents of ${widget.blockName}"),
      ),
        body: SingleChildScrollView(
          child:  widget.blockName == "Common Area"?
          FutureBuilder(
            future:
            dioServiceClient.getEmployeeRegistrationList(page: 1),
            builder: (context, snapshot) {
              // First check if the snapshot has data
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomLoader());
              }
              if (snapshot.hasError) {
                return Center(child: AutoSizeText('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data!.records!.isEmpty) {
                return const Center(child: AutoSizeText("Record is Empty"));
              } else {
                var societyBlockData = snapshot.data!;
                var totalEmployee = societyBlockData.data?.records?.groupBy((x) => x.serviceEngineerName).toList();

                if (totalEmployee == null || totalEmployee.isEmpty) {
                  return const Center(child: AutoSizeText("No residents available"));
                }

                return Column(
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.all(15),
                    //   // color: const Color(0xffcbe3dd),
                    //   child: const Row(
                    //     children: [
                    //       Icon(Icons.call),
                    //       SizedBox(width: 10),
                    //       Expanded(
                    //         child: AutoSizeText(
                    //             "Introducing Free Society intercom for in-App calling to connect your society"),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: totalEmployee.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  totalEmployee[index].key.toString(),
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: totalEmployee[index].elements.length,
                                          itemBuilder: (BuildContext context, int memberIndex) {
                                            var currentMember = totalEmployee[index].elements[memberIndex];
                                            final memberName = currentMember.serviceEngineerName.toString();
                                            final isBlocked = _blockedUsers.contains(memberName);

                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(currentMember.docUrl.toString()),
                                                    radius: 25,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        AutoSizeText(currentMember.subServiceManagerRole.toString(),
                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        AutoSizeText(currentMember.empBlock.toString()),
                                                      ],
                                                    ),
                                                  ),
                                                  if (!isBlocked) ...[
                                                    IconButton(
                                                      icon: const Icon(Icons.message),
                                                      onPressed: () {
                                                        Get.to(() => ResidentInAppMessaging(
                                                          residentName: currentMember.serviceEngineerName.toString(),
                                                        ));
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons.phone),
                                                      onPressed: () {
                                                        _showCallConfirmationDialog(currentMember.phone.toString());
                                                      },
                                                    ),
                                                  ] else ...[
                                                    const IconButton(
                                                      icon: Icon(Icons.message, color: Colors.grey),
                                                      onPressed: null,
                                                    ),
                                                    const IconButton(
                                                      icon: Icon(Icons.phone, color: Colors.grey),
                                                      onPressed: null,
                                                    ),
                                                  ],
                                                  PopupMenuButton<String>(
                                                    position: PopupMenuPosition.under,
                                                    onSelected: (String result) async {
                                                      if (result == 'block') {
                                                        bool shouldBlock = await _showBlockConfirmationDialog(memberName);
                                                        if (shouldBlock) {
                                                          setState(() {
                                                            _blockedUsers.add(memberName);
                                                          });
                                                          snackBarMessenger('User Blocked');
                                                        }
                                                      } else if (result == 'unblock') {
                                                        bool shouldUnblock = await _showUnblockConfirmationDialog(memberName);
                                                        if (shouldUnblock) {
                                                          setState(() {
                                                            _blockedUsers.remove(memberName);
                                                          });
                                                          snackBarMessenger('User Unblocked');
                                                        }
                                                      } else if (result == 'save') {
                                                        bool shouldSave = await _showSaveConfirmationDialog(memberName);
                                                        if (shouldSave) {
                                                          snackBarMessenger('Saved to Phonebook');
                                                        }
                                                      }
                                                    },
                                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                                      if (isBlocked) ...[
                                                        const PopupMenuItem<String>(
                                                          value: 'unblock',
                                                          child: AutoSizeText('Unblock User'),
                                                        ),
                                                      ] else ...[
                                                        const PopupMenuItem<String>(
                                                          value: 'block',
                                                          child: AutoSizeText('Block User'),
                                                        ),
                                                      ],
                                                      const PopupMenuItem<String>(
                                                        value: 'save',
                                                        child: AutoSizeText('Save to Phonebook'),
                                                      ),
                                                    ],
                                                    icon: const Icon(Icons.more_vert),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
            },
          ):

          FutureBuilder(
            future:
            dioServiceClient.getSelectedResidentDirectory(selectBlock: widget.blockName),
            builder: (context, snapshot) {
              // First check if the snapshot has data
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CustomLoader());
              }
              if (snapshot.hasError) {
                return Center(child: AutoSizeText('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data!.records!.isEmpty) {
                return const Center(child: AutoSizeText("Record is Empty"));
              } else {
                var societyBlockData = snapshot.data!;
                var totalResident = societyBlockData.data?.records?.groupBy((x) => x.soceityNumber).toList();

                if (totalResident == null || totalResident.isEmpty) {
                  return const Center(child: AutoSizeText("No residents available"));
                }

                return Column(
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.all(15),
                    //   // color: const Color(0xffcbe3dd),
                    //   child: const Row(
                    //     children: [
                    //       Icon(Icons.call),
                    //       SizedBox(width: 10),
                    //       Expanded(
                    //         child: AutoSizeText(
                    //             "Introducing Free Society intercom for in-App calling to connect your society"),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: totalResident.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  totalResident[index].key.toString(),
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        const SizedBox(height: 10),
                                        ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: totalResident[index].elements.length,
                                          itemBuilder: (BuildContext context, int memberIndex) {
                                            var currentMember = totalResident[index].elements[memberIndex];
                                            final memberName = currentMember.residentName.toString();
                                            final isBlocked = _blockedUsers.contains(memberName);

                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  const CircleAvatar(
                                                    backgroundImage: AssetImage('assets/images/user.png'),
                                                    radius: 25,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      AutoSizeText(currentMember.residentName.toString(),
                                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      AutoSizeText(currentMember.typeResident.toString()),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  if (!isBlocked) ...[
                                                    IconButton(
                                                      icon: const Icon(Icons.message),
                                                      onPressed: () {
                                                        Get.to(() => ResidentInAppMessaging(
                                                          residentName: currentMember.residentName.toString(),
                                                        ));
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons.phone),
                                                      onPressed: () {
                                                        _showCallConfirmationDialog(currentMember.mobile.toString());
                                                      },
                                                    ),
                                                  ] else ...[
                                                    const IconButton(
                                                      icon: Icon(Icons.message, color: Colors.grey),
                                                      onPressed: null,
                                                    ),
                                                    const IconButton(
                                                      icon: Icon(Icons.phone, color: Colors.grey),
                                                      onPressed: null,
                                                    ),
                                                  ],
                                                  PopupMenuButton<String>(
                                                    position: PopupMenuPosition.under,
                                                    onSelected: (String result) async {
                                                      if (result == 'block') {
                                                        bool shouldBlock = await _showBlockConfirmationDialog(memberName);
                                                        if (shouldBlock) {
                                                          setState(() {
                                                            _blockedUsers.add(memberName);
                                                          });
                                                          snackBarMessenger('User Blocked');
                                                        }
                                                      } else if (result == 'unblock') {
                                                        bool shouldUnblock = await _showUnblockConfirmationDialog(memberName);
                                                        if (shouldUnblock) {
                                                          setState(() {
                                                            _blockedUsers.remove(memberName);
                                                          });
                                                          snackBarMessenger('User Unblocked');
                                                        }
                                                      } else if (result == 'save') {
                                                        bool shouldSave = await _showSaveConfirmationDialog(memberName);
                                                        if (shouldSave) {
                                                          snackBarMessenger('Saved to Phonebook');
                                                        }
                                                      }
                                                    },
                                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                                      if (isBlocked) ...[
                                                        const PopupMenuItem<String>(
                                                          value: 'unblock',
                                                          child: AutoSizeText('Unblock User'),
                                                        ),
                                                      ] else ...[
                                                        const PopupMenuItem<String>(
                                                          value: 'block',
                                                          child: AutoSizeText('Block User'),
                                                        ),
                                                      ],
                                                      const PopupMenuItem<String>(
                                                        value: 'save',
                                                        child: AutoSizeText('Save to Phonebook'),
                                                      ),
                                                    ],
                                                    icon: const Icon(Icons.more_vert),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ),

    );
  }
}
