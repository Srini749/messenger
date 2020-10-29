import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messenger1/FirebaseAuth.dart';
import 'package:messenger1/constansts and widgets.dart';
import 'package:messenger1/screens/HomeScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'dart:io';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController usernametexteditingcontroller = TextEditingController();
  TextEditingController emailtexteditingcontroller = TextEditingController();
  TextEditingController passwordtexteditingcontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isloading = false;
  Authmethods authmethods = Authmethods();
  firebasedatabase database = firebasedatabase();
  sharedpreference pref = sharedpreference();
  File _imageFile;
  String photourl = "";

  Future uploadImageToFirebase(BuildContext context) async {
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
          (value) => photourl = value,
    );
  }

  loading() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isloading = true;
      });
      Map<String, String> userMap = {
        'username': usernametexteditingcontroller.text,
        'email': emailtexteditingcontroller.text,
        'photourl': photourl,
      };
      database.uploaduserinfo(userMap);
      pref.settingusername(usernametexteditingcontroller.text);
      pref.settingemail(emailtexteditingcontroller.text);
      authmethods
          .signupwithemailandpassword(emailtexteditingcontroller.text,
              passwordtexteditingcontroller.text)
          .then((value) => Navigator.pushReplacement(
              this.context,
              MaterialPageRoute(
                  builder: (context) => homescreen(
                        currentusername: usernametexteditingcontroller.text,
                        currentuseremail: emailtexteditingcontroller.text,
                      ))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, "Sign Up"),
      body: isloading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
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
                                  photourl = "";
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
                                  child: photourl==""? Icon(
                                    Icons.account_circle,
                                    size: 180.0,
                                  ) : Image.network(photourl, fit: BoxFit.fill,)
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
                                uploadImageToFirebase(context);
                              },
                            ),
                          )
                        ],
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30.0,
                            ),
                            TextFormField(
                              validator: (val) {
                                return val.length < 2 || val.isEmpty
                                    ? "Please provide a valid Username"
                                    : null;
                              },
                              controller: usernametexteditingcontroller,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'PaperFlowers',
                                  fontSize: 35.0, fontWeight: FontWeight.w500),
                              decoration: inputDecoration('username'),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Please provide a valid email";
                              },
                              controller: emailtexteditingcontroller,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'PaperFlowers',
                                  fontSize: 35.0, fontWeight: FontWeight.w500),
                              decoration: inputDecoration('email'),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                                obscureText: true,
                                validator: (val) {
                                  return val.length < 7 || val.isEmpty
                                      ? "Please provide a valid Password"
                                      : null;
                                },
                                controller: passwordtexteditingcontroller,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'PaperFlowers',
                                    fontSize: 35.0, fontWeight: FontWeight.w500),
                                decoration: inputDecoration('password')),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      GestureDetector(
                          onTap: () {
                            loading();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(15)),
                            child: Text('Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'PaperFlowers',
                                    fontSize: 45.0,fontWeight: FontWeight.w700)),
                          )),
                      SizedBox(
                        height: 12.0,
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'PaperFlowers',
                                  fontSize: 25.0, fontWeight: FontWeight.w500,),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontFamily: 'PaperFlowers',
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.underline),
                                    )))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
