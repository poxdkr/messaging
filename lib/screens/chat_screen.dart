import 'package:messaging/chatting/chat/message.dart';
import 'package:messaging/chatting/chat/new_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();

  }

  void getCurrentUser(){
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.accessibility_new),
        title: Text('우리끼리 쓰는 채팅방!'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
              icon : Icon(Icons.exit_to_app),
              color : Colors.white,
              onPressed: (){
                _authentication.signOut();
                /*Navigator.pop(context);*/
              },
          )
        ],
      ),

      //body를 그려주기 전에 StreamBuilder를 통해 정보를 받아옴
      body : GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Container(
          child : Column(
            children: [
              Expanded(
                  child: Messages()
              ),
              NewMessage()
            ],
          )
        ),
      )
    );
  }
}
