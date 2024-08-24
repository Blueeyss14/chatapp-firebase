import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID, senderEmail, receiverID, message;
  final Timestamp timestamp;


  Message({
   required this.senderID, required this.senderEmail, required this.receiverID, required this.message, required this.timestamp,
});

  //convert to Map-------------------------

  Map<String, dynamic> toMap() {
    return {
      'senderId' : senderID,
      'senderEmail' : senderEmail,
      'receiverId' : receiverID,
      'message' : message,
      'timestamp' : timestamp,
    };
  }
}