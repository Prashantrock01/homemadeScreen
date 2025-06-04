import 'dart:async';

import 'package:flutter/material.dart';

class SendMessageAlert extends StatefulWidget {
  const SendMessageAlert({
    super.key,
    required this.icon,
    this.iconColor = Colors.white,
    required this.title,
    this.subtitle = '',
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  State<SendMessageAlert> createState() => _SendMessageAlertState();
}

class _SendMessageAlertState extends State<SendMessageAlert> {
  final _counter = ValueNotifier<int>(5);
  final _message = ValueNotifier<String>('Sending');
  final _isEnabled = ValueNotifier<bool>(false);
  late final Timer _task;

  void _startAlertTask() {
    _task = Timer.periodic(Durations.extralong4, (timer) {
      _counter.value -= 1;
      if (_counter.value == 0) {
        _task.cancel();
        _message.value = 'SOS message sent';
        _isEnabled.value = true;
      }
    });
  }

  void _cancelAlertTask() {
    _task.cancel();
    Future.delayed(Durations.long4, () {
      if (!mounted) return;
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    _startAlertTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Column(
          children: [
            const SizedBox(
              height: 50.0,
            ),
            SizedBox(
              height: 250.0,
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    height: 150.0,
                    margin: const EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    width: 150.0,
                    child: Icon(
                      widget.icon,
                      color: widget.iconColor,
                      size: 80.0,
                    ),
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white12,
                ),
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.zero,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: _counter,
                              builder: (context, counter, child) {
                                return SizedBox.square(
                                  dimension: 120.0,
                                  child: DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Transform.scale(
                                        scale: 6.0,
                                        child: Text(
                                          counter.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            ValueListenableBuilder(
                              valueListenable: _message,
                              builder: (context, msg, child) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20.0,
                                  ),
                                  child: Text(
                                    msg,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _isEnabled,
                      builder: (context, isEnabled, child) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),
                          child: AbsorbPointer(
                            absorbing: isEnabled,
                            child: SizedBox(
                              width: double.maxFinite,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.close),
                                label: const Text('Cancel Alert'),
                                onPressed: _cancelAlertTask,
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith((states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.red.shade600;
                                    }
                                    return Colors.red.shade400;
                                  }),
                                  foregroundColor: const WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                  padding: const WidgetStatePropertyAll(
                                    EdgeInsets.all(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
