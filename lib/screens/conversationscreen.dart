import 'package:flutter/material.dart';
import 'package:messenger1/FirebaseAuth.dart';
import 'package:messenger1/call_methods.dart';
import 'package:messenger1/constansts%20and%20widgets.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger1/Utils/permissions.dart';
import 'package:messenger1/pickuplayout.dart';

class conversation extends StatefulWidget {
  conversation({this.username, this.currentusername,this.chatroomID});
  final username;
  final currentusername;
  final String chatroomID;
  @override
  _conversationState createState() => _conversationState();
}


class _conversationState extends State<conversation> {
  TextEditingController chattexteditingcontroller = TextEditingController();
  firebasedatabase database = firebasedatabase();
  Stream messagestream;
  String token ='';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String currentuserid;

  void getToken() async {
    token = await firebaseMessaging.getToken();
  }


  Widget chatMessages(){
    return StreamBuilder(
      stream: messagestream,
      builder: (context, snapshot){
        return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context,index){
            return messageTile(snapshot.data.documents[index].data()["message"], snapshot.data.documents[index].data()['sentby'] == widget.currentusername);
          },
        ) : Container();
      },
    );
  }


  sendingmessage(){
    if(chattexteditingcontroller.text != null){
      Map<String, dynamic> messageMap = {
        'message' : chattexteditingcontroller.text,
        'sentby' : widget.currentusername,
        'time' : DateFormat.jm().format(new DateTime.now()),
        'token' : token
      };
      database.addingmessages(widget.chatroomID, messageMap);
      chattexteditingcontroller.text = "";
    }
  }

  gettingcurrentuserId(String username) async {
    QuerySnapshot snapshotforpickup = await database.searchuser(username);
    setState(() {
      currentuserid = snapshotforpickup.docs[0].id;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    gettingcurrentuserId(widget.currentusername);
    getToken();
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            alert: true,
            badge: true,
            provisional: true,
            sound: true
        )
    );
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //_showItemDialog(message);
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );
    print('${widget.currentusername}');
    super.initState();
    database.getmessages(widget.chatroomID).then((value){
      setState(() {
        messagestream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return pickupLayout(userId: currentuserid,
      Scaffold: Scaffold(
        appBar: appbar(context, widget.username),
        body: Container(
          child: Stack(
            children: [
              chatMessages(),
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextField(
                        onChanged: (value){

                        },
                        controller: chattexteditingcontroller,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'PaperFlowers',
                            fontSize: 25.0, fontWeight: FontWeight.w500),
                        decoration: inputDecoration('send a message.....'),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: GestureDetector(
                            onTap: () {
                              sendingmessage();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(color: Colors.purple,shape: BoxShape.circle,),
                                      width: 50,
                                      height: 50,
                                      padding: EdgeInsets.all(2),
                                      child: Image.asset(
                                          'android/assets/images/send1.png')),
                                ),
                                Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(color: Colors.purple,shape: BoxShape.circle,),
                                      width: 50,
                                      height: 50,
                                      padding: EdgeInsets.all(2),
                                      child: IconButton(
                                        icon: Icon(Icons.video_call ,color: Colors.white,),
                                        color: Colors.purple,
                                        onPressed: () async {
                                          QuerySnapshot caller = await database.searchuser(widget.currentusername);
                                          QuerySnapshot receiver = await  database.searchuser(widget.username);
                                          await Permissions.cameraAndMicrophonePermissionsGranted() ? callUtils.dial(caller, receiver, context) : {};
                                        },
                                      )
                                  ),
                                )
                              ],
                            )))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class messageTile extends StatelessWidget {
  messageTile(this.message, this.issentbyme);
  String message;
  bool issentbyme;
  @override
  Widget build(BuildContext context) {
    return Container( 
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      alignment: issentbyme? Alignment.centerRight : Alignment.centerLeft ,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: issentbyme ? Colors.purple : Colors.black45,
          borderRadius: issentbyme ? BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25), bottomLeft: Radius.circular(25)) : BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25), bottomRight: Radius.circular(25))
        ),
        child: Text(message, style: TextStyle(
            color: Colors.white,
            fontFamily: 'PaperFlowers',
            fontSize: 25.0),),
      ),
    );
  }
}
