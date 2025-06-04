import 'package:biz_infra/Screens/services/services_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'book_your_slot_popup.dart';

class BookYourSlot extends StatefulWidget {
  const BookYourSlot({super.key});

  @override
  State<BookYourSlot> createState() => _BookYourSlotState();
}

class _BookYourSlotState extends State<BookYourSlot> {
  String _selectedDate = '05\nTODAY';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Your Slot',
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7C51E), Colors.white, Color(0xFFF6CEFF)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Divider(
              color: Colors.white,
              thickness: 1.0,
              height: 1.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select a Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildDateButton('05\nTODAY'),
                                _buildDateButton('06\nTOMORROW'),
                                _buildDateButton('07\nWED'),
                                _buildDateButton('PIC DATE',
                                    icon: Icons.calendar_today),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Start Time',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _buildTimeSection('Morning', [
                            '9:00AM-9:30AM',
                            '9:30AM-10:00AM',
                            '10:00AM-10:30AM',
                            '10:30AM-11:00AM',
                            '11:00AM-11:30AM',
                            '11:30AM-12:00AM',
                          ]),
                          _buildTimeSection('Afternoon', [
                            '12:00PM-12:30PM',
                            '12:30PM-1:00PM',
                            '1:00PM-1:30PM',
                            '1:30PM-2:00PM',
                            '2:00PM-2:30PM',
                            '2:30PM-3:00PM',
                            '3:00PM-3:30PM',
                            '3:30PM-4:00PM',
                            '4:00PM-4:30PM',
                            '4:30PM-5:00PM',
                            '5:00PM-5:30PM',
                          ]),
                          _buildTimeSection('Evening', [
                            '6:00PM-6:30PM',
                            '6:30PM-7:00PM',
                            '7:00PM-7:30PM',
                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/location33.png',
                          width: 25, // Set the desired width
                          height: 25, // Set the desired height
                        ),
                        const SizedBox(width: 8.0),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'A-402',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'A-402 Pride Pegasus, Pride Pegasus, Bangalore',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // handle change address
                            Get.to(
                              () => const ServiceBottomNavBar(),
                              transition: Transition.rightToLeft,
                              popGesture: true,
                            );
                          },
                          child: const Text(
                            'Change',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Container(
                    padding:
                        const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(0.0),
                            ),
                          ),
                          builder: (context) => const BookSlotPopup(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: const Text(
                        'Book Slot',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton(String text, {IconData? icon}) {
    bool isSelected =
        _selectedDate == text || (icon != null && _selectedDate == 'PIC DATE');

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 13.0,
                color: isSelected
                    ? Colors.white
                    : const Color.fromARGB(255, 12, 84, 121),
              ),
            if (icon == null) ...[
              Text(
                text.split('\n')[0],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
              Text(
                text.split('\n')[1],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (icon != null)
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSection(String title, List<String> times) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.access_time,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 5,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemCount: times.length,
          itemBuilder: (context, index) {
            return _buildTimeButton(times[index]);
          },
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildTimeButton(String time, {bool isLast = false}) {
    return OutlinedButton(
      onPressed: () {
        // handle time selection
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: isLast
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )
              : BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        time,
        style: const TextStyle(color: Colors.black, fontSize: 10.0),
      ),
    );
  }
}
