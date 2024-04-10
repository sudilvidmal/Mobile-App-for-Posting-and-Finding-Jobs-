import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobee/models/message.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  //get instance of firebase and auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream
  /*


  */
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through each individual user
        final user = doc.data();

        // return user
        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String receiverID, message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    //construct chat room ID for the two users (stored to ensure uniqeness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // sort the ids (this ensure the chtroomID ids the same for any 2 people)
    String chatRoomID = ids.join('_');

    //add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //construct a chatroom ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
