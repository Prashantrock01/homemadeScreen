import 'package:biz_infra/Model/buy_and_sell/chats/buy_and_sell_comments_creation_modal.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatWithSeller extends StatefulWidget {
  const ChatWithSeller({super.key, required this.entryId});

  final String entryId;

  @override
  State<ChatWithSeller> createState() => _ChatWithSellerState();
}

class _ChatWithSellerState extends State<ChatWithSeller> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _textFieldFocus = FocusNode();
  final TextEditingController _textController = TextEditingController();
  List<Map<String, dynamic>> messages = []; // Store fetched comments

  @override
  void initState() {
    super.initState();
    _textFieldFocus.addListener(() {
      if (_textFieldFocus.hasFocus) {
        _scrollToBottom();
      }
    });

    // Fetch initial comments
    fetchBuyAndSellCommentsList(recordId: widget.entryId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textFieldFocus.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> fetchBuyAndSellCommentsList({required String? recordId}) async {
    try {
      final commentsListing =
          await dioServiceClient.getBuyAndSellCommentsList(recordId: recordId);

      if (commentsListing != null) {
        setState(() {
          messages = commentsListing.data!.map<Map<String, dynamic>>((comment) {
            return {
              'sender': comment.userName,
              'message': comment.commentcontent,
              'time': comment.createdtime,
              'profileImage': comment.userImage,
            };
          }).toList();
        });

        _scrollToBottom(); // Auto-scroll after updating messages
      }
    } catch (e) {
      print("Error fetching comments: $e");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    if (_textController.text.trim().isNotEmpty) {
      String messageText = _textController.text.trim();
      _textController.clear();

      try {
        BuyAndSellCommentsCreationModal? res =
            await dioServiceClient.commentBuyAndSell(
          commentContent: messageText,
          relatedTo: widget.entryId,
        );

        if (res!.statuscode == 1) {
          await fetchBuyAndSellCommentsList(recordId: widget.entryId);
          _scrollToBottom();
        } else {
          Get.snackbar(
            "Oops!",
            res.statusMessage!,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          "Oops!! Failed to send message",
          e.toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Seller'),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(message['profileImage'] ?? ""),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: message['sender'] == 'You'
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['sender'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    message['message'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    message['time'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _textFieldFocus,
                    controller: _textController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      hintText: "Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(14.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
