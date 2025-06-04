import 'package:biz_infra/Screens/services/order_summary.dart';
import 'package:biz_infra/Screens/services/plumbing_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServicesHome extends StatefulWidget {
  const ServicesHome({super.key});

  @override
  State<ServicesHome> createState() => _ServicesHomeState();
}

class _ServicesHomeState extends State<ServicesHome> {
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/biz_infra.png',
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Get.to(
                  () => const OrderSummary(),
                  transition: Transition.rightToLeft,
                  popGesture: true,
                );
              },
              child: const Text.rich(
                TextSpan(
                  text: 'Biz', // Default text style
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
                      ), // Normal text
                    ),
                  ],
                ),
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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customTextField(
              hintText: "Search here",
              prefixIcon: Icons.search,
              suffixIcon: Icons.mic_rounded,
              prefixIconPressed: () {},
              suffixIconPressed: () {},
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
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 40.0,
                    children: <Widget>[
                      _buildCircleAvatarWithText(
                        'assets/services_home/cleaning.png',
                        'Home\nCleaning',
                        () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: const Text(
                                  'Home Cleaning',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: <Widget>[
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: GridView.count(
                                      primary: false,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 3,
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        _buildDailogWithText(
                                          'assets/home_services/house.png',
                                          'Full House\nCleaning',
                                          () {},
                                        ),
                                        _buildDailogWithText(
                                          'assets/home_services/kitchen.png',
                                          'Kitchen\nCleaning',
                                          () {},
                                        ),
                                        _buildDailogWithText(
                                          'assets/home_services/sofa.png',
                                          'Sofa/Carpet\nCleaning',
                                          () {},
                                        ),
                                        _buildDailogWithText(
                                          'assets/home_services/bathroom.png',
                                          'Bathroom\nCleaning',
                                          () {},
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/cleaning.png',
                        'Packers &\nMovers',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/city_tempo.png',
                        'City Tempo',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/wall_painting.png',
                        'Painting',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/plumbing.png',
                        'Plumbing',
                        () {
                          Get.to(
                            () => const PlumbingServices(),
                            transition: Transition.rightToLeft,
                            popGesture: true,
                          );
                        },
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/electrician.png',
                        'Electrician',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/carpenter.png',
                        'Carpentary',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/weekly_cleaning.png',
                        'Weekly\nCleaning',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/bathroom_cleaning.png',
                        'Bathroom\nCleaning',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/home_interiors.png',
                        'Home\nInteriors',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/home_renovation.png',
                        'Home\nRenovation',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/one_wall_painting.png',
                        'One Wall\nPainting',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/ac_services.png',
                        'AC Services &\nRepair',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/legal_services.png',
                        'Legal\nServices',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/sofa_services.png',
                        'Sofa\nCleaning',
                        () {},
                      ),
                      _buildCircleAvatarWithText(
                        'assets/services_home/vehicle_shifting.png',
                        'Vehicle\nShifting',
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
    required IconData suffixIcon,
    VoidCallback? prefixIconPressed,
    VoidCallback? suffixIconPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(bottom: 25.0),
      child: TextField(
        focusNode: _focusNode,
        showCursor: _isFocused,
        cursorOpacityAnimates: true,
        decoration: InputDecoration(
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
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              20.0,
            ),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              20.0,
            ),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _buildDailogWithText(
      String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(imagePath, height: 36),
          const SizedBox(
            height: 4.0,
          ), // Spacing between the avatar and the text
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
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
            child: Image.asset(imagePath, height: 26),
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
