import 'package:chatapp6/auth/chat/chat_service.dart';
import 'package:chatapp6/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChatPage({super.key, required this.receiverUserEmail, required this.receiverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();


  void sendMessage() async {
    //only send message if there is something to send------------
      if (_messageController.text.isNotEmpty) {
        await _chatService.sendMessage(
            widget.receiverUserID, _messageController.text);

        //clear the text controller after sending the message---------
        _messageController.clear();
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body: Column(
        children: [
          Expanded(
              child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }
  //mesage Message List--------------------
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserID,
          _firebaseAuth.currentUser!.uid
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          //jump to new chat
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          });

          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
          );
        },
    );
  }


  //build message item-------
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align the message to the right
    Alignment alignment;
    if ((data['senderId'] == _firebaseAuth.currentUser!.uid)) {
      alignment = Alignment.centerRight;
    } else {
      alignment = Alignment.centerLeft;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(data['senderEmail']),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(10),
                  bottomRight: const Radius.circular(10),
                  topRight: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? const Radius.circular(0)
                      : const Radius.circular(10),
                topLeft: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? const Radius.circular(10)
                    : const Radius.circular(0),
              ),
              color: Colors.blue[200],
              
            ),
              child: Text(data['message'], style: const TextStyle(fontSize: 18),),
          ),
        ],
      ),
    );
  }


  //build message input-------
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
            child: MyTextfield(
                controller: _messageController,
                hintText: "Enter message",
                obscureText: false),
        ),

        IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_upward, size: 40,)
        )
      ],
    );
  }


}
