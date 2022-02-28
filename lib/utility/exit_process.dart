import 'package:flutter/material.dart';
import 'package:fooddelivery_project/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

//method ออกจากระบบ
Future<Null> exit_process(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear(); //clear all
  //exit(0); //ให้ทำการปิด app

  MaterialPageRoute route = MaterialPageRoute(builder: (context) => Home());
  Navigator.pushAndRemoveUntil(context, route, (route) => false);
}
