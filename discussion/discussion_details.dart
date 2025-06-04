import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'new_discussion_post.dart';

class DiscussionDetails extends StatefulWidget {
  const DiscussionDetails({super.key});

  @override
  State<DiscussionDetails> createState() => _DiscussionDetailsState();
}

class _DiscussionDetailsState extends State<DiscussionDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Discussion Details"),),
      body: Column(
        children: [

        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        elevation: 5.0,
        onPressed: () {
          Get.to(
                () => const DiscussionNewPost(),
            transition: Transition.rightToLeft,
            popGesture: true,
          );
        },
        child: const Icon(Icons.add),
      ),

    );
  }
}
