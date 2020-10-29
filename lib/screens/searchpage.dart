import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger1/FirebaseAuth.dart';
import 'package:messenger1/constansts and widgets.dart';
import 'package:messenger1/screens/conversationscreen.dart';
import 'package:messenger1/pickuplayout.dart';

class searchpage extends StatefulWidget {
  @override
  _searchpageState createState() => _searchpageState();
}

class _searchpageState extends State<searchpage> {
  TextEditingController searchusertexteditingcontroller =
      TextEditingController();
  firebasedatabase database = firebasedatabase();
  QuerySnapshot querysnapshot;
  Widget container = Container();
  bool isloading = false;
  String changingtext = "";
  String currentuserid;

  createChatRoomforusername(String username) async {
    String currentusername = await sharedpreference().gettingusername();
    List<String> users = [username, currentusername ];
    String chatroomID = await database.gettingchatroomid(username,currentusername);
    Map<String, dynamic> chatroomMap= {
      "users": users,
      "chatroomID" : chatroomID,
    };
    database.createchatRoom(chatroomID, chatroomMap);
    Navigator.push(context, MaterialPageRoute(builder: (context) => conversation(username: username, currentusername: currentusername,chatroomID: chatroomID,)));
  }


  Widget searchTile({String username,
  String email}){
    return Container(
      color: Colors.white10,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex:5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("User :" ,style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'PaperFlowers',
                    fontSize: 25.0,
                        fontWeight: FontWeight.w600),
                ),SizedBox(width: 5,),
                        Text(
                         username,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'PaperFlowers',
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Email :", style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'PaperFlowers',
                            fontSize: 25.0, fontWeight: FontWeight.w600)),
                        SizedBox(width: 5,),
                        Text(
                          email,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'PaperFlowers',
                              fontSize: 25.0, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: (){setState(() {
                    createChatRoomforusername(username);
                  });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        'Message',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'PaperFlowers', fontSize: 25.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Divider()
        ],
      ),
    );
  }



  Widget searchlist() {
    return querysnapshot != null
        ? ListView.builder(
      shrinkWrap: true,
            itemCount: querysnapshot.docs.length,
            itemBuilder: (context, index) {
              return searchTile(
                username: querysnapshot.docs[index].data()["username"],
                email: querysnapshot.docs[index].data()["email"],
              );
            },
          )
        : Container(child: Center(child: Text(changingtext, style: TextStyle(
        color: Colors.black,
        fontFamily: 'PaperFlowers',
        fontSize: 25.0),)),);
  }

  gettingcurrentuserId() async {
    String currentusername = await sharedpreference().gettingusername();
    QuerySnapshot snapshotforpickup = await database.searchuser(currentusername);
    setState(() {
      currentuserid = snapshotforpickup.docs[0].id;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingcurrentuserId();
  }


    @override
  Widget build(BuildContext context) {
    return pickupLayout(userId: currentuserid,
      Scaffold: Scaffold(
        appBar: appbar(context, "SEARCH USER"),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: TextField(
                          onChanged: (value){
                            database
                                .searchuser(
                                value)
                                .then((value) { if(value!=null){}setState(() {
                              querysnapshot = value;
                            });});
                          },
                          controller: searchusertexteditingcontroller,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'PaperFlowers',
                              fontSize: 25.0, fontWeight: FontWeight.w500),
                          decoration: inputDecoration('search user.....'),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isloading = true;
                                });
                                database
                                    .searchuser(
                                        searchusertexteditingcontroller.text)
                                    .then((value) { setState(() {
                                      isloading = false;
                                  querysnapshot = value;
                                  querysnapshot == null? changingtext = "No Result." : null;
                                    });});
                              },
                              child: Container(
                                  decoration: BoxDecoration(color: Colors.purple,
                                      shape: BoxShape.circle, ),
                                  padding: EdgeInsets.all(5),
                                  child: Icon(Icons.search, color: Colors.white,size: 35,),)))
                    ],
                  ),
                ),
                isloading ? Container(
                  child: Center(child: CircularProgressIndicator()),
                ): searchlist()
              ],
            ),
          ),
        ),
      ),
    );
  }
}



