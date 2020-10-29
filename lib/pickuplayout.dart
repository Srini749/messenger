import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger1/screens/pickupScreen.dart';
import 'call.dart';
import 'call_methods.dart';
import 'package:flutter/material.dart';

class pickupLayout extends StatelessWidget {
  final userId;
  final Widget Scaffold;

  pickupLayout({@required this.Scaffold, @required this.userId });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot> (
      stream: callMethods().callStream(uid: userId),
      builder: (context, snapshot){
        if(snapshot.hasData && snapshot.data.data() != null){
          Call call = Call.fromMap(snapshot.data.data());
          if(call.hasDialed != true){return pickUp(call: call,);
          }else{
            return Scaffold;
          }
        }
        return Scaffold;
      },
    );
  }
}
