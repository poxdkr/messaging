import 'bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat')
                                      .orderBy('time_stamp',descending: true)
                                      .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;
        return ListView.builder(
          reverse:  true,
          itemCount: chatDocs.length,
          itemBuilder: (context,index){

              return ChatBubbles(
                  chatDocs[index]['time'],
                  chatDocs[index]['userName'],
                  chatDocs[index]['text'],
                  chatDocs[index]['userID'] == user!.uid
              );
            }

          );
      },
    );
  }
}
