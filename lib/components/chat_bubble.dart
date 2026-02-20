import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final Timestamp? timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.green : Colors.grey.shade500,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          if (timestamp != null)
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                DateFormat('hh:mm a').format(timestamp!.toDate()),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
