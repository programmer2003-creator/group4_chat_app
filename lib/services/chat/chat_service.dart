import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group4_chat_app/models/message.dart';


class ChatService {

  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  //get user stream
  /*
  List<Map<String, dynamic>=

  [
  {
  'email': wenseslauslidakule@gmail.com,
  'id': ..
  },


  {
  'email': wenseslauslidakule@gmail.com,
  'id': ..
  },
]

   */
Stream<List<Map<String, dynamic>>> getUserStream(){
return _firestore.collection('Users').snapshots().map((snapshot) {
  return snapshot.docs.map((doc) {
    //go through each individual data
    final user= doc.data();

    //return user
    return user;
  }).toList();

});

  }
//delete message
  Future<void> deleteMessage(String chatRoomID, String messageID) async {
    await FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomID)
        .collection('messages')
        .doc(messageID)
        .delete();
  }


  //send sms
Future<void> sendMessage(String receiverID,message) async {
  //get current user info
final String currentUserID = _auth.currentUser!.uid;
final String currentUserEmail = _auth.currentUser!.email!;
final Timestamp timestamp = Timestamp.now();



//create a new message

  //create a new message
  Message newMessage = Message(senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp
  );


  //construct chat room
  List<String> ids = [currentUserID, receiverID];
  ids.sort();
String chatRoomID = ids.join('_');

  //add new sms to database
  await _firestore
      .collection('ChatRooms')
      .doc(chatRoomID)
      .collection('messages')
      .add(newMessage.toMap());
}


  //get message
Stream<QuerySnapshot> getMessages(String userID,otherUserID ) {
  //construct chat roomID
  List<String> ids = [userID, otherUserID];
  ids.sort();
  String chatRoomID = ids.join('_');
  return _firestore
      .collection('ChatRooms')
      .doc(chatRoomID)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots();

}
}