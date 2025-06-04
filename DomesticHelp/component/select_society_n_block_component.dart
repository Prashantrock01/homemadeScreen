import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Model/DomesticHelp/DomesticBlockModel.dart';
import '../../../Model/DomesticHelp/domestic_help_society_model.dart';
import '../../../Network/dio_service_client.dart';
import '../../../Utils/app_styles.dart';
import '../../../Utils/common_widget.dart';
import '../../../Utils/constants.dart';

class SelectSocietyNBlockComponent extends StatefulWidget {
  const SelectSocietyNBlockComponent({super.key});

  @override
  _SelectSocietyNBlockComponentState createState() => _SelectSocietyNBlockComponentState();
}

class _SelectSocietyNBlockComponentState extends State<SelectSocietyNBlockComponent> {
  String? selectedBlock;
  String? selectedSocietyNo;

  List<String> blockList = [];
  List<String> societyNoList = [];

  bool? isLoading = false;

  @override
  void initState() {
    super.initState();

    getDomesticHelpSociety();
    getDomesticHelpBlock();
  }

  getDomesticHelpSociety() async {
    try {
      isLoading = true;
      setState(() {});
      DomesticSocietyModel? response = await dioServiceClient.getDomesticHelpSocietyApi();
      if (response!.statuscode == 1) {
        if (response.data!.domhelpSociety != null) {
          for (var e in response.data!.domhelpSociety!) {
            societyNoList.add(e.domhelpSociety.toString());
            setState(() {});
          }
        }
      }
    } catch (e) {
      return e;
    }
  }

  getDomesticHelpBlock() async {
    try {
      DomesticBlockModel? response = await dioServiceClient.getDomesticHelpBlockApi();
      if (response!.statuscode == 1) {
        if (response.data!.domhelpBlock != null) {
          for (var e in response.data!.domhelpBlock!) {
            blockList.add(e.domhelpBlock.toString());
            setState(() {});
          }
        }
      }
    } catch (e) {
      return e;
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Block and Society"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            isDense: true,
            hint: const Text('Block', style: Styles.hintText),
            decoration: defaultInputDecoration(prefixIcon: Icons.home_work_outlined, radius: 16),
            value: selectedBlock,
            onChanged: (e) {
              selectedBlock = e;
              setState(() {});
            },
            validator: (value) {
              if ((value ?? '').trim().isEmpty) {
                return 'Please select Block';
              }
              return null;
            },
            items: blockList
                .map<DropdownMenuItem<String>>(
                  (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            isDense: true,
            hint: const Text('Society No', style: Styles.hintText),
            decoration: defaultInputDecoration(prefixIcon: Icons.numbers_outlined, radius: 16),
            value: selectedSocietyNo,
            onChanged: (e) {
              selectedSocietyNo = e;
              setState(() {});
            },
            items: societyNoList
                .map<DropdownMenuItem<String>>(
                  (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(side: BorderSide(width: 1, color: Get.iconColor!), borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            foregroundColor: Get.iconColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Constants.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (selectedBlock != null && selectedSocietyNo != null) {
              Navigator.pop(context, {
                'selectedBlock': selectedBlock,
                'selectedSocietyNo': selectedSocietyNo,
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select both Block and Society')));
            }
          },
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
