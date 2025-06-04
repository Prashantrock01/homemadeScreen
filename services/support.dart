import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  ValueNotifier<String> selectedCityNotifier = ValueNotifier('Select City');

  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    // Add listener to detect focus changes
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Clean up the focus node when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        backgroundColor: Colors.transparent,
        title: const Text(
          'Bizinfra Support & Help',
          style: TextStyle(fontSize: 14, color: Constants.secondaryTextWhite),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customTextField(
              hintText: "Search for an article/help...",
              prefixIcon: Icons.search,
              prefixIconPressed: () {},
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(bottom: 10.0),
              child: const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Browse Topics',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: media.size.height * 0.6,
                  child: GridView.count(
                    physics: const AlwaysScrollableScrollPhysics(),
                    primary: false,
                    crossAxisCount: 4,
                    crossAxisSpacing: 6.0,
                    mainAxisSpacing: 20.0,
                    children: <Widget>[
                      _buildWithText(
                        'assets/support/user_registration.png',
                        'User\nregistration',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/post_property.png',
                        'Post / Remove &\na property',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/pay.png',
                        'Bizinfra Pay',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/packers.png',
                        'Packers &\nMovers',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/rental.png',
                        'Rental\nAgreement',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/unsubscribe.png',
                        'Unsubscribe',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/utility_payment.png',
                        'Utility\nPayments',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/painting.png',
                        'Painting',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/cleaning.png',
                        'Cleaning',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/ac_services.png',
                        'AC Services',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/furniture.png',
                        'Furniture',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/painting.png',
                        'School Fee\nPayments',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/owner.png',
                        'Owner',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/seller.png',
                        'Seller',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/tenant.png',
                        'Tenant',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/buyer.png',
                        'Buyer',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/interiors.png',
                        'Interiors &\nRenovations',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/property_management.png',
                        'Comprehensive\nProperty\nManagement\nSystem',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/legal_services.png',
                        'Legal Services',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/loan_services.png',
                        'Loan Services',
                        () {},
                      ),
                      _buildWithText(
                        'assets/support/plumbing.png',
                        'Plumbing/Electrician/\nCarpentary',
                        () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget customTextField({
    required String hintText,
    required IconData prefixIcon,
    VoidCallback? prefixIconPressed,
  }) {
    return TextField(
      focusNode: _focusNode,
      showCursor: _isFocused,
      cursorOpacityAnimates: true,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10.0),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 15.0),
          prefixIcon: IconButton(
            onPressed: prefixIconPressed,
            icon: Icon(
              prefixIcon,
              color: Colors.grey,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 236, 230, 230)),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildWithText(String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            imagePath,
            height: 40,
            color: const Color.fromARGB(255, 247, 196, 12),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              maxLines: 5,
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class CitySelectionSimpleDialog extends StatelessWidget {
  final List<Map<String, String>> cities = [
    {'name': 'Bangalore', 'imageUrl': 'assets/city/banglore.png'},
    {'name': 'Mumbai', 'imageUrl': 'assets/city/mumbai.png'},
    {'name': 'Chennai', 'imageUrl': 'assets/city/chennai.png'},
    {'name': 'Pune', 'imageUrl': 'assets/city/pune.png'},
    {'name': 'Hyderabad', 'imageUrl': 'assets/city/hyderabad.png'},
    {'name': 'Gurugram', 'imageUrl': 'assets/city/gurugram.png'},
    {'name': 'Delhi', 'imageUrl': 'assets/city/delhi.png'},
    {'name': 'Noida', 'imageUrl': 'assets/city/noida.png'},
    {'name': 'Greater Noida', 'imageUrl': 'assets/city/noida.png'},
    {'name': 'Ghaziabad', 'imageUrl': 'assets/city/ghaziabad.png'},
    {'name': 'Faridabad', 'imageUrl': 'assets/city/faridabad.png'},
    {'name': 'Ahmedabad', 'imageUrl': 'assets/city/ahmedabad.png'},
  ];

  final void Function(String) onCitySelected;

  CitySelectionSimpleDialog({required this.onCitySelected, super.key});

  final ScrollController _firstController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Text(
        'Select City',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
      children: [
        SizedBox(
          height: 340, // Adjust height as needed
          child: Scrollbar(
            controller: _firstController,
            thumbVisibility: true,
            thickness: 5.0,
            child: GridView.builder(
              controller: _firstController,
              shrinkWrap: true,
              itemCount: cities.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    onCitySelected(cities[index]['name']!);
                  },
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          cities[index]['imageUrl']!,
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/placeholder.png',
                              width: 60.0,
                              height: 60.0,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Flexible(
                        child: Text(
                          cities[index]['name']!,
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
