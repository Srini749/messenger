import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget appbar(BuildContext context, String text){
  return AppBar(title: Center(
    child: Text(
    text,
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 30.0, fontFamily: 'TheStudentsTeacher',  ),),
  ),
    backgroundColor: Colors.purple,   );
}

InputDecoration inputDecoration(String text){
 return InputDecoration(hintText: text, hintStyle: TextStyle(color: Colors.black45), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black45)));
}




