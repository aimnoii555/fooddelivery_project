//main

import 'package:dark_light_button/dark_light_button.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/auth/login.dart';
import 'package:fooddelivery_project/auth/register.dart';
import 'package:fooddelivery_project/customer/main_customer.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/restaurant/main_restaurant.dart';
import 'package:fooddelivery_project/rider/main_rider.dart';
import 'package:fooddelivery_project/style/color.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPreferences();
  }

  Future<Null> checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? type = preferences.getString('Type');
    String? id = preferences.getString('id');

    print('idLogin = $id, type = $type');

    if (type != '' && type!.isNotEmpty) {
      if (type == 'Customer') {
        MaterialPageRoute route =
            MaterialPageRoute(builder: (context) => MainCustomer());
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      } else if (type == 'Restaurant') {
        MaterialPageRoute route =
            MaterialPageRoute(builder: (context) => MainRestaurant());
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      } else if (type == 'Rider') {
        MaterialPageRoute route =
            MaterialPageRoute(builder: (context) => MainRider());
        Navigator.pushAndRemoveUntil(context, route, (route) => false);
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ยินดีต้อนรับ',
          style: MyFont().lookpeachWhite(),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text('ยินดีต้องรับ'),
                accountEmail: null,
                currentAccountPicture: Image.network(
                    'https://www.codemobiles.co.th/online/images/course_shortcut_flutter.png')),
            login(),
            register(),
          ],
        ),
      ),
      body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [
                Colors.blue,
                Colors.red,
              ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    child: Image.network(
                      'https://cdn4.iconfinder.com/data/icons/delivery-121/62/food-delivery-service-restaurant-order-256.png',
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    child: Image.network(
                      'https://www.codemobiles.co.th/online/images/course_shortcut_flutter.png',
                    ),
                  ),
                ],
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 50),
                  child: Text(
                    'แอปพลิเคชันจัดส่งอาหาร',
                    style: MyFont().lookpeachWhite25(),
                  ),
                ),
              )
            ],
          )),
    );
  }

  // method login class main
  ListTile login() {
    return ListTile(
      leading: Icon(Icons.login),
      title: Text(
        'เข้าสู่ระบบ',
        style: MyFont().lookpeach(),
      ),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => Login());
        Navigator.push(context, route);
      },
    );
  }

  // method register class main
  ListTile register() {
    return ListTile(
      leading: Icon(Icons.login_sharp),
      title: Text(
        'สมัครสมาชิก',
        style: MyFont().lookpeach(),
      ),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => Register());
        Navigator.push(context, route);
      },
    );
  }
}
