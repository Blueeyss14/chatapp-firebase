import 'package:chatapp6/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //Send Message------------------------

  Future<void> sendMessage(String receiverID, String message ) async {
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create new message---------------------------
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp
    );

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomId = ids.join("_");

    //add new message to database-------------------------------
    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
  }

  //get message-------------------
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //sorted to ensure it matches the id used when sending message----------

    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomID = ids.join("_");

    return _firestore.collection('chat_rooms')
        .doc(chatRoomID).collection('messages')
        .orderBy('timestamp', descending: false).snapshots();
  }

}