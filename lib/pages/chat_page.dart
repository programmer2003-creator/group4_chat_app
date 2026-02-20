import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group4_chat_app/components/chat_bubble.dart';
import 'package:group4_chat_app/components/my_textfield.dart';
import 'package:group4_chat_app/services/auth/auth_service.dart';
import 'package:group4_chat_app/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget{
  final String receiverName;
  final String receiverID;

  ChatPage({
    super.key,
  required this.receiverName,
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

    //wait a bit for a list view
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
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
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
      title: Text(widget.receiverName),
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

    //is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    //align message
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(
              message: data['message'],
              isCurrentUser: isCurrentUser,
              timestamp: data['timestamp'],
            ),
            const SizedBox(height: 5)
      ],
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
