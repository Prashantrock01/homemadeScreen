import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';

class OrderSummary extends StatefulWidget {
  const OrderSummary({super.key});

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Summary',
          style: TextStyle(fontSize: 18.0),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _package(
              title: 'Sleek-Honey Wax Stomach waxing',
              price: 379,
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Card(
                // color: Colors.black,
                margin: const EdgeInsets.all(5.0),
                elevation: 5.0,
                child: Column(
                  children: <Widget>[
                    vipMembershipTile(),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: <Widget>[
                          customCard(
                            extraText: 'EXTRA',
                            discountText: '15 % Discount',
                            descriptionText: 'On Bizinfa home\nservices',
                            imagePath: 'assets/order_summary/painter.png',
                          ),
                          customCard(
                            extraText: 'EXTRA',
                            discountText: '15 % Discount',
                            descriptionText: 'On Bizinfa home\nservices',
                            imagePath: 'assets/order_summary/painter.png',
                          ),
                          customCard(
                            extraText: 'EXTRA',
                            discountText: '15 % Discount',
                            descriptionText: 'On Bizinfa home\nservices',
                            imagePath: 'assets/order_summary/painter.png',
                          ),
                          customCard(
                            extraText: 'EXTRA',
                            discountText: '15 % Discount',
                            descriptionText: 'On Bizinfa home\nservices',
                            imagePath: 'assets/order_summary/painter.png',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.amber,
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Service Details',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  customListTile(
                    icon: Icons.location_pin,
                    title: 'A-402 Pride Pegasus, Pride Pegasus, Bangalore',
                  ),
                  customListTile(
                    icon: Icons.calendar_month,
                    title: 'August 7th 2024, 9:00 AM',
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Payment Summary',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    elevation: 5.0,
                    margin: const EdgeInsets.all(10.0),
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Divider(
                            color: Colors.grey,
                            thickness: 2.0,
                          ),
                          keyValueWidget('Total Amount', '\u{20B9}${230}'),
                          keyValueWidget('VIP Membership', '\u{20B9}${230}'),
                          keyValueWidget(
                              'Taxes and other changes', '\u{20B9}${230}'),
                          keyValueWidget('VIP Discount', '\u{20B9}${230}'),
                          keyValueWidget('Amount Payable', '\u{20B9}${230}'),
                          summaryListTile(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            customSmallButton(
              buttonText: 'Pay Later',
              onPressed: () {},
              backgroundColor: Colors.white,
              borderColor: Colors.green,
              fontSize: 15,
              borderWidth: 1.0,
            ),
            customSmallButton(
              buttonText: 'Pay Now | \u{20B9}${704}',
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  sheetAnimationStyle: AnimationStyle(
                    duration: const Duration(
                      seconds: 2,
                    ),
                  ),
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              title: Text(
                                'You are missing out on discount of \u{20B9}${704}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                'Customers save upto \u{20B9}${3500} with VIP membership',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Skip',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                            customElevatedButton(
                              fontSize: 15,
                              textColor: Colors.white,
                              backgroundColor: Colors.green,
                              text: 'Add Vip Membership',
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              backgroundColor: const Color.fromARGB(255, 11, 185, 101),
              borderColor: Colors.transparent,
              fontSize: 15,
              borderWidth: 0,
            )
          ],
        ),
      ),
    );
  }

  Widget _package({required String title, required int price}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Packages',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            elevation: 5.0,
            margin: const EdgeInsets.all(5.0),
            child: ListTile(
              leading: Image.asset(
                'assets/order_summary/hair_wash.png',
                height: 40,
              ),
              title: Text(
                title,
                maxLines: 2,
                style: const TextStyle(fontSize: 14.0),
              ),
              subtitle: Text(
                '\u{20B9}$price',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget vipMembershipTile() {
    return ListTile(
      leading: Image.asset(
        'assets/order_summary/vip.png',
        height: 40,
        color: const Color.fromARGB(255, 230, 175, 10),
      ),
      title: const Text(
        'VIP MEMBERSHIP',
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
      subtitle: const Text.rich(
        TextSpan(
          text: '\u{20B9}199 ', // Default text style
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          children: <TextSpan>[
            TextSpan(
              text: '\u{20B9}599',
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.white),
            ),
            TextSpan(
              text: ' for 6 months',
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      trailing: customSmallButton(
        buttonText: 'REMOVE',
        onPressed: () {},
        backgroundColor: Colors.white,
        borderColor: Colors.black,
        borderWidth: 1.0,
      ),
    );
  }

  Widget customCard({
    required String extraText,
    required String discountText,
    required String descriptionText,
    required String imagePath,
  }) {
    return Card(
      elevation: 5.0,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              extraText,
              style: const TextStyle(
                fontSize: 10.0,
                color: Color.fromARGB(255, 226, 171, 5),
              ),
            ),
            Text(
              discountText,
              style: const TextStyle(
                fontSize: 18.0,
                color: Color.fromARGB(255, 226, 171, 5),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              descriptionText,
              style: const TextStyle(fontSize: 12.0),
            ),
            Center(
              child: Image.asset(
                imagePath,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customSmallButton({
    required String buttonText,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color borderColor,
    double? fontSize,
    required double borderWidth,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: const Size(60, 30),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: borderColor,
            width: borderWidth,
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }

  Widget customEditButton({
    required String buttonText,
    required VoidCallback onPressed,
    required Color borderColor,
    required double borderWidth,
    required IconData icon,
  }) {
    return TextButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(60, 30),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      ),
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18.0,
      ),
      iconAlignment: IconAlignment.end,
      label: Text(buttonText),
    );
  }

  Widget customListTile({
    required IconData icon,
    required String title,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.purple,
      ),
      title: const Text(
        'A-402 Pride Pegasus, Pride Pegasus, Bangalore',
        style: TextStyle(fontSize: 10, color: Colors.black),
      ),
      trailing: customEditButton(
        icon: Icons.edit,
        buttonText: 'Edit',
        onPressed: () {},
        borderColor: Colors.black,
        borderWidth: 1.0,
      ),
    );
  }

  Widget keyValueWidget(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 5,
          child: AutoSizeText(
            key,
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: const TextStyle(
                color: Constants.secondaryTextWhite,
                fontSize: 10.0,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          flex: 4,
          child: AutoSizeText(
            value,
            //maxLines: 3,
            minFontSize: 14.0,
            overflow: TextOverflow.fade,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.normal),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(height: 20.0)
      ],
    );
  }

  Widget summaryListTile() {
    return ListTile(
      leading: Image.asset(
        'assets/order_summary/vip.png',
        height: 40,
        color: const Color.fromARGB(255, 230, 175, 10),
      ),
      title: const Text(
        'Savings \u{20B9}${56} on this order with VIP membership',
        style: TextStyle(fontSize: 8, color: Constants.primaryTextWhite),
      ),
      trailing: customSmallButton(
        buttonText: 'REMOVE',
        onPressed: () {},
        backgroundColor: Colors.white,
        borderColor: Colors.black,
        borderWidth: 1.0,
      ),
      tileColor: Constants.secondaryTextWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Optional: Rounded corners
      ),
    );
  }
}
