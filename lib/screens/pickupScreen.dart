import 'package:flutter/material.dart';
import 'package:messenger1/call.dart';
import 'package:messenger1/call_methods.dart';
import 'package:messenger1/screens/callScreen.dart';
import 'package:messenger1/Utils/permissions.dart';


class pickUp extends StatelessWidget {
  pickUp({Call this.call});
  final Call call;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Incoming Call......', style: TextStyle(
                color: Colors.black,
                fontFamily: 'PaperFlowers',
                fontSize: 150.0,
                fontWeight: FontWeight.w600),),
            SizedBox(height:50),
            Text(call.receiverName,style: TextStyle(
                color: Colors.black,
                fontFamily: 'PaperFlowers',
                fontSize: 100.0,
                fontWeight: FontWeight.w600) ),
            SizedBox(height: 75,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: Icon(Icons.call_end),color: Colors.redAccent, onPressed: ()async{
                await callMethods().endCall(call);
              },),
              SizedBox(width: 25,),
              IconButton(icon: Icon(Icons.call),color: Colors.green, onPressed: () async {await Permissions.cameraAndMicrophonePermissionsGranted() ?
                Navigator.push(context, MaterialPageRoute(builder: (context) => callScreen(call: call,uid: call.callerID,),)) : {};
              },)
            ],)
          ],
        ),
      ),
    );
  }
}
