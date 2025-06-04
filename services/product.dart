import 'package:flutter/material.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/biz_infra.png',
              height: 30,
            ),
            const Text.rich(
              TextSpan(
                text: 'Biz',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'infra ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              onPressed: () async {
                String? result = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return CitySelectionSimpleDialog(
                      onCitySelected: (String cityName) {
                        Navigator.pop(context, cityName);
                      },
                    );
                  },
                );

                if (result != null && result.isNotEmpty) {
                  selectedCityNotifier.value = result;
                }
              },
              child: ValueListenableBuilder<String>(
                valueListenable: selectedCityNotifier,
                builder: (context, selectedCity, _) {
                  return Row(
                    children: [
                      Text(
                        selectedCity,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            customTextField(
              hintText: "Search here",
              prefixIcon: Icons.search,
              suffixIcon: Icons.mic_rounded,
              prefixIconPressed: () {},
              suffixIconPressed: () {},
            ),
            FutureBuilder<String>(
              future: fetchData(), // Your future method
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator while waiting for the future
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Handle the error case
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // Once the future is complete and data is available, display your Card widget
                  return buildProductCard(
                    productName: 'Wash Basin',
                    originalPrice: 499,
                    discountedPrice: 469,
                    details: [
                      'Procurement of spare parts at extra cost',
                      'Blockage removal of wash basin and waste pipe',
                    ],
                    onAddPressed: () {
                      // Add product to cart
                    },
                    onShowMorePressed: () {
                      // Navigate to more details page
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String> fetchData() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating network call
    return "Success"; // You can return any data that you need for the Card
  }

  Widget customTextField({
    required String hintText,
    required IconData prefixIcon,
    required IconData suffixIcon,
    VoidCallback? prefixIconPressed,
    VoidCallback? suffixIconPressed,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            height: 40.0,
            child: TextFormField(
              focusNode: _focusNode,
              showCursor: _isFocused,
              cursorOpacityAnimates: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5.0),
                hintText: hintText,
                prefixIcon: IconButton(
                  onPressed: prefixIconPressed,
                  icon: Icon(prefixIcon),
                ),
                suffixIcon: IconButton(
                  icon: Icon(suffixIcon),
                  onPressed: suffixIconPressed,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 5.0),
          child: IconButton.outlined(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
          ),
        )
      ],
    );
  }

  Widget customSmallButton({
    required String buttonText,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color borderColor,
    required double borderWidth,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: const Size(60, 30),
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
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
        style: const TextStyle(fontSize: 15.0),
      ),
    );
  }

  Widget buildProductCard({
    required String productName,
    required double originalPrice,
    required double discountedPrice,
    required List<String> details,
    required VoidCallback onAddPressed,
    required VoidCallback onShowMorePressed,
  }) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 10.0,
      color: Colors.amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              productName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text.rich(
              TextSpan(
                text: '\u{20B9}${originalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 150, 146, 146),
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.lineThrough,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' \u{20B9}${discountedPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            trailing: customSmallButton(
              buttonText: 'Add',
              onPressed: onAddPressed,
              backgroundColor: Colors.white,
              borderColor: Colors.black,
              borderWidth: 1.0,
            ),
          ),
          SizedBox(
            height: 100.0, // Constrain the height of ListView
            child: ListView.builder(
              itemCount: details.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  subtitle: Text(details[index]),
                );
              },
            ),
          ),
          TextButton.icon(
            onPressed: onShowMorePressed,
            label: const Text('Show more'),
            icon: const Icon(Icons.keyboard_arrow_right),
            iconAlignment: IconAlignment.end,
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
    final media = MediaQuery.of(context);

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
          width: double.maxFinite,
          height: media.size.height * 0.36,
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
