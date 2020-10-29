import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger1/screens/callScreen.dart';
import 'call.dart';

class callMethods{
  final CollectionReference callCollection =
    FirebaseFirestore.instance.collection('call_collection');

  Stream<DocumentSnapshot> callStream({String uid}) {
    return callCollection.doc(uid).snapshots();
  }

  Future<bool> makeCall(Call call) async {
    try{call.hasDialed = true;
    Map<String, dynamic> hasDialedMap = call.toMap(call);
    call.hasDialed = false;
    Map<String, dynamic> hasnotDialedMap = call.toMap(call);

    await callCollection.doc(call.callerID).set(hasDialedMap);
    await callCollection.doc(call.receiverID).set(hasnotDialedMap);
    return true;}catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> endCall(Call call) async{
    try{
      await callCollection.doc(call.callerID).delete();
      await callCollection.doc(call.receiverID).delete();
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }


}

class callUtils{
  static callMethods methods = callMethods();
  static dial (QuerySnapshot caller, QuerySnapshot receiver, context) async{
    Call call = Call(
      callerID: caller.docs[0].id,
      callerName: caller.docs[0].data()["username"],
      callerPic: caller.docs[0].data()["photourl"],
      receiverID: receiver.docs[0].id,
      receiverName: receiver.docs[0].data()["username"],
      receiverPic: receiver.docs[0].data()["photourl"],
       channelID: Random().nextInt(1000).toString(),
    );
    bool callMade = await callMethods().makeCall(call);
    call.hasDialed = true;
    if(callMade){
      Navigator.push(context, MaterialPageRoute(builder: (context) => callScreen(call: call, uid: caller.docs[0].id,),));
    }

  }
}

