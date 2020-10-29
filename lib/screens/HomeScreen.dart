import 'package:flutter/material.dart';
import 'package:messenger1/FirebaseAuth.dart';
import 'package:messenger1/screens/SignIn.dart';
import 'package:messenger1/screens/searchpage.dart';
import 'package:messenger1/screens/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'conversationscreen.dart';
import 'package:messenger1/pickuplayout.dart';

class homescreen extends StatefulWidget {
  homescreen({Key key, this.currentuseremail, @required this.currentusername})
      : super(key: key);
  final String currentuseremail;
  final String currentusername;
  String lastmessage = "";
  @override
  _homescreenState createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  Authmethods auth = Authmethods();
  firebasedatabase database = firebasedatabase();
  Stream chatroomstream;
  String lastmessage;
  String photourl;
  bool isloading = false;
  String currentuserid;

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }

  photourlforuser(username) async {
    isloading = true;
    firebasedatabase database = firebasedatabase();
    QuerySnapshot snapshot = await database.searchuser(username);
    setState(() {
      photourl = snapshot.docs[0].data()["photourl"];
      isloading = false;
    });
  }

  Widget chatlist() {
    return StreamBuilder(
      stream: chatroomstream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  photourlforuser(snapshot.data.documents[index]
                      .data()["chatroomID"]
                      .toString()
                      .replaceAll("_", "")
                      .replaceAll(widget.currentusername, ""));
                  return chatroomTile(
                      widget.currentusername,
                      snapshot.data.documents[index]
                          .data()["chatroomID"]
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(widget.currentusername, ""),
                      snapshot.data.documents[index]
                          .data()["lastmessage"]
                          .toString(),
                      snapshot.data.documents[index]
                          .data()["lastsendinguser"]
                          .toString(),
                      snapshot.data.documents[index]
                          .data()["timeoflastmessage"]
                          .toString(),
                      photourl,
                      snapshot.data.documents[index]
                          .data()["chatroomID"]
                          .toString());
                })
            : Container();
      },
    );
  }

  gettingcurrentuserId(String username) async {
    QuerySnapshot snapshotforpickup = await database.searchuser(username);
    setState(() {
      currentuserid = snapshotforpickup.docs[0].id;
    });

  }

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();

    gettingcurrentuserId(widget.currentusername);

    database.gettingchatroomforhomescreen(widget.currentusername).then((value) {
      setState(() {
        chatroomstream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return pickupLayout(userId: currentuserid,
      Scaffold: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "Messenger Chats",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 30.0,
                  fontFamily: 'TheStudentsTeacher'),
            ),
          ),
          backgroundColor: Colors.purple,
          actions: [


            Theme(
              data: Theme.of(context).copyWith(
                cardColor: Colors.purple,
              ),
              child: PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Logout', 'Settings'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: GestureDetector(
                          onTap: () async {
                            if (choice == 'Logout') {
                              await auth.signout();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => loginpage(
                                            title: 'MY MESSENGER',
                                          )));
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => settings(
                                          username: widget.currentusername,
                                          email: widget.currentuseremail)));
                            }
                          },
                          child: Text(
                            choice,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'TheStudentsTeacher',
                                fontSize: 30.0, fontWeight: FontWeight.w600),
                          )),
                    );
                  }).toList();
                },
              ),
            ),
          ],
        ),
        body: isloading ? Container(
          child: Center(child: CircularProgressIndicator()),
        ) : chatlist(),
        floatingActionButton: new FloatingActionButton(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
              width: 100,
              height: 100,
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.search, color: Colors.white,size: 39,),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => searchpage()));
            }),
      ),
    );
  }
}

class chatroomTile extends StatelessWidget {
  chatroomTile(
      this.currentuser,
      this.username,
      this.lasttext,
      this.lastsendinguser,
      this.lastmessagetime,
      this.photourl,
      this.chatroomID);
  final currentuser;
  final String username;
  String lasttext;
  String lastsendinguser;
  String lastmessagetime;
  String photourl;
  String chatroomID;

  @override
  Widget build(BuildContext context) {
    homescreen home = homescreen(currentusername: currentuser);

    return Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => conversation(
                        username: username,
                        currentusername: currentuser,
                        chatroomID: chatroomID,
                      )));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3,),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(right: 20),
                      child: CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: photourl == null ? Icon(
                                  Icons.account_circle,
                                  size: 64.0,
                                ): Image.network(
                                  photourl,
                                  fit: BoxFit.fill,
                                )),
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'PaperFlowers',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(lastmessagetime,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'PaperFlowers',
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w600),)
                          ],
                        ),
                        Row(
                          children: [
                            Text(lastsendinguser == currentuser
                                ? "You:"
                                : "$lastsendinguser:",style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'PaperFlowers',
                                fontSize: 25.0, fontWeight: FontWeight.w600)),
                            SizedBox(width: 8,),
                            Text(lasttext,style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'PaperFlowers',
                                fontSize: 25.0, fontWeight: FontWeight.w400) )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider()
            ],
          ),
        ),
      ),
    );
  }
}
