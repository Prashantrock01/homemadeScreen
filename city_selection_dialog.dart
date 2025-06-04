import 'package:flutter/material.dart';

class CitySelectionDialog extends StatelessWidget {
  final List<Map<String, String>> cities = [
    {'name': 'Bangalore', 'imageUrl': 'assets/images/bangalore.png'},
    {'name': 'Mumbai', 'imageUrl': 'assets/images/mumbai.png'},
    {'name': 'Chennai', 'imageUrl': 'assets/images/chennai.png'},
    {'name': 'Pune', 'imageUrl': 'assets/images/pune.png'},
    {'name': 'Hyderabad', 'imageUrl': 'assets/images/hyderabad.png'},
    {'name': 'Gurugram', 'imageUrl': 'assets/images/gurugram.png'},
    {'name': 'Delhi', 'imageUrl': 'assets/images/delhi.png'},
    {'name': 'Noida', 'imageUrl': 'assets/images/noida.png'},
    {'name': 'Greater Noida', 'imageUrl': 'assets/images/greaternoida.png'},
    {'name': 'Ghaziabad', 'imageUrl': 'assets/images/ghaziabad.png'},
    {'name': 'Faridabad', 'imageUrl': 'assets/images/faridabad.png'},
    {'name': 'Ahmedabad', 'imageUrl': 'assets/images/ahmedabad.png'},
  ];

  CitySelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width * 0.9;
    final maxHeight = screenSize.height * 0.8;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: maxHeight,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Text(
                    'Select City',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Flexible(
                child: GridView.builder(
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
                        Navigator.pop(context);
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
            ],
          ),
        ),
      ),
    );
  }
}
