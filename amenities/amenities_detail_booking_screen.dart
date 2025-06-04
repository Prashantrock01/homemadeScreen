import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/amenities/amenities_booking_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../CustomWidgets/configurable_widgets.dart';

class AmenitiesDetailBookingScreen extends StatefulWidget {
  final String recordId;
  final String? title;
  final String? bookingAmount;
  final String? qrCodeId;
  final String? amenitiesId;
  const AmenitiesDetailBookingScreen({required this.recordId,this.title,this.bookingAmount, this.amenitiesId, this.qrCodeId, super.key});

  @override
  State<AmenitiesDetailBookingScreen> createState() => _AmenitiesDetailBookingScreenState();
}

class _AmenitiesDetailBookingScreenState extends State<AmenitiesDetailBookingScreen> {
  final amenitiesForm = GlobalKey<FormState>();
  bool isChecked = false;
  List<String> pickDate = ['Today', 'Tomorrow', 'Custom'];
  String? selectedOption;
  int? selectedIndex;
  String? selectedDate;
  List<String> selectedTimeSlots = [];
  List<String>? _availableSlots;
  List<String>? _bookedSlots;
  bool _isLoading = false;


  void handleDateSelection(int index) async {
    DateTime now = DateTime.now();
    String formattedDate = '';

    if (index == 0) {
      formattedDate = DateFormat('yyyy-MM-dd').format(now);
      selectedOption = "Today";
    } else if (index == 1) {
      formattedDate = DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 1)));
      selectedOption = "Tomorrow";
    } else if (index == 2) {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: now.add(const Duration(days: 365)),
      );

      if (pickedDate != null) {
        formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        selectedOption = "Custom";
      } else {
        return;
      }
    }

    setState(() {
      selectedIndex = index;
      selectedDate = formattedDate;
      _availableSlots = null; // Reset slots when changing date
      selectedTimeSlots.clear();
      _fetchSlots(); // Fetch new slots for selected date
    });
  }

  void _fetchSlots() async {
    if (selectedDate == null) return;

    setState(() => _isLoading = true);

    try {
      var responseData = await dioServiceClient.getAmenitiesSlot(
        true,
        amenitiesId: widget.recordId.split('x').last,
        date: selectedDate!,
      );

      if (responseData != null && responseData.statuscode == 1) {
        setState(() {
          _availableSlots = responseData.data?.availableSlots
              ?.map((slot) => slot.timeSlot)
              .whereType<String>() // Filters out null values
              .toList() ?? [];

          _bookedSlots = responseData.data?.bookedSlots ?? [];
        });
      } else {
        setState(() {
          _availableSlots = [];
        });
      }
    } catch (e) {
      setState(() {
        _availableSlots = [];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Amenities Scheduler"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
                  key: amenitiesForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipPath(
                        clipper: MovieTicketBothSidesClipper(),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.blue.shade50,
                          child: Center(
                            child: Text(
                              widget.title.toString(),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Pick a Date Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Pick a Date",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Wrap(
                          spacing: 15.0,
                          children: List.generate(3, (index) {
                            return TextButton(
                              onPressed: () => handleDateSelection(index),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: const BorderSide(color: Color(0xff5D5D5D)),
                                  ),
                                ),
                                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                                  const EdgeInsets.all(10),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.calendar_month, color: Colors.black),
                                  const SizedBox(width: 5),
                                  Text(
                                    selectedIndex == index ? selectedDate! : pickDate[index],
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Show Pick a Slot only when a date is selected
                      if (selectedDate != null) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            "Pick a Slot",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        Expanded(
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _availableSlots == null || _availableSlots!.isEmpty
                              ?  Center(
                            child: Text(
                             // "No available slots for today. Amenity is closed.",
                              "No available slots for ${selectedDate.toString()}. \nAmenity is closed.",

                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          )
                              : SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _availableSlots!.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemBuilder: (context, index) {
                                  String currentSlot = _availableSlots![index];
                                  bool isBooked = _bookedSlots?.contains(currentSlot) ?? false;
                                  bool isSelected = selectedTimeSlots.contains(currentSlot);

                                  return GestureDetector(
                                    onTap: isBooked
                                        ? null
                                        : () {
                                      setState(() {
                                        if (isSelected) {
                                          selectedTimeSlots.remove(currentSlot);
                                        } else {
                                          selectedTimeSlots.add(currentSlot);
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isBooked
                                            ? Colors.grey.shade300
                                            : isSelected
                                            ? Colors.blue.shade100
                                            : Colors.white,
                                        border: Border.all(
                                          color: isBooked
                                              ? Colors.grey
                                              : isSelected
                                              ? Colors.blue
                                              : Colors.grey,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Radio(
                                            value: currentSlot,
                                            groupValue: isSelected ? currentSlot : null,
                                            onChanged: isBooked
                                                ? null
                                                : (value) {
                                              setState(() {
                                                if (isSelected) {
                                                  selectedTimeSlots.remove(currentSlot);
                                                } else {
                                                  selectedTimeSlots.add(currentSlot);
                                                }
                                              });
                                            },
                                            activeColor: Colors.blue,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            currentSlot,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: isBooked ? Colors.grey : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                                            ),
                                                          ),
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: textButton(
                onPressed: () async {
                  String formattedTimeSlots = selectedTimeSlots.join(" |##| ");
                  FocusScope.of(context).unfocus();

                  if (selectedDate == null) {
                    Get.snackbar("Error", "Please select a date before proceeding.",
                        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                    return;
                  }

                  if (selectedTimeSlots.isEmpty) {
                    Get.snackbar("Error", "Please select at least one time slot before proceeding.",
                        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                    return;
                  }

                  if (amenitiesForm.currentState!.validate()) {
                    Get.to(() => AmenitiesBookingPayment(
                      bookingAmount: widget.bookingAmount,
                      amenitiesTitle: widget.title,
                      bookingDate: selectedDate.toString(),
                      bookingSlot: formattedTimeSlots,
                      amenitiesId: widget.amenitiesId.toString(),
                      qrCodeId: widget.qrCodeId.toString(),
                      bookingOption: selectedOption.toString(),
                      recordId: widget.recordId.toString(),

                    )
                    );
                  }
                },
                widget: const Text("Proceed to Payment"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

