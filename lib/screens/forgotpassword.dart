import 'package:flutter/material.dart';
import 'package:messenger1/constansts%20and%20widgets.dart';

class forgotpassword extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context, 'Forgot Password'),
      body: Container(padding: EdgeInsets.all(25.0),child: Column(children: [Text("Link for Password Reset has been sent to your email address.", textAlign:TextAlign.center ,style: TextStyle(
          color: Colors.black,
          fontFamily: 'PaperFlowers',
          fontSize: 50.0,fontWeight: FontWeight.w500),),
        SizedBox(height: 40,),
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(15),
            alignment: Alignment.center,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Text('Sign In with New Password', textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PaperFlowers',
                      fontSize: 35.0,fontWeight: FontWeight.w700)),
            ),
          ),
        )],),)
    );
  }
}
