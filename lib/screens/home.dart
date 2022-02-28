//หน้าหลัก

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/model/user_model.dart';
import 'package:fooddelivery_project/screens/main_chef.dart';
import 'package:fooddelivery_project/screens/main_rider.dart';
import 'package:fooddelivery_project/screens/main_user.dart';
import 'package:fooddelivery_project/screens/signin.dart';
import 'package:fooddelivery_project/screens/signup.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:fooddelivery_project/utility/my_style.dart';
import 'package:fooddelivery_project/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  //initState จำทำงานก่อน Build Context เมื่อทำการรัน
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPreferance();
  }

  //method checkPreferance
  Future<Null> checkPreferance() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String chooseType = preferences.getString('ChooseType').toString();
      String idLogin = preferences.getString('id').toString();
      print('idLogin === $idLogin');

      String? token = await FirebaseMessaging.instance.getToken();
      print(token);

      if (idLogin != null && idLogin.isNotEmpty) {
        String url =
            '${MyIpAddress().domain}/FoodDelivery/editTokenWhereId.php?isAdd=true&id=$idLogin&Token=$token';
        await Dio().get(url).then((value) {
          print('update successfully');
        });
      }

      //check status
      if (chooseType != '' && chooseType.isNotEmpty) {
        if (chooseType == 'User') {
          routeToService(MainUser());
        } else if (chooseType == 'Chef') {
          routeToService(MainChef());
        } else if (chooseType == 'Rider') {
          routeToService(MainRider());
        } else {
          //normalDialog(context, '');
        }
      }
    } catch (e) {}
  }

  //route ไปยังแต่ละหน้าของ ผู้ใช้
  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Delivery With Flutter',
          style: TextStyle(fontFamily: 'peach'),
        ),
      ),
      drawer: showDrawer(), //เรียกใช้ method showDrawer
    );
  }

  //method show Drawer or menu
  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(), //เรียก method showHeadDrawer menu
            signInMenu(), //เรียกใช้ method sigin เข้าสู่ระบบ
            signUpMenu(), //เรียกใช้ method sigup สมัครสมาชิก
          ],
        ),
      );

  //method เข้าสู่ระบบ
  ListTile signInMenu() {
    return ListTile(
      leading: Icon(Icons.login),
      title: Text(
        "เข้าสู่ระบบ",
        style: TextStyle(fontFamily: 'peach'),
      ),
      onTap: () {
        Navigator.pop(context); //pop close Drawer
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignIn());
        Navigator.push(context, route);
      },
    );
  }

  //method สมัครสมาชิก
  ListTile signUpMenu() {
    return ListTile(
      leading: Icon(Icons.login),
      title: Text(
        "สมัครสมาชิก",
        style: TextStyle(
          fontFamily: 'peach',
        ),
      ),
      //Route ไปยัง signup.dart
      onTap: () {
        Navigator.pop(context); //pop close Drawer
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignUp());
        Navigator.push(context, route);
      },
    );
  }

//method show Drawer
  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(
        'ยินดีต้อนรับ',
        style: TextStyle(
          fontFamily: 'peach',
          fontSize: 18.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: Text(
        'กรุณา ล็อคอิน',
        style: TextStyle(
          fontFamily: 'peach',
          fontSize: 20.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
