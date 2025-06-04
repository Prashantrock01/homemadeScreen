import 'package:flutter/material.dart';

import 'maid.dart';

class Newservices extends StatelessWidget {
  Newservices({super.key});

  final List<Map<String, String>> items = [
    {
      'title': 'Cab Cleaner',
      'subtitle': 'Pre-approve expected cab entry',
      'icon': 'assets/images/car.png'
    },
    {
      'title': 'Laundry',
      'subtitle': 'Pre-approve expected delivery entry',
      'icon': 'assets/images/laudry.png'
    },
    {
      'title': 'Tuition Teacher',
      'subtitle': 'Security Guard will collect your parcel at gate',
      'icon': 'assets/images/tutionteacher.png'
    },
    {
      'title': 'Gym Instructor',
      'subtitle': 'Pre-approve expected guest entry',
      'icon': 'assets/images/gyminstructor.png'
    },
    {
      'title': 'Yoga Instructor',
      'subtitle': 'Pre-approve expected services entry',
      'icon': 'assets/images/yogainstructor.png'
    },
    {
      'title': 'Pet Walker',
      'subtitle': 'Pre-approve expected cab entry',
      'icon': 'assets/images/petwalker.png'
    },
    {
      'title': 'Sports Teacher',
      'subtitle': 'Pre-approve expected delivery entry',
      'icon': 'assets/images/sportsteacher.png'
    },
    {
      'title': 'Scrap Dealer',
      'subtitle': 'Security Guard will collect your parcel at gate',
      'icon': 'assets/images/scrapdealer.png'
    },
    {
      'title': 'Cable/ TV Repair',
      'subtitle': 'Pre-approve expected guest entry',
      'icon': 'assets/images/tvcable.png'
    },
    {
      'title': 'Staff',
      'subtitle': 'Pre-approve expected services entry',
      'icon': 'assets/images/staff.png'
    },
    {
      'title': 'Others',
      'subtitle': 'Pre-approve expected services entry',
      'icon': 'assets/images/newothers.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          'Add New Services',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // backgroundColor: const Color.fromARGB(255, 255, 196, 1),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 234, 201, 92),
              Color.fromARGB(252, 243, 243, 243),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double padding = screenWidth * 0.05; // 5% of screen width
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildList(context, items, padding),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, List<Map<String, String>> items, double padding) {
    return Column(
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              leading: _buildImage(item['icon']!),
              title: Text(
                item['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
              trailing: SizedBox(
                width: 13,
                height: 22,
                child: Image.asset(
                  'assets/images/righticon.png',
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Maid(
                      title: item['title']!,
                      subtitle: item['subtitle']!,
                      icon: item['icon']!,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImage(String path) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: 58,
        height: 32,
        child: Image.asset(
          path,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image_not_supported);
          },
        ),
      ),
    );
  }
}

class ServiceDetailPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;

  const ServiceDetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        // backgroundColor: const Color.fromARGB(255, 255, 196, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              icon,
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 100);
              },
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
