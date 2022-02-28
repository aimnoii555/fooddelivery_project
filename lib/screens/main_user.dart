//หน้าหลักของผู้ใช้

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/model/food_model.dart';
import 'package:fooddelivery_project/model/user_model.dart';
import 'package:fooddelivery_project/screens/cart.dart';
import 'package:fooddelivery_project/utility/exit_process.dart';
import 'package:fooddelivery_project/utility/my_style.dart';
import 'package:fooddelivery_project/widget/show_food_order.dart';
import 'package:fooddelivery_project/widget/show_list_chef_all.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainUser extends StatefulWidget {
  const MainUser({Key? key}) : super(key: key);

  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String nameUser = '';

  late Widget currenWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currenWidget = ShowListChefAll();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nameUser == '' ? 'Main User' : 'คุณ $nameUser'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (context) => Cart());
              Navigator.push(context, route);
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      drawer: showDrawer(),
      body: currenWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showHead(),
                menuStore(),
                order(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                logout(),
              ],
            ),
          ],
        ),
      );

  Widget menuStore() {
    return Container(
      child: ListTile(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currenWidget = ShowListChefAll();
          });
        },
        leading: Icon(Icons.store),
        title: Text(
          'แสดงร้านค้า',
          style: TextStyle(fontFamily: 'peach'),
        ),
        subtitle: Text(
          'แสดงร้านค้า ที่อยู่ใกล้คุณ',
          style: TextStyle(fontFamily: 'peach'),
        ),
      ),
    );
  }

  Widget order() {
    return Container(
      child: ListTile(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currenWidget = ShowFoodOrder();
          });
        },
        leading: Icon(Icons.list_alt),
        title: Text(
          'ออเดอร์',
          style: TextStyle(fontFamily: 'peach'),
        ),
        subtitle: Text(
          'รายการอาหารที่สั้ง',
          style: TextStyle(fontFamily: 'peach'),
        ),
      ),
    );
  }

  Widget logout() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
      ),
      child: ListTile(
        onTap: () => exit_process(context),
        leading: Icon(
          Icons.logout,
          color: Colors.white,
        ),
        title: Text(
          'ออกจากระบบ',
          style: TextStyle(fontFamily: 'peach', color: Colors.white),
        ),
      ),
    );
  }

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      currentAccountPicture: MyStyle().showLogo(),
      // decoration: MyStyle().myBoxDecoration('udru.jpg'),
      accountName: Text(
        nameUser == null ? 'Name Login' : nameUser,
        style: TextStyle(
          fontFamily: 'peach',
          fontSize: 18.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: Text(
        'Email Login',
        style: TextStyle(
          fontFamily: 'peach',
          fontSize: 20.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
