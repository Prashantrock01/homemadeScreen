import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:flutter/material.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> with TickerProviderStateMixin {
  late final TabController _tabController;

  // Example state variables to hold the content for each tab
  List<String> ongoingBookings = [];
  List<String> quotations = [];
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Example: Initialize content (if any) here
    // ongoingBookings = ['Booking 1', 'Booking 2']; // Uncomment to test non-empty state
    // quotations = ['Quotation 1']; // Uncomment to test non-empty state
    // history = ['History Item 1']; // Uncomment to test non-empty state
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset(
              'assets/images/biz_infra.png',
              height: 25,
            ),
            const Text.rich(
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
                        fontWeight: FontWeight.normal), // Normal text
                  ),
                  TextSpan(
                    text: 'Home Services',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ), // Continue with default text style
                ],
              ),
            )
          ],
        ),
        bottom: TabBar(
          labelColor: Colors.amber,
          indicatorColor: Colors.amber,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'ONGOING',
            ),
            Tab(
              text: 'QUOTATION',
            ),
            Tab(
              text: 'HISTORY',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(
            child: ongoingBookings.isEmpty
                ? _buildNoBookingContent()
                : _buildBookingList(ongoingBookings),
          ),
          Center(
            child: quotations.isEmpty
                ? _buildNoBookingContent()
                : _buildBookingList(quotations),
          ),
          Center(
            child: history.isEmpty
                ? _buildNoBookingContent()
                : _buildBookingList(history),
          ),
        ],
      ),
    );
  }

  Widget _buildNoBookingContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/booking/no_booking.png',
          height: 140,
        ),
        const ListTile(
          title: Text(
            'No Booking Found',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          subtitle: Text(
            'Looks like you don\'t have any bookings here but you can request for a service now',
            textAlign: TextAlign.center,
          ),
        ),
        customElevatedButton(
          text: 'Book Now', 
          onPressed: () {},
        )
      ],
    );
  }

  Widget _buildBookingList(List<String> bookings) {
    // This widget builds the list view of bookings for each tab
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(bookings[index]),
        );
      },
    );
  }
}
