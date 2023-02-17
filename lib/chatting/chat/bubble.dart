import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';


class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.time, this.userName, this.message,this.isMe, {Key? key}) : super(key: key);

  final String time;
  final String message;
  final String userName;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        //발신자가 본인일 때
        if(isMe)
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,5,0),
              child: ChatBubble(
                clipper: ChatBubbleClipper2(type: BubbleType.sendBubble),
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 5, bottom : 5),
                backGroundColor: Colors.redAccent,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery
                        .of(context)
                        .size
                        .width * 0.7,
                  ),
                  child: Column(
                    children: [
                      //본인 _ 버블 _ 상단 _ 메시지
                      Text(
                        message,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      //본인 _ 버블 _ 중단 공간
                      SizedBox(height: 5),
                      //본인 _ 버블 _ 하단
                      Container(
                        padding: const EdgeInsets.fromLTRB(2,1,2,1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [BoxShadow(
                              color : Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset:Offset(0,1)
                          )],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //userName
                            Container(
                              child: Text(
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.end,
                                  userName,
                                  style : TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                            ),
                            //공간
                            SizedBox(width: 6,),
                            //시간
                            Text(
                              time,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

        //발신자가 상대방일 때
        if(!isMe)
          Padding(
            padding: const EdgeInsets.fromLTRB(5,0,0,0),
            child: ChatBubble(
              clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 5, bottom : 5),
              backGroundColor: Colors.grey,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery
                      .of(context)
                      .size
                      .width * 0.7,
                ),
                child: Column(
                  children: [
                    //상대방 _ 버블 _ 상단 _ 메시지
                    Text(
                      message,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    //상대방 _ 버블 _ 중단 공간
                    SizedBox(height: 5),
                    //상대방 _ 버블 _ 하단
                    Container(
                      padding: const EdgeInsets.fromLTRB(2,1,2,1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [BoxShadow(
                            color : Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset:Offset(0,1)
                        )],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //userName
                          Container(
                            child: Text(
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.end,
                                userName,
                                style : TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                          ),
                          //공간
                          SizedBox(width: 6,),
                          //시간
                          Text(
                            time,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

      ],
    );
  }
}
