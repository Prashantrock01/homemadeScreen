import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../CustomWidgets/configurable_widgets.dart';
// import 'package:get/get.dart';

class ComingSoon extends StatefulWidget {
 final String appBarText;
 final bool leading;
 final Function? onLeadingIconPressed;
  const ComingSoon({required this.appBarText,required this.leading,this.onLeadingIconPressed,super.key, });

  @override
  State<ComingSoon> createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  List<ConnectivityResult>? _connectionStatus; // Make it nullable
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  /// Initialize connectivity status
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (_) {
      return;
    }

    if (!mounted) return;
    _updateConnectionStatus(result);
  }

  /// Update the internet connection status
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        _updateConnectionStatus(results);
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.leading
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.onLeadingIconPressed != null) {
              widget.onLeadingIconPressed!();
            } else {
              Navigator.pop(context);
            }
          },
        )
            : null,
        title: Text(widget.appBarText),
      ),
      body: _connectionStatus == null
          ? const Center(child: CircularProgressIndicator()) // Show loader initially
          : _connectionStatus!.contains(ConnectivityResult.none)
          ? checkInternetConnection(initConnectivity)
          : Stack(
        children: [
          Container(
            color: const Color(0xfffbdacb),
            constraints: const BoxConstraints.expand(),
            child: Image.network(
              'https://i.pinimg.com/736x/01/fd/3c/01fd3c00f4375188ad0c483d409de025.jpg',
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Image.network(
              'https://cdn-icons-png.flaticon.com/128/10656/10656236.png',
              fit: BoxFit.contain,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
