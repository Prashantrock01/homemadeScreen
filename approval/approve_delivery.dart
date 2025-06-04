import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Themes/theme_controller.dart';
import '../../Utils/constants.dart';

class Courier {
  IconData? logo;
  String? name;

  Courier({
    this.logo,
    this.name,
  });

  Courier.fromJson(Map<String, dynamic> json) {
    logo = json['logo'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['logo'] = logo;
    data['name'] = name;
    return data;
  }
}

class PreApproveDelivery extends StatefulWidget {
  const PreApproveDelivery({super.key});

  @override
  State<PreApproveDelivery> createState() => _PreApproveDeliveryState();
}

class _PreApproveDeliveryState extends State<PreApproveDelivery> {
  final _selectedDateIndex = ValueNotifier<int>(-1);
  final _selectedDate = ValueNotifier<String>('');
  final _selectedTimeIndex = ValueNotifier<int>(-1);
  final _selectedTimeFrame = ValueNotifier<String>('Pick a Time');
  final _isAnyTimeAllowed = ValueNotifier<bool>(false);
  final _canCollect = ValueNotifier<bool>(false);
  final _selectedCourierIndex = ValueNotifier<int>(-1);

  List<Map<String, dynamic>> couriers = [
    {
      'logo': Icons.shopping_bag_outlined,
      'name': 'Amazon',
    },
    {
      'logo': Icons.shopping_bag_outlined,
      'name': 'Flipkart',
    },
  ];

  void _today(int index) {
    _selectedDateIndex.value = index != 0 ? 0 : -1;
    _selectedDate.value = DateFormat('dd MMMM y').format(DateTime.now());
  }

  void _tomorrow(int index) {
    if (_selectedTimeIndex.value != -1) {
      _selectedTimeIndex.value = -1;
      _selectedTimeFrame.value = 'Pick Time';
    }
    _selectedDateIndex.value = index != 1 ? 1 : -1;
    _selectedDate.value = DateFormat('dd MMMM y').format(
      DateTime.now().add(const Duration(days: 1)),
    );
  }

  Future<void> _pickADate(int index) async {
    if (_selectedTimeIndex.value != -1) {
      _selectedTimeIndex.value = -1;
      _selectedTimeFrame.value = 'Pick Time';
    }
    final now = DateTime.now();
    if (index != 2) {
      final pickedDate = await showDatePicker(
        context: context,
        firstDate: now,
        initialDate: now,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        lastDate: DateTime(now.year, now.month + 2, 0),
      );
      if (pickedDate != null) {
        _selectedDate.value = DateFormat('dd MMMM y').format(pickedDate);
        if (pickedDate.day == now.day) {
          _selectedDateIndex.value = index != 0 ? 0 : -1;
        } else if (pickedDate.day == now.add(const Duration(days: 1)).day) {
          _selectedDateIndex.value = index != 1 ? 1 : -1;
        } else {
          _selectedDateIndex.value = index != 2 ? 2 : -1;
        }
      }
    } else {
      _selectedDateIndex.value = -1;
    }
  }

  void _inNext30Minutes(int index) {
    _selectedTimeIndex.value = index != 0 ? 0 : -1;
    const frame = Duration(minutes: 30);
    _selectedTimeFrame.value =
        index != 0 ? _timeDuration(frame) : 'Pick a Time';
  }

  void _inNext1Hour(int index) {
    _selectedTimeIndex.value = index != 1 ? 1 : -1;
    const frame = Duration(hours: 1);
    _selectedTimeFrame.value =
        index != 1 ? _timeDuration(frame) : 'Pick a Time';
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      if (_selectedTimeIndex.value != -1) {
        _selectedTimeIndex.value = -1;
      }
      _selectedTimeFrame.value = _timePickerDuration(pickedTime);
    } else {
      _selectedTimeFrame.value = 'Pick a Time';
    }
  }

  String _timeDuration(Duration duration) {
    final now = DateTime.now();
    final dtf1 = DateFormat.jm().format(now);
    final dtf2 = DateFormat.jm().format(now.add(duration));
    return '$dtf1 - $dtf2';
  }

  String _timePickerDuration(TimeOfDay tod) {
    final now = DateTime.now();
    final tf1 = now.copyWith(
      hour: tod.hour,
      minute: tod.minute,
    );
    final tf2 = DateFormat.jm().format(
      tf1.add(const Duration(hours: 2)),
    );
    return '${tod.format(context)} - $tf2';
  }

  void _onAllowedAnytime(bool? checkboxState, bool status) {
    if (checkboxState != null) {
      if (_selectedTimeIndex.value != -1) {
        _selectedTimeIndex.value = -1;
      }
      _isAnyTimeAllowed.value = checkboxState;
      _selectedTimeFrame.value = status ? 'Pick a Time' : 'Allowed Anytime';
    }
  }

  void _onSelectedCourier(int index, int selectedIndex) {
    _selectedCourierIndex.value = (index != selectedIndex) ? index : -1;
  }

  void _canCollectParcel(bool? checboxState) {
    if (checboxState != null) {
      _canCollect.value = checboxState;
    }
  }

  void _approveDelivery() {
    final isDateSelected = _selectedDateIndex.value != -1;
    final isTimeSelected = _selectedTimeIndex.value != -1;
    final isTimeFrameValid = _selectedTimeFrame.value != 'Pick a Time';
    final isAnytimeSelected = _isAnyTimeAllowed.value;
    final isCourierSelected = _selectedCourierIndex.value != -1;
    if (isDateSelected &&
        (isTimeSelected || isAnytimeSelected || isTimeFrameValid) &&
        isCourierSelected) {
      showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: false,
        showDragHandle: true,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        right: 10.0,
                      ),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.shopping_bag_rounded,
                            size: 60.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Courier.fromJson(
                              couriers[_selectedCourierIndex.value],
                            ).name!,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Date: ${_selectedDate.value}'),
                          Text('Time: ${_selectedTimeFrame.value}'),
                        ],
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    child: Text(
                      'Collect from gate: '
                      '${_canCollect.value ? 'Yes' : 'No'}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your parcel is waiting '
                    'and can be picked up by you.',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Confirm'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _today(-1);
    _inNext1Hour(-1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pre Approve Delivery'),
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: ThemeController.selectedTheme == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                width: double.maxFinite,
                child: Text(
                  'Date',
                  style: TextStyle(
                    color: ThemeController.selectedTheme == ThemeMode.light
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _selectedDateIndex,
                builder: (context, dateIndex, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ChoiceChip.elevated(
                          label: const Text('Today'),
                          onSelected: (value) {
                            _today(dateIndex);
                          },
                          selected: dateIndex == 0,
                        ),
                        ChoiceChip.elevated(
                          label: const Text('Tomorrow'),
                          onSelected: (value) {
                            _tomorrow(dateIndex);
                          },
                          selected: dateIndex == 1,
                        ),
                        ChoiceChip.elevated(
                          label: const Text('Pick a Date'),
                          onSelected: (value) {
                            _pickADate(dateIndex);
                          },
                          selected: dateIndex == 2,
                        ),
                      ],
                    ),
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: _isAnyTimeAllowed,
                builder: (context, isAnyTimeAllowed, child) {
                  return AbsorbPointer(
                    absorbing: isAnyTimeAllowed,
                    child: ValueListenableBuilder(
                      valueListenable: _selectedDateIndex,
                      builder: (context, dateIndex, child) {
                        return Visibility(
                          visible: dateIndex == 0 && !isAnyTimeAllowed,
                          child: ValueListenableBuilder(
                            valueListenable: _selectedTimeIndex,
                            builder: (context, timeIndex, child) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ChoiceChip.elevated(
                                      label: const Text('In next 30 minutes'),
                                      onSelected: (value) {
                                        _inNext30Minutes(timeIndex);
                                      },
                                      selected: timeIndex == 0,
                                    ),
                                    ChoiceChip.elevated(
                                      label: const Text('In next 1 hour'),
                                      onSelected: (value) {
                                        _inNext1Hour(timeIndex);
                                      },
                                      selected: timeIndex == 1,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: _selectedDateIndex,
                builder: (context, dateIndex, child) {
                  return Visibility(
                    visible: dateIndex != -1,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        leading: const Icon(Icons.today),
                        title: Text(_selectedDate.value),
                      ),
                    ),
                  );
                },
              ),
              Container(
                color: ThemeController.selectedTheme == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Time',
                      style: TextStyle(
                        color: ThemeController.selectedTheme == ThemeMode.light
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    Text(
                      '(The gate pass will expire after 2 hours)',
                      style: TextStyle(
                        color: ThemeController.selectedTheme == ThemeMode.light
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _isAnyTimeAllowed,
                builder: (context, isAnyTimeAllowed, child) {
                  return AbsorbPointer(
                    absorbing: isAnyTimeAllowed,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.schedule),
                          onTap: _pickTime,
                          title: ValueListenableBuilder(
                            valueListenable: _selectedTimeFrame,
                            builder: (context, timeFrame, child) {
                              return Text(timeFrame);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: _isAnyTimeAllowed,
                builder: (context, isChecked, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) {
                        _onAllowedAnytime(value, isChecked);
                      },
                      title: const Text('Anytime during the day'),
                      value: isChecked,
                    ),
                  );
                },
              ),
              const Divider(),
              Container(
                color: ThemeController.selectedTheme == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                width: double.maxFinite,
                child: Text(
                  'From',
                  style: TextStyle(
                    color: ThemeController.selectedTheme == ThemeMode.light
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _selectedCourierIndex,
                builder: (context, selectedCourierIndex, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 90.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                final courier =
                                    Courier.fromJson(couriers[index]);

                                return GestureDetector(
                                  onTap: () {
                                    _onSelectedCourier(
                                      index,
                                      selectedCourierIndex,
                                    );
                                  },
                                  child: CourierService(
                                    logo: courier.logo!,
                                    name: courier.name!,
                                    picked: index == selectedCourierIndex,
                                  ),
                                );
                              },
                              itemCount: couriers.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const SizedBox(
                              height: 90.0,
                              child: CourierService(
                                logo: Icons.add_circle_outline,
                                name: 'More',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: _canCollect,
                builder: (context, canCollect, child) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 0),
                    child: CheckboxListTile(
                      onChanged: _canCollectParcel,
                      title: const Text('Collect my parcel at the gate'),
                      value: canCollect,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        child: SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: _approveDelivery,
            style: ButtonStyle(
              // backgroundColor: WidgetStateProperty.resolveWith((states) {
              //   if (states.contains(WidgetState.pressed)) {
              //     return Colors.green.shade600;
              //   }
              //   return Colors.green.shade400;
              // }),
              // foregroundColor: const WidgetStatePropertyAll(
              //   Colors.white,
              // ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            child: const Text('Notify Guard'),
          ),
        ),
      ),
    );
  }
}

class CourierService extends StatelessWidget {
  const CourierService({
    super.key,
    required this.logo,
    required this.name,
    this.picked = false,
  });

  final IconData logo;
  final String name;
  final bool picked;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: picked
          ? ThemeController.selectedTheme == ThemeMode.dark
              ? Colors.grey.shade800
              : Colors.grey
          : Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              logo,
              size: 50.0,
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: picked ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
