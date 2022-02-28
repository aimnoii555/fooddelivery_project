import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/model/user_model.dart';
import 'package:fooddelivery_project/utility/exit_process.dart';
import 'package:fooddelivery_project/utility/my_style.dart';
import 'package:fooddelivery_project/utility/normal_dialog.dart';
import 'package:fooddelivery_project/widget/infomation_chef.dart';
import 'package:fooddelivery_project/widget/list_food_menu.dart';
import 'package:fooddelivery_project/widget/order_list_chef.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainChef extends StatefulWidget {
  const MainChef({Key? key}) : super(key: key);

  @override
  _MainChefState createState() => _MainChefState();
}

class _MainChefState extends State<MainChef> {
  String name = '', user = '';
  UserModel? userModel;
//Field
  Widget currentWidget =
      OrderListChef(); //ดึง data จาก class OrderListChef มาเก็บไว้ currentWidget

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
    aboutNotification();
  }

  Future<Null> aboutNotification() async {
    if (Platform.isAndroid) {
      print('android');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message ---------------------------------------: ${message.notification}');
          normalDialogIcon(context, 'Order', 'มี Order จากลูกค้า');
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message ---------------------------------------: ${message.notification}');
          normalDialogIcon(context, 'Order', 'มี Order จากลูกค้า');
        }
      });
    } else if (Platform.isIOS) {
      print('ios');
    }
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('Name').toString();
      user = preferences.getString('User').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name == '' ? 'Main Chef' : 'ร้านของคุณ $name'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              exit_process(context); //from utility/logout_process.dart
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      drawer: showDrawer(), //method show Drawer
      body: currentWidget,
    );
  }

  Drawer showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          showHead(), //method Drawer
          homeMenu(), //method homeMenu ราายการอาหารที่ลูกค้าสั่ง
          foodMenu(), //method รายการอาหารของร้านค้า
          detailMenu(), //method รายละเอียดที่อยู่ร้านค้า
          logout(), //logout ออกจากระบบ
        ],
      ),
    );
  }

  ListTile homeMenu() => ListTile(
        leading: Icon(
          Icons.home,
          color: Colors.green,
        ),
        title: Text(
          'รายการอาหารที่ลูกค้าสั่ง',
          style: TextStyle(fontFamily: 'peach'),
        ),
        subtitle: Text(
          'รายการอาหารที่ยังไม่ได้ ทำส่งลูกค้า',
          style: TextStyle(fontFamily: 'peach'),
        ),
        onTap: () {
          setState(() {
            currentWidget =
                OrderListChef(); //ดึง Widget ของ OrderListChef มาแสดง
          });
          Navigator.pop(context);
        },
      );

  ListTile foodMenu() => ListTile(
        leading: Icon(
          Icons.fastfood,
          color: Colors.green,
        ),
        title: Text(
          'รายการอาหาร',
          style: TextStyle(fontFamily: 'peach'),
        ),
        subtitle: Text(
          'รายการอาหาร ของร้านค้า',
          style: TextStyle(fontFamily: 'peach'),
        ),
        onTap: () {
          setState(() {
            currentWidget = ListFoodMenu(); //ดึง Widget ของ ListFoodMenu มาแสดง
          });
          Navigator.pop(context);
        },
      );

  ListTile detailMenu() => ListTile(
        leading: Icon(
          Icons.details,
          color: Colors.green,
        ),
        title: Text(
          'รายละเอียด ที่อยู่ร้านค้า',
          style: TextStyle(
            fontFamily: 'peach',
          ),
        ),
        onTap: () {
          setState(() {
            currentWidget =
                InformationChef(); // ดึง Widget ของ Information มาแสดง
          });
          Navigator.pop(context);
        },
      );

  ListTile logout() => ListTile(
        leading: Icon(
          Icons.logout,
          color: Colors.red,
        ),
        title: Text(
          'ออกจากระบบ',
          style: TextStyle(fontFamily: 'peach'),
        ),
        onTap: () {
          exit_process(context);
        },
      );

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      currentAccountPicture: MyStyle().showLogo(),
      // decoration: MyStyle().myBoxDecoration('udru.jpg'),
      arrowColor: Colors.green,
      accountName: Text(
        'ร้านคุณ $name',
        style: TextStyle(
          fontFamily: 'peach',
          fontSize: 18.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: Text(
        'ชื่อผู้ใช้ $user',
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
