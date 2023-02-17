import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState () => _HomePageState();
}
class _HomePageState extends State<HomePage>{

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Chat App")
      ),
      body : Container(
        padding : EdgeInsets.symmetric(horizontal: 8),
        child : Row(
        children : [
          Expanded(
              child: TextField(
                  decoration: InputDecoration(hintText: 'Send a Message'),
                  controller: _textEditingController,
                  onSubmitted:(String text){
                    print("onSubmitted_text : $text");
                  }
              )
          ),
          SizedBox(
            width : 8.0
          ),
          TextButton(
              onPressed: (){
                print(_textEditingController.text);
              },

              child: Text("Send"),
              style:TextButton.styleFrom(foregroundColor: Colors.amberAccent))


        ]
      )
      )
    );
  }
}
