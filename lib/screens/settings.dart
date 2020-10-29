import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger1/FirebaseAuth.dart';
import 'package:messenger1/constansts%20and%20widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messenger1/screens/HomeScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class settings extends StatefulWidget {
  settings({this.username,this.email});
  String username;
  final String email;
  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {
  TextEditingController usernametexteditingcontroller = TextEditingController();
  Authmethods auth = Authmethods();
  firebasedatabase database = firebasedatabase();
  String photourl;
  File _imageFile;
  @override


  photourlforuser() async {

    QuerySnapshot snapshot = await database.searchuser(widget.username);
    setState(() {
      photourl = snapshot.docs[0].data()["photourl"];
    });
  }

  Future updatingImageToFirebase(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
    String fileName = basename(_imageFile.path);
    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('uploads/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value) {setState(() {
            photourl = value;
          });}
    );
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    photourlforuser();
    usernametexteditingcontroller.text = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, 'Settings'),
      body: SingleChildScrollView(
        child: Container(child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                width: 50,
                height: 50,
                child: IconButton(
                  icon: Icon(FontAwesomeIcons.eraser,
                    size: 30.0,
                    color: Colors.white,),
                  onPressed: (){
                    setState(() {
                      photourl = null;
                    });
                  },
                ),
              ),
              SizedBox(width: 10,),
              Container(
                child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.white,
                    child:ClipOval(
                      child: SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child: photourl != null ? Image.network(photourl, fit: BoxFit.fill,) : Icon(
                            Icons.account_circle,
                            size: 150.0,
                          )
                      ),
                    )
                ),
              ),
              SizedBox(width: 10,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                width: 50,
                height: 50,
                child: IconButton(
                  icon: Icon(FontAwesomeIcons.camera,
                    size: 30.0,
                    color: Colors.white,),
                  onPressed: (){
                    updatingImageToFirebase(context);
                  },
                ),
              )
            ],
          ),
          Container(child: Align(alignment: Alignment.centerLeft,child: Text('Username:', style: TextStyle(color: Colors.purple, fontSize:45.0, fontFamily: 'PaperFlowers', fontWeight: FontWeight.w600),)),),
          Container(
            child: new TextFormField(
              style: TextStyle(color: Colors.black, fontSize:45.0, fontFamily: 'PaperFlowers'),
              decoration: InputDecoration(hintText: "Please enter your new username", hintStyle: TextStyle(color: Colors.black45, fontSize:45.0, fontFamily: 'PaperFlowers', fontWeight: FontWeight.w500), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black45))),
              autocorrect: false,
              controller: usernametexteditingcontroller,
            ),
          ),
          SizedBox(height: 40,),
          GestureDetector(
            onTap: () async {
              await auth.resetpassword(widget.email);
              Fluttertoast.showToast(msg: "Reset Password link sent to registered email.");
            },
            child: Container(padding: EdgeInsets.symmetric(vertical: 10.0),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(15)),
              child: Text('Change Password',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PaperFlowers',
                      fontSize: 45.0, fontWeight: FontWeight.w700)),),
          ),
          SizedBox(height: 40,),
          GestureDetector(
            onTap: () async {
              QuerySnapshot snapshot = await database.searchuser(widget.username);
              await snapshot.docs[0].reference.update({"username": usernametexteditingcontroller.text });
              await snapshot.docs[0].reference.update({"photourl": photourl });
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homescreen(currentuseremail: widget.email, currentusername: usernametexteditingcontroller.text)));
              },
            child: Container(padding: EdgeInsets.symmetric(vertical: 10.0),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(15)),
              child: Text('Save',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PaperFlowers',
                      fontSize: 45.0, fontWeight: FontWeight.w700)),),
          ),
        ],),),
      ),
    );
  }
}
