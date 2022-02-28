//page สม้ครสมาชิก

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:fooddelivery_project/utility/my_style.dart';
import 'package:fooddelivery_project/utility/normal_dialog.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String chooseType = '', name = '', user = '', password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "สมัครสมาชิก",
          style: TextStyle(
            fontFamily: 'peach',
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          myLogo(), //เรียกใช้ logo จาก utility/my_style.dart
          SizedBox(height: 15.0),
          showAppName(), //เรียกใช้งาน method showAppName
          SizedBox(height: 15.0),
          nameForm(), //เรียกใช้งาน method nameForm เพื่อกรอก ชื่อ
          SizedBox(height: 15.0),
          userForm(), //เรียกใช้งาน method userForm เพื่อกรอก ชื่อผู้ใช้
          SizedBox(height: 15.0),
          passwordForm(), //เรียกใช้งาน method passwordForm เพื่อกรอก รหัสผ่าน
          SizedBox(height: 15.0),
          text(), //เรียกใช้งาน method text
          SizedBox(height: 15.0),
          userChoose(), //method เลือก ผู้ใช้ที่เป็นสมาชิก
          chefChoose(), //method เจ้าของร้านหาร
          riderChoose(), //method พนักงานส่งอาหาร
          registerButton() //method register
        ],
      ),
    );
  }

//method text แสดงข้อความ
  Widget text() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "เลือกผู้ใช้งาน",
        style: TextStyle(
          fontFamily: 'peach',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //method userChoose ผู้สั่งอาหาร
  Widget userChoose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 250.0,
          child: Row(
            children: [
              Radio(
                value: 'User',
                groupValue: chooseType,
                onChanged: (value) {
                  setState(
                    () {
                      //เมื่อกรอกข้อมูลบน radio จะไปเก็บใน value
                      chooseType = value.toString();
                    },
                  );
                },
              ),
              Text(
                'ผู้สั่งอาหาร',
                style: TextStyle(fontFamily: 'peach'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //method chefChoose เจ้าของร้านอาหาร
  Widget chefChoose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 250.0,
          child: Row(
            children: [
              Radio(
                value: 'Chef',
                groupValue: chooseType,
                onChanged: (value) {
                  setState(
                    () {
                      chooseType = value.toString();
                    },
                  );
                },
              ),
              Text(
                'เจ้าของร้านอาหาร',
                style: TextStyle(fontFamily: 'peach'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //method riderChoose พนักงานส่งอาหาร
  Widget riderChoose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 250.0,
          child: Row(
            children: [
              Radio(
                value: 'Rider',
                groupValue: chooseType,
                onChanged: (value) {
                  setState(
                    () {
                      chooseType = value.toString();
                    },
                  );
                },
              ),
              Text(
                'พนังงานส่งอาหาร',
                style: TextStyle(fontFamily: 'peach'),
              ),
            ],
          ),
        ),
      ],
    );
  }

//method แสดงชื่อ สมัครสมาชิก
  Row showAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "สมัครสมาชิก",
          style: TextStyle(fontFamily: 'peach', fontSize: 24.0),
        ),
      ],
    );
  }

//method showLogo
  Widget myLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().showLogo(),
        ],
      );

  //method กรอก name
  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) =>
                  name = value.trim(), //เมื่อกรอกจะเก็บไว้ที่ value
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.face),
                labelText: 'ชื่อ',
                labelStyle: MyStyle().fonts(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), //borderSide show frame input
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      );

  //method กรอก username
  Widget userForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => user = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_box),
                labelText: 'ชื่อผู้ใช้',
                labelStyle: MyStyle().fonts(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), //borderSide show frame input
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      );

  //method กรอก password
  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => password = value.trim(),
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'รหัสผ่าน',
                labelStyle: MyStyle().fonts(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black), //borderSide show frame input
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      );

  //ยิง package ไปยัง Server เมื่อทำการสมัครสมาชิก Insert User ลง databasse
  Future<Null> registerThread() async {
    String url =
        '${MyIpAddress().domain}/FoodDelivery/addUser.php?isAdd=true&Name=$name&User=$user&Password=$password&ChooseType=$chooseType';

    try {
      Response response = await Dio().get(url);
      print('res = $response');

      //เมื่อการทำสมัคร successfully กลับไปยังหน้าแรก
      if (response.toString() == 'true') {
        Navigator.pop(context); //เมื่อสมัรเสร็จ pop ไปหน้าแรก
        normalDialog(context, 'สมัครเรียบร้อยแล้ว');
      } else {
        normalDialog(context, 'ไม่สามารถสมัครได้ กรุณาลองใหม่อีกครั้ง');
      }
    } catch (e) {}
  }

  //method check User ซ้ำ โดย Get User จาก database
  Future<Null> checkUser() async {
    String url =
        '${MyIpAddress().domain}/FoodDelivery/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      //checkUser ว่างไหม
      if (response.toString() == 'null') {
        registerThread(); //เมื่อ User ไม่มีให้ทำการสมัครสมาชิก
      } else {
        normalDialog(context, 'ชื่อผู้ใช้ $user ถูกใช้แล้ว');
      }
    } catch (e) {}
  }

  //method ปุ่ม register
  Widget registerButton() {
    return Container(
      width: 250.0,
      child: RaisedButton(
        color: Colors.blue,
        onPressed: () {
          print(
              'name = $name, user = $user, password = $password, chooseType = $chooseType');
          //check empty
          if (name == '' ||
              name.isEmpty ||
              user == '' ||
              user.isEmpty ||
              password == '' ||
              password.isEmpty) {
            print("name empty");
            normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ !!');
          } else if (chooseType == '') {
            normalDialog(context, 'กรุณาเลือกผู้ใช้งาน');
          } else {
            //เมื่อไม่มีแจ้งเตือนอะไรให้ทำการยิงไปยัง Server หรือ database
            checkUser(); //method check User ซ้ำ
          }
        },
        child: Text(
          'สมัครสมาชิก',
          style: TextStyle(
            fontFamily: 'peach',
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
