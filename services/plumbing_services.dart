import 'package:biz_infra/Screens/services/product.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlumbingServices extends StatefulWidget {
  const PlumbingServices({super.key});

  @override
  State<PlumbingServices> createState() => _PlumbingServicesState();
}

class _PlumbingServicesState extends State<PlumbingServices> {
  ValueNotifier<String> selectedCityNotifier = ValueNotifier('Select City');

  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  bool _showMore = false; // State variable to manage the visibility

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            customTextField(
              hintText: "Search here",
              prefixIcon: Icons.search,
              suffixIcon: Icons.mic_rounded,
              prefixIconPressed: () {},
              suffixIconPressed: () {},
            ),
            Container(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.asset('assets/plumber_services/plumber.png'),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.only(bottom: 10.0),
              child: const ListTile(
                title: Text(
                  'Best Plumbing Services in\nBangalore',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20.0,
                    ),
                    Text.rich(
                      TextSpan(
                        text: '4.7 ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '(1.7 M bookings near you)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: media.size.height * 0.3,
                  child: GridView.count(
                    physics: const AlwaysScrollableScrollPhysics(),
                    primary: false,
                    crossAxisCount: 4,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 20.0,
                    children: <Widget>[
                      _buildCircleAvatarWithText(
                        'assets/plumber_services/basin.png',
                        'Basin &\nSink',
                        () {
                          Get.to(
                            () => const Product(),
                            transition: Transition.rightToLeft,
                            popGesture: true,
                          );
                        },
                      ),
                      _buildCircleAvatarWithText(
                        'assets/plumber_services/grouting.png',
                        'Grouting',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/plumber_services/bath.png',
                        'Bath Fitting',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/plumber_services/drainage.png',
                        'Drainage Pipes',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/plumber_services/toilet.png',
                        'Toilet',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/plumber_services/tap_and_mixer.png',
                        'Tap & Mixer',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/plumber_services/water_tank.png',
                        'Water Tank',
                        () {},
                      ),
                      // Show More / Show Less button
                      _buildCircleAvatarWithText(
                        _showMore
                            ? 'assets/plumber_services/up_arrow.png'
                            : 'assets/plumber_services/down_arrow.png',
                        _showMore ? 'Show less' : 'Show more',
                        () {
                          setState(() {
                            _showMore = !_showMore; // Toggle state
                          });
                        },
                      ),
                      // Conditionally render additional items if _showMore is true
                      if (_showMore) ...[
                        _buildCircleAvatarWithText(
                          'assets/plumber_services/water_pipe.png',
                          'Water Pipe\nConnection',
                          () {},
                        ),
                        _buildCircleAvatarWithText(
                          'assets/plumber_services/looking.png',
                          'Looking for\nsomething\nelse',
                          () {},
                        ),
                      ]
                    ],
                  ),
                ),
                summaryListTile()
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

  Widget _buildCircleAvatarWithText(
      String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 218, 209, 209),
            radius: 25.0,
            child: Image.asset(imagePath, height: 30),
          ),
          const SizedBox(
            height: 4.0,
          ), // Spacing between the avatar and the text
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              maxLines: 2,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
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
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget summaryListTile() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: Image.asset(
          'assets/order_summary/vip.png',
          height: 40,
          color: const Color.fromARGB(255, 230, 175, 10),
        ),
        title: const Text(
          'VIP Membership',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
        subtitle: const Text(
          'Upto 15% off on top of\nexisting deals',
          style: TextStyle(
            fontSize: 10,
            color: Color.fromARGB(255, 230, 175, 10),
          ),
        ),
        trailing: customSmallButton(
          buttonText: 'BUY',
          onPressed: () {},
          backgroundColor: Colors.white,
          borderColor: Colors.black,
          borderWidth: 1.0,
        ),
        tileColor: Constants.secondaryTextWhite,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Optional: Rounded corners
        ),
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
