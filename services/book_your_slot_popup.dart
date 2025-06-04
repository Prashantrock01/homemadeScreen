import 'package:flutter/material.dart';

class BookSlotPopup extends StatelessWidget {
  const BookSlotPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Choose Address',
                    style: TextStyle(
                      fontSize: screenWidth *
                          0.04, // Adjust font size relative to screen width
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                        color: Colors.blue, fontSize: screenWidth * 0.04),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Image.asset(
                'assets/images/location32.png',
                width:
                    screenWidth * 0.08, // Adjust width relative to screen width
                height: screenWidth *
                    0.06, // Adjust height relative to screen width
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A-402',
                      style: TextStyle(
                        fontSize: screenWidth *
                            0.03, // Adjust font size relative to screen width
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'A-402 Pride Pegasus, Pride Pegasus, Bangalore',
                      style: TextStyle(
                        fontSize: screenWidth *
                            0.025, // Adjust font size relative to screen width
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset(
                'assets/images/add32.png',
                width:
                    screenWidth * 0.06, // Adjust width relative to screen width
              ),
              TextButton(
                onPressed: () {
                  // Code to add a new address
                },
                child: Text(
                  'Add New Address',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: screenWidth *
                        0.03, // Adjust font size relative to screen width
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
