import 'package:messaging/config/Palette.dart';
import 'package:messaging/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//stateful widget 선언
class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {

  bool showSpinner = false;

  //사용자 인증에 적용될 FireBase Auth instance객체
  //변할일이 없고 외부 접근을 막기위하여 final private선언
  final _authentication = FirebaseAuth.instance;

  //Sign up 화면인지 확인
  bool isSignupScreen = true;

  //form을 지정할 formkey
  final _formKey = GlobalKey<FormState>();

  //onSaved시 적용될 변수
  String userName = "";
  String userMail = "";
  String userPassword = "";

  //validation Method 제작
  void _tryValidation(){
    final isValid = _formKey.currentState!.validate();
    if(isValid){
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              //배경 포지션
              Positioned(
                  top: 0,
                  right :0,
                  left : 0,
                  child: Container(
                    decoration : BoxDecoration(
                        image : DecorationImage(
                            image: AssetImage('image/sunset.jpg'),
                            fit : BoxFit.fill
                        )
                    ),
                    padding : EdgeInsets.only(top:90,left:20),
                    height : 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                              text : 'Welcome',
                              style : TextStyle(
                                letterSpacing: 1.0,
                                fontSize: 25,
                                color : Colors.white,
                                shadows: [Shadow(
                                  offset: Offset(1,1),
                                  blurRadius: 2,
                                  color: Colors.orangeAccent,
                                )]
                              ),
                              children: [
                                TextSpan(
                                  text : isSignupScreen ? ' to Our Chat!' : ' Back!',
                                  style : TextStyle(
                                    letterSpacing: 1.0,
                                    fontSize: 25,
                                    color : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    shadows: [Shadow(
                                      offset: Offset(1,1),
                                      blurRadius: 2,
                                      color: Colors.orangeAccent,
                                    )]
                                  )
                                )
                              ]
                            )
                        ),
                        SizedBox(height:8),
                        Text(
                            isSignupScreen ? 'Sign up to continue' : 'sign in to continue',
                          style : TextStyle(
                            letterSpacing: 1.0,
                            fontSize: 12,
                            color : Colors.white,
                            shadows: [Shadow(
                              offset: Offset(1,1),
                              blurRadius: 2,
                              color: Colors.orangeAccent,
                            )]
                          )
                        )
                      ],
                    ),
                  )
              ),
              //텍스트 폼 포지션
              AnimatedPositioned(
                duration : Duration(milliseconds: 300),
                curve : Curves.easeIn,
                top : 180,
                child: AnimatedContainer(
                  duration : Duration(milliseconds: 300),
                  curve : Curves.easeIn,
                  width : MediaQuery.of(context).size.width-40,
                  margin : EdgeInsets.symmetric(horizontal: 20), padding : EdgeInsets.all(20),
                  height : isSignupScreen ? 280 : 250,
                  decoration:
                    BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow:[
                        BoxShadow(
                          color : Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5
                        ),
                    ],
                  ),
                  child : SingleChildScrollView(
                    padding : EdgeInsets.only(bottom:20),
                    child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //로그인 탭
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    isSignupScreen = false;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text('LOGIN',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color : isSignupScreen ? Palette.textColor1 : Palette.activeColor,
                                      )
                                    ),
                                    if(!isSignupScreen)
                                    Container(
                                      margin : EdgeInsets.only(top:3),
                                      height : 2,
                                      width : 55,
                                      color : Colors.orange,
                                    )
                                  ],
                                ),
                              ),
                              //사인업 탭
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    isSignupScreen = true;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Text('SIGN UP',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color : isSignupScreen ? Palette.activeColor : Palette.textColor1,
                                      )
                                    ),
                                    if(isSignupScreen)
                                    Container(
                                      margin : EdgeInsets.only(top:3),
                                      height : 2,
                                      width : 55,
                                      color : Colors.orange,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //Login 메뉴 텍스트폼
                          if(!isSignupScreen)
                          Container(
                            margin: EdgeInsets.only(top:20),
                            child: Form(
                              key : _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    key : ValueKey(1),
                                    validator: (value){
                                      if(value!.isEmpty || value!.length <5){
                                        return 'Email 주소는 5글자 이상 적어야 해!';
                                      }
                                      return null;
                                    },
                                    onSaved: (value){
                                      userMail = value!;
                                    },
                                    onChanged: (value){
                                      userMail = value;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.account_circle,
                                        color : Palette.iconColor
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color : Palette.textColor1,
                                        ),
                                        borderRadius:BorderRadius.all(
                                          Radius.circular(35),
                                        )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color : Palette.textColor1,
                                          ),
                                            borderRadius:BorderRadius.all(
                                              Radius.circular(35),
                                            )
                                      ),
                                    hintText: 'E-Mail 주소',
                                    hintStyle: TextStyle(
                                        color : Palette.textColor1,
                                        fontSize: 14,
                                      ),
                                    contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                  SizedBox(height:8),
                                  TextFormField(
                                    key : ValueKey(2),
                                    obscureText: true,
                                    validator: (value){
                                      if(value!.isEmpty || value!.length < 5 ){
                                        return "비밀번호는 6글자 이상이야!";
                                      }
                                      return null;
                                    },
                                    onSaved:(value){
                                      userPassword=value!;
                                    },
                                    onChanged: (value){
                                      userPassword = value;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.account_circle,
                                          color : Palette.iconColor
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color : Palette.textColor1,
                                          ),
                                          borderRadius:BorderRadius.all(
                                            Radius.circular(35),
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color : Palette.textColor1,
                                          ),
                                          borderRadius:BorderRadius.all(
                                            Radius.circular(35),
                                          )
                                      ),
                                      hintText: '비밀번호',
                                      hintStyle: TextStyle(
                                        color : Palette.textColor1,
                                        fontSize: 14,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Sign up 메뉴 텍스트폼
                          if(isSignupScreen)
                          Container(
                            margin: EdgeInsets.only(top:20),
                            child: Form(
                              key : _formKey,
                              child: Column(
                                children: [
                                  //username TextForm
                                  TextFormField(
                                    key : ValueKey(3),
                                    validator: (value){
                                     if(value!.isEmpty || value!.length <3){
                                        return '닉네임은 3글자 이상 적어야 해!';
                                     }
                                     return null;
                                    },
                                    onSaved: (value){
                                      userName = value!;
                                    },
                                    onChanged: (value){
                                      userName = value;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.account_circle,
                                          color : Palette.iconColor
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color : Palette.textColor1,
                                          ),
                                          borderRadius:BorderRadius.all(
                                            Radius.circular(35),
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color : Palette.textColor1,
                                          ),
                                          borderRadius:BorderRadius.all(
                                            Radius.circular(35),
                                          )
                                      ),
                                      hintText: '닉네임',
                                      hintStyle: TextStyle(
                                        color : Palette.textColor1,
                                        fontSize: 14,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                  SizedBox(height:8),
                                  //email TextForm
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    key : ValueKey(4),
                                    validator: (value){
                                      if(value!.isEmpty || !value!.contains('@')){
                                        return "올바른 E-Mail 주소로 적어!";
                                      }
                                      return null;
                                    },
                                    onSaved : (value){
                                      userMail = value!;
                                    },
                                    onChanged: (value){
                                      userMail = value;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.account_circle,
                                          color : Palette.iconColor
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color : Palette.textColor1,
                                          ),
                                          borderRadius:BorderRadius.all(
                                            Radius.circular(35),
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color : Palette.textColor1,
                                          ),
                                          borderRadius:BorderRadius.all(
                                            Radius.circular(35),
                                          )
                                      ),
                                      hintText: 'E-Mail',
                                      hintStyle: TextStyle(
                                        color : Palette.textColor1,
                                        fontSize: 14,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                  SizedBox(height:8),
                                  //Password TextForm
                                  TextFormField(
                                    obscureText: true,
                                    key : ValueKey(5),
                                    validator: (value){
                                      if(value!.isEmpty || value!.length < 5){

                                        return '비밀번호는 5글자 이상이라고!';
                                      }
                                      return null;
                                    },
                                    onSaved: (value){
                                      userPassword = value!;
                                    },
                                    onChanged: (value){
                                      userPassword = value;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.account_circle,
                                          color : Palette.iconColor
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color : Palette.textColor1,
                                          ),
                                          borderRadius:BorderRadius.all(
                                            Radius.circular(35),
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color : Palette.textColor1,
                                          ),
                                          borderRadius:BorderRadius.all(
                                            Radius.circular(35),
                                          )
                                      ),
                                      hintText: 'password',
                                      hintStyle: TextStyle(
                                        color : Palette.textColor1,
                                        fontSize: 14,
                                      ),
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                    ),
                  )
                ),
              ),
              //Submit Btn 포지션
              AnimatedPositioned(
                duration : Duration(milliseconds: 300),
                curve : Curves.easeIn,
                top : isSignupScreen ? 420 : 390,
                right : 0,
                left :0,
                child: Center(
                  child: Container(
                    padding : EdgeInsets.all(15),
                    height : 70,
                    width : 70,
                    decoration: BoxDecoration(
                      color : Colors.white,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child : GestureDetector(
                      onTap: () async{
                        setState(() {
                          showSpinner = true;
                        });
                        _tryValidation();
                        if(isSignupScreen){
                          try {
                            final newUser = await _authentication
                                .createUserWithEmailAndPassword(
                              email: userMail,
                              password: userPassword,
                            );

                            await FirebaseFirestore.instance.collection('user')
                                .doc(newUser.user!.uid)
                                .set({
                                  'username' : userName,
                                  'email' : userMail
                                });

                            if(newUser.user != null){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context){
                                      return ChatScreen();
                                    }
                                    )
                                );
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          }catch(e){
                            print(e);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('이미 등록된 메일주소야!')
                              )
                            );
                            setState(() {
                              showSpinner = false;
                            });
                            FocusScope.of(context).unfocus();
                            return;
                          }
                        }else if(!isSignupScreen){
                          _tryValidation();
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            //로그인을 시도할 것이나, 결과가 없으면 catch문으로 보낸다.
                            final newUser = await _authentication.signInWithEmailAndPassword(
                                email: userMail,
                                password: userPassword
                            );
                            if (newUser.user != null) {
                              /*Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return ChatScreen();
                                  }
                                  )
                              );*/
                            }else{
                              return;
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          }catch(e){
                            Alert('로그인 정보를 확인하시기 바랍니다.');
                            showSpinner=false;
                          }
                        }

                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular((50),
                            ),
                          gradient: LinearGradient(
                            colors : [Colors.orange, Colors.red],
                            begin : Alignment.topLeft,
                            end : Alignment.bottomRight,
                            ),
                          boxShadow: [
                            BoxShadow(
                              color : Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset:Offset(0,1)
                            )
                          ]
                          ),
                        child : Icon(Icons.arrow_forward,color : Colors.white)
                        ),
                    ),
                    )
                  ),
                ),
              //Google Login Btn
              /*AnimatedPositioned(
                duration : Duration(milliseconds: 300),
                curve : Curves.easeIn,
                top:isSignupScreen ? MediaQuery.of(context).size.height-80 : MediaQuery.of(context).size.height-165,
                right : 0,
                left : 0,
                child : Column(
                  children:[
                    Text(isSignupScreen ? 'or Sign Up With' : 'or Sign In With' ),
                    SizedBox(height : 10),
                    TextButton.icon(
                      onPressed: (){},
                      style:TextButton.styleFrom(
                        primary : Colors.white,
                        minimumSize: Size(155,40),
                        shape : RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        backgroundColor: Palette.googleColor,
                      ),
                      icon : Icon(Icons.add),
                      label : Text('Google'),
                    )
                  ]
                )
              )*/
            ],
          ),
        ),
      ),
    );
  }

  //Dialog
  void Alert(String message){
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Icon(Icons.lock_outlined,color: Colors.orangeAccent),
                Text("아,문제가 있네 이거"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('뭘 가만히 보고 있는거야,', style : TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.bold)),
                Text("로그인 정보에 문제가 있는거 같다고!", style : TextStyle(color: Colors.orangeAccent, fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    showSpinner = false;
                  });
                },
              ),
            ],
          );
        });
  }

}
