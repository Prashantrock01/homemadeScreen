import 'package:flutter/cupertino.dart';

class DailyHelp extends StatefulWidget {
  const DailyHelp({super.key});

  @override
  State<DailyHelp> createState() => _DailyHelpState();
}

class _DailyHelpState extends State<DailyHelp> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: Column(
        children: [
          Text("Daily Help")
        ],
      ),
    );
  }
}
