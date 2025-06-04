import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:flutter/material.dart';

class BillAndPayment extends StatefulWidget {
  const BillAndPayment({super.key});

  @override
  State<BillAndPayment> createState() => _BillAndPaymentState();
}

class _BillAndPaymentState extends State<BillAndPayment> {
  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF6D8),
              Color(0xFFFFFFFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: topPadding + 39),
                    Center(
                      child: Image.asset(
                        'assets/images/logo.webp',
                        width: screenWidth * 0.25,
                        height: screenHeight * 0.15,
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/bill.png',
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.4,
                      ),
                    ),
                    const Text(
                      'Bills and Payments',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5D5D5D),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'View and pay your maintenance, electricity and utilities bills from apps.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5D5D5D),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: customElevatedButton(
                          text: 'Get Started',
                          onPressed: () {},
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      title: const Text(
                        'By clicking Get Started, you agree to the',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5D5D5D),
                        ),
                      ),
                      subtitle: Center(
                        child: InkWell(
                          onTap: () {
                            // Handle the press for terms and conditions here
                          },
                          child: const Text(
                            'Terms and Conditions',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5D5D5D),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: topPadding + 10,
                  left: 5,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Color(0xFFF7C51E)),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
