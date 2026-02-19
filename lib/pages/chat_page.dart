import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group4_chat_app/components/chat_bubble.dart';
import 'package:group4_chat_app/components/my_textfield.dart';
import 'package:group4_chat_app/services/auth/auth_service.dart';
import 'package:group4_chat_app/services/chat/chat_service.dart';


class ChatPage extends StatefulWidget{
  final String receiverEmail;
  final String receiverID;

   const ChatPage({
    super.key,
  required this.receiverEmail,
  required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    //add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        //cause a delay
        Future.delayed(
          const Duration(milliseconds: 500),
              () => scrollDown(),
        );
      }
    });

    //wait a bit for a lit view
    Future.delayed(const Duration(milliseconds: 500),
            () => scrollDown(),
    );
  }

    @override
    void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
    }

    //scroll controller
  final ScrollController _scrollController = ScrollController();
    void scrollDown() {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }



  //send message
  void sendMessage() async {
    //if there is something
    if (_messageController.text.isNotEmpty) {
      //send message
      await _chatService.sendMessage(widget.receiverID, _messageController.text);

    //clear text
      _messageController.clear();
    }

    scrollDown();
  }

@override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.receiverEmail),
      backgroundColor: Colors.black54,
      foregroundColor: Colors.grey,
      elevation: 0,
    ),

    body: Column(
      children: [
        //display all messages
        Expanded(child: _buildMessageList(),
  ),

        //user input
        _buildUserInput(),

      ],
    ),
    );
}

    //build message list
Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        //errors
        if (snapshot.hasError) {
          return const Text('Error');
        }

        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        //return list view
        return ListView(
          controller: _scrollController,
          children:
          snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
}

//build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser =
        data['senderID'] == _authService.getCurrentUser()!.uid;

    var alignment =
    isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    // get timestamp
    String formattedTime = '';
    if (data['timestamp'] != null) {
      Timestamp ts = data['timestamp'] as Timestamp;
      formattedTime = DateFormat('HH:mm').format(ts.toDate());
    }

    // construct chatRoomID
    List<String> ids = [
      data['senderID'],
      data['receiverID']
    ];
    ids.sort();
    String chatRoomID = ids.join('_');

    // ✅ ADD THIS: GestureDetector for long press
    return GestureDetector(
      onLongPress: isCurrentUser
          ? () async {
        bool confirm = await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete message?'),
            content:
            const Text('Are you sure you want to delete this message?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (confirm) {
          await _chatService.deleteMessage(chatRoomID, doc.id);
        }
      }
          : null,
      child: Container(
        alignment: alignment,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Column(
          crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(
              message: data['message'],
              isCurrentUser: isCurrentUser,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }


//build message input
Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom:50.0),
    child: Row(
      children: [
        //textfield
        Expanded(child: MyTextField(
          hintText: 'Type a message...',
          obscureText: false,
          controller: _messageController,
          focusNode: myFocusNode,

          //send using enter key
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              sendMessage();
            }
          },
        ),
        ),

        //send button
        Container(
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
  ),
       margin: const EdgeInsets.only(right: 25),
       child: IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.send,
          color: Colors.white,
          ),
  ),
        ),
      ],
    ),
  );
}
}
