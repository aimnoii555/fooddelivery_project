//page เข้าสู่ระบบ

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/model/user_model.dart';
import 'package:fooddelivery_project/screens/main_chef.dart';
import 'package:fooddelivery_project/screens/main_rider.dart';
import 'package:fooddelivery_project/screens/main_user.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:fooddelivery_project/utility/my_style.dart';
import 'package:fooddelivery_project/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //Field
  String user = '', password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "เข้าสู่ระบบ",
          style: TextStyle(
            fontFamily: 'peach',
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: <Color>[
              Colors.white,
              Colors.black54,
            ],
            center: Alignment(0, -0.3),
            radius: 1.0,
          ),
        ), //ไล่สี background
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MyStyle()
                    .showLogo(), //เรียกใช้ showLogo เพิ่อ แสดง Logo จาก utility/my_style.dart
                // Image.asset(
                //   'images/ice.png',
                //   width: 150.0,
                // ),
                Text(
                  "เข้าสู่ระบบ",
                  style: TextStyle(
                    fontFamily: 'peach',
                    fontSize: 24.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15.0),
                userForm(), //เรียกใช้ userForm
                SizedBox(height: 15.0),
                passwordForm(), //เรียกใช้ passwordForm
                SizedBox(height: 15.0),
                loginButton(), //เรียกใช้ Login
              ],
            ),
          ),
        ),
      ),
    );
  }

  //method ปุ่ม Login
  Widget loginButton() {
    return Container(
      width: 250.0,
      child: RaisedButton(
        color: Colors.blue,
        onPressed: () {
          //check user and password empty?
          if (user == '' ||
              user.isEmpty ||
              password == '' ||
              password.isEmpty) {
            normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
          } else {
            checkAuthen(); //method Authentication แยกประเภท
          }
        },
        child: Text(
          'เข้าสู่ระบบ',
          style: TextStyle(
            fontFamily: 'peach',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  //method Authenticaiton
  Future<Null> checkAuthen() async {
    String url =
        '${MyIpAddress().domain}/FoodDelivery/getUserWhereUser.php?isAdd=true&User=$user';

    try {
      Response response = await Dio().get(url);
      //print('res = $response');

      var result = json.decode(response.data);
      print('result = $result');
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          String chooseType = userModel.chooseType.toString();
          if (chooseType == 'User') {
            routeToService(MainUser(),
                userModel); //เมื่อผู้ใช้ Login เป็น User ไปยังหน้า ผู้ใช้ที่เป็นสมาชิก
          } else if (chooseType == 'Chef') {
            routeToService(MainChef(),
                userModel); // เมื่อผู้้ใช้ Login เป็น Chef ไปยังหน้า เจ้าของร้านอาหาร
          } else if (chooseType == 'Rider') {
            routeToService(MainRider(),
                userModel); //เมื่อผู้ใช้ Login เป็น Rider ไปยังหน้า พนักงานส่งอาหาร
          }
        } else {
          normalDialog(context, 'รหัสผ่านไม่ถูกต้อง');
        }
      }
    } catch (e) {}
  }

  //route ไปยังแต่ละหน้าของ ผู้ใช้ และส่ง id, chooseType, Name, User เมื่อ Login เสร็จ
  Future<Null> routeToService(Widget myWidget, UserModel userModel) async {
    //SharedPreferences ทำให้อยู่ในระบบต่อโดยไม่ต้องเข้า Login ตลอด
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', userModel.id.toString());
    preferences.setString('ChooseType', userModel.chooseType.toString());
    preferences.setString('Name', userModel.name.toString());
    preferences.setString('User', userModel.user.toString());

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(
        context, route, (route) => false); //แบบย้อนกลับไม่ได้
  }

  //method กรอก username
  Widget userForm() => Container(
        width: 250.0,
        child: TextField(
          //เมื่อกรอกข้อมูลบน TextField จะไปเก็บใน value
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_box),
            labelText: 'ชื่อผู้ใช้',
            labelStyle: MyStyle().fonts(),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.black), //borderSide show frame input
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      );

  //method กรอก password
  Widget passwordForm() => Container(
        width: 250.0,
        child: TextField(
          //เมื่อกรอกข้อมูลบน TextField จะไปเก็บใน value
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            labelText: 'รหัสผ้าน',
            labelStyle: MyStyle().fonts(),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.black), //borderSide show frame input
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      );
}
