import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'My_services.dart';

class Maid extends StatefulWidget {
  const Maid({super.key, required String title, required String subtitle, required String icon});

  @override
  _MaidState createState() => _MaidState();
}

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

class _MaidState extends State<Maid> {
  final List<MaidDetails> _maids = [
    MaidDetails(
      name: 'Mena',
      role: 'Maid',
      imageUrl: 'assets/images/maid28.png',
      rating: 4,
      flats: 7,
      location: 'A-101',
      phoneNumber: '1234567890',
      gender: 'Female',
      currentlyInside: true,
    ),
    MaidDetails(
      name: 'Lily',
      role: 'Maid',
      imageUrl: 'assets/images/maid28.png',
      rating: 5,
      flats: 5,
      location: 'No-Appartment',
      phoneNumber: '0987654321',
      gender: 'Female',
      currentlyInside: false,
    ),
    MaidDetails(
      name: 'Nandani',
      role: 'Maid',
      imageUrl: 'assets/images/maid28.png',
      rating: 5,
      flats: 5,
      location: 'No-Appartment',
      phoneNumber: '2345678901',
      gender: 'Female',
      currentlyInside: true,
    ),
    MaidDetails(
      name: 'Sheela',
      role: 'Maid',
      imageUrl: 'assets/images/maid28.png',
      rating: 5,
      flats: 5,
      location: 'No-Appartment',
      phoneNumber: '3455678901',
      gender: 'Female',
      currentlyInside: false,
    ),
    MaidDetails(
      name: 'John',
      role: 'Maid',
      imageUrl: 'assets/images/maid28.png',
      rating: 5,
      flats: 5,
      location: 'No-Appartment',
      phoneNumber: '3455678901',
      gender: 'Male',
      currentlyInside: true,
    )
  ];

  List<MaidDetails> _filteredMaids = [];

  @override
  void initState() {
    super.initState();
    _filteredMaids = _maids;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maid', style: TextStyle(color: Colors.white)),
        // backgroundColor: Colors.yellow[600],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 30),
            onPressed: () {
              // Add your search functionality here
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 247, 223, 147), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Card(
          elevation: 10,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterButton(Icons.lock, 'Available Maid', screenSize),
                    _buildFilterButton(Icons.star_rate_outlined, 'Rating', screenSize),
                    _buildFilterButton(Icons.filter_list, 'Filter', screenSize),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
                  child: ListView.builder(
                    itemCount: _filteredMaids.length,
                    itemBuilder: (context, index) {
                      final maid = _filteredMaids[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(screenSize.width * 0.04),
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(maid.imageUrl),
                                    radius: screenSize.width * 0.12,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.01),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          maid.name,
                                          style: TextStyle(
                                            fontSize: screenSize.width * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: screenSize.height * 0.01),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(15.0),
                                              ),
                                              child: SizedBox(
                                                height: screenSize.height * 0.03,
                                                width: screenSize.width * 0.25,
                                                child: Center(
                                                  child: Text(
                                                    maid.role,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: screenSize.width * 0.02),
                                            Expanded(
                                              child: Row(
                                                children: List.generate(5, (starIndex) {
                                                  return Expanded(
                                                    child: IconButton(
                                                      icon: Icon(
                                                        starIndex < maid.rating
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        color: Colors.amber,
                                                      ),
                                                      iconSize: screenSize.width * 0.03, // Reduce star size
                                                      padding: EdgeInsets.zero,
                                                      constraints: const BoxConstraints(),
                                                      onPressed: () {
                                                        setState(() {
                                                          maid.rating = starIndex + 1;
                                                        });
                                                      },
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                            SizedBox(width: screenSize.width * 0.03),
                                            Text(
                                              '(${maid.flats} flats)',
                                              style: TextStyle(fontSize: screenSize.width * 0.04),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: screenSize.height * 0.03),
                                        Row(
                                          children: [
                                            const Icon(Icons.home),
                                            SizedBox(width: screenSize.width * 0.04),
                                            Text(' ${maid.location}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              color: const Color(0xFFF7C51E),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildActionButton(Icons.lock, 'Added to My Flat', screenSize, () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => MyServicesScreen()),

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => MyServicesScreen(flatNumber: '108',)
                                          ),
                                        );

                                    // );
                                  }),
                                  _buildActionButton(Icons.call, 'Call', screenSize, () {
                                    _makePhoneCall(maid.phoneNumber);
                                  }),
                                  _buildActionButton(Icons.share, 'Share', screenSize, () {
                                    _shareMaidDetails(maid);
                                  }),
                                ],
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
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(IconData icon, String label, Size screenSize) {
    return TextButton.icon(
      onPressed: () {
        if (label == 'Rating') {
          _showRatingDialog();
        } else if (label == 'Filter') {
          _showFilterDialog();
        }
      },
      icon: Icon(icon, color: Colors.black, size: screenSize.width * 0.05),
      label: Text(label, style: TextStyle(color: Colors.black, fontSize: screenSize.width * 0.04)),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Size screenSize, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: screenSize.width * 0.05),
      label: Text(label, style: TextStyle(color: Colors.white, fontSize: screenSize.width * 0.04)),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int currentRating = 0; // Default rating value

        return AlertDialog(
          title: const Text('Rate Maid'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return Flexible(
                    child: IconButton(
                      icon: Icon(
                        index < currentRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          currentRating = index + 1;
                        });
                      },
                    ),
                  );
                }),
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Handle rating submission here, you can access the `currentRating` variable
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Female'),
                onTap: () {
                  _applyFilter('Female');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Male'),
                onTap: () {
                  _applyFilter('Male');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Currently Inside'),
                onTap: () {
                  _applyFilter('Currently Inside');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Any'),
                onTap: () {
                  _applyFilter('Any');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyFilter(String filter) {
    setState(() {
      if (filter == 'Female') {
        _filteredMaids = _maids.where((maid) => maid.gender == 'Female').toList();
      } else if (filter == 'Male') {
        _filteredMaids = _maids.where((maid) => maid.gender == 'Male').toList();
      } else if (filter == 'Currently Inside') {
        _filteredMaids = _maids.where((maid) => maid.currentlyInside).toList();
      } else {
        _filteredMaids = _maids;
      }
    });
  }

  void _shareMaidDetails(MaidDetails maid) {
    final String text = 'Maid Details:\n'
        'Name: ${maid.name}\n'
        'Role: ${maid.role}\n'
        'Location: ${maid.location}\n'
        'Phone: ${maid.phoneNumber}';
    Share.share(text);
  }
}

class MaidDetails {
  final String name;
  final String role;
  final String imageUrl;
  int rating; // Change rating to be mutable
  final int flats;
  final String location;
  final String phoneNumber;
  final String gender;
  final bool currentlyInside;

  MaidDetails({
    required this.name,
    required this.role,
    required this.imageUrl,
    required this.rating,
    required this.flats,
    required this.location,
    required this.phoneNumber,
    required this.gender,
    required this.currentlyInside,
  });
}
