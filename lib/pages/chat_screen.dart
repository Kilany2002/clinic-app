import 'package:clinicc/core/constants/constant_data.dart';
import 'package:clinicc/core/utils/colors.dart';
import 'package:clinicc/models/message.dart';
import 'package:clinicc/widgets/chat_bubble.dart';
import 'package:clinicc/widgets/chat_bubble_friend.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  static String id = 'ChatScreen';
  final ScrollController controller = ScrollController();
  final TextEditingController messageController = TextEditingController();
  final CollectionReference messages =
      FirebaseFirestore.instance.collection(kcollectinName);

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<dynamic>(
        stream: messages.orderBy(kcreatedAt, descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Message> messagesList = snapshot.hasData && snapshot.data != null
              ? snapshot.data!.docs
                  .map<Message>((doc) => Message.fromJson(doc))
                  .toList()
              : [];

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.color1,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  const Text(
                    'Messages',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: messagesList.isEmpty
                      ? const Center(child: Text('No messages yet.'))
                      : ListView.builder(
                          reverse: true,
                          controller: controller,
                          itemCount: messagesList.length,
                          itemBuilder: (context, index) =>
                              messagesList[index].id == email
                                  ? ChatBubble(
                                      message: messagesList[index],
                                      color: kprimaryColor,
                                    )
                                  : ChatBubbleFriend(
                                      color: const Color(0xff006388),
                                      message: messagesList[index],
                                    ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: TextField(
                    controller: messageController,
                    onSubmitted: (value) => _sendMessage(value, email),
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        color: kprimaryColor,
                        onPressed: () =>
                            _sendMessage(messageController.text, email),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kprimaryColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _sendMessage(String value, dynamic email) {
    if (value.trim().isEmpty) return;
    messages.add({
      'text': value,
      kcreatedAt: DateTime.now(),
      'id': email,
    });
    messageController.clear();
    controller.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }
}
