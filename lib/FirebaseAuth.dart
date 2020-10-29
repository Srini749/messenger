import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Authmethods {
  final FirebaseAuth auth  = FirebaseAuth.instance;

  Future signinwithemailandpassword(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);
      User firebaseuser = result.user;
      return firebaseuser != null ? firebaseuser.uid : null;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signupwithemailandpassword(String email, String password) async{
    try{UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
    User firebaseuser = result.user;
    return firebaseuser != null ? firebaseuser.uid : null;}
    catch (e) {
      print(e.toString());
    }
  }

  Future resetpassword(String email)async{
    try{
      return await auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signout()async{
    try{
      await auth.signOut();

    }catch(e){
      print(e.toString());
    }
  }

}


class firebasedatabase{

  uploaduserinfo( Map<String, String> userMap){
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  Future searchuser(String username)async{
    return await FirebaseFirestore.instance.collection('users').where("username", isEqualTo: username,).get();
  }

  Future searchuserwithemail(String email)async{
    return await FirebaseFirestore.instance.collection('users').where("email", isEqualTo: email).get();
  }

  createchatRoom(String chatID, chatroomMap)async{
    return await FirebaseFirestore.instance.collection("chatroom").doc(chatID).set(chatroomMap);
  }
  gettingchatroomid(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return '$b\_$a';
    }else{
      return '$a\_$b';
    }
  }
  
  addingmessages(String chatroomID, Map messageMap) async{

    await FirebaseFirestore.instance.collection('chatroom').doc(chatroomID).collection('chats').add(messageMap).catchError((e){print(e.toString());});
    await FirebaseFirestore.instance.collection('chatroom').doc(chatroomID).update({"lastmessage" : messageMap['message'], "lastsendinguser" : messageMap['sentby'], "timeoflastmessage" : messageMap['time'] });

  }

  getmessages(String chatroomID,) async{
   return await FirebaseFirestore.instance.collection('chatroom').doc(chatroomID).collection('chats').orderBy('time', descending: false).snapshots();
  }

  gettingchatroomforhomescreen(String username) async {
    return await FirebaseFirestore.instance.collection('chatroom').where("users", arrayContains: username).snapshots();
  }

  gettinglastmessageforachatroom(String chatroomID)async {
    await FirebaseFirestore.instance.collection('chatroom').doc(chatroomID).collection('chats').orderBy('time', descending: true).get();
  }

}

class sharedpreference {
  settingusername(String username) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString("username", username);
  }
  settingemail(String email)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString("email", email);
  }
  gettingusername()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("username");
  }
  gettingemail()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

}













