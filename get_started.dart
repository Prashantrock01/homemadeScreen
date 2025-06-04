import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../company_code.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF8B8B8B),

              Color(0xFFD1B572),
              Color(0xFF8B6F4A),
              Color(0xFF8B8B8B),

            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            /// **Main Content - Stays Centered**
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(70),
                          child: Image.asset(
                            'assets/images/untitled_design.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Welcome to Infra Eye',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: AutoSizeText(
                        'Everything you need, right at your fingertips! \nBy tapping ‘Get Started,’ you agree to the \n Terms & Conditions',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    textButton(
                      widget: const Text('Get Started'),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                        padding: WidgetStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        minimumSize: WidgetStateProperty.all<Size>(
                          Size(MediaQuery.of(context).size.width / 1.5, 45),
                        ),
                        elevation: WidgetStateProperty.all<double>(5),

                      ),
                      onPressed: () {
                        Get.to(
                              () => const CompanyCode(),
                          transition: Transition.rightToLeft,
                          popGesture: true,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            /// **Terms & Condition at the Bottom**
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: ()=> launchExternalWebsite(Uri.parse('https://bizinfratech.in/terms-and-conditions')),
                      child: const AutoSizeText(
                        'Terms & Condition',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 15,
                      width: 2,
                      color: Colors.white, // Vertical line
                    ),
                    GestureDetector(
                      onTap: ()=> launchExternalWebsite(Uri.parse('https://bizinfratech.in/privacy-policy')),
                      child: const AutoSizeText(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
