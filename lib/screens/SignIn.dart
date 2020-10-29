import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger1/FirebaseAuth.dart';
import 'package:messenger1/constansts%20and%20widgets.dart';
import 'package:messenger1/screens/SignUp.dart';
import 'package:messenger1/screens/forgotpassword.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'file:///C:/Users/Srinivas/StudioProjects/messenger1/lib/screens/HomeScreen.dart';

class loginpage extends StatefulWidget {
  loginpage({Key key, this.title,}) : super(key: key);
  final String title;

  @override
  _loginpageState createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User currentUserId;
  final formKEY = GlobalKey<FormState>();
  TextEditingController passwordtexteditingcontroller = TextEditingController();
  TextEditingController emailtexteditingcontroller = TextEditingController();
  bool isloading = false;
  Authmethods auth = Authmethods();
  firebasedatabase database = firebasedatabase();
  sharedpreference pref = sharedpreference();

  issignedinusingemail()async {
    setState(() {
      isloading = true;
    });
    User firebaseUser = await firebaseAuth.currentUser;
    String currentusername = await pref.gettingusername();
    if(firebaseUser != null){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  homescreen(currentusername: currentusername,currentuseremail:firebaseUser.email,)));
    }else{
      setState(() {
        isloading = false;
      });
    }
  }

  signinusinggoogle() async {
    setState(() {
      isloading = true;
    });
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    User firebaseuser =
        (await firebaseAuth.signInWithCredential(credential)).user;
    if (firebaseuser != null) {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseuser.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.length == 0) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseuser.uid)
            .set({
          'username': firebaseuser.displayName,
          'email': firebaseuser.email,

        });
        pref.settingusername(firebaseuser.displayName);
        pref.settingemail(firebaseuser.email);

      } else {
        pref.settingusername(documents[0].data()['username']);
        pref.settingemail(documents[0].data()['email']);

      }
      String currentusername = await pref.gettingusername();
        Fluttertoast.showToast(msg: "Sign in success");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    homescreen(currentusername: currentusername,currentuseremail: emailtexteditingcontroller.text,)));

    }
  }


  loading() async{
    if (formKEY.currentState.validate()) {
      setState(() {
        isloading = true;
      });
      database.searchuserwithemail(emailtexteditingcontroller.text).then((value){ if(value!=null) {
        pref.settingusername(value.docs[0].data()['username']);
        pref.settingemail(value.docs[0].data()['email']);
      }});
      String currentusername = await pref.gettingusername();
      auth
          .signinwithemailandpassword(emailtexteditingcontroller.text,
              passwordtexteditingcontroller.text)
          .then((value) { if(value!=null){  Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => homescreen(currentusername: currentusername ,currentuseremail: emailtexteditingcontroller.text,)));}else{
            setState(() {
              isloading=false;
              Fluttertoast.showToast(msg: "Incorrect Password or Username");
            });
      }
            } );
    }
  }


  @override
  void initState() {
    super.initState();
    issignedinusingemail();
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Scaffold(
        appBar: appbar(context, widget.title),
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
                        Form(
                          key: formKEY,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30.0,
                              ),
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
                                    fontSize: 30, fontWeight: FontWeight.w500),
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
                                      fontSize: 30.0,fontWeight: FontWeight.w500),
                                  decoration: inputDecoration('password')),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: (){
                                auth.resetpassword(emailtexteditingcontroller.text);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => forgotpassword()));
                              },
                              child: Container(
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontFamily: 'PaperFlowers',
                                      fontSize: 25.0,fontWeight: FontWeight.w500, decoration: TextDecoration.underline),
                                ),
                              ),
                            )),
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
                              child: Text('Sign In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PaperFlowers',
                                      fontSize: 45.0, fontWeight: FontWeight.w700)),
                            )),
                        SizedBox(
                          height: 12.0,
                        ),
                        GestureDetector(
                          onTap: () async{
                            await signinusinggoogle();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15)),
                            child: Text('Sign In with Google',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'PaperFlowers',
                                    fontSize: 45.0,fontWeight: FontWeight.w700)),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'PaperFlowers',
                                    fontSize: 25.0,fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Signup() ));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.purple,
                                        fontFamily: 'PaperFlowers',
                                        fontSize: 25.0, decoration: TextDecoration.underline),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
