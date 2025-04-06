import 'package:clinicc/core/utils/colors.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final bool isRead;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding:
            const EdgeInsets.only(left: 15, top: 25, bottom: 25, right: 25),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? AppColors.color1 : Colors.grey[300],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isMe)
              Text(
                isRead ? 'Read' : 'Delivered',
                style: TextStyle(
                  fontSize: 10,
                  color: isMe ? Colors.white70 : Colors.black54,
                ),
              ),
          ],
        ),
      ),
    );
  }
}