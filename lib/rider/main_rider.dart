import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/auth/login.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/main_page.dart';
import 'package:fooddelivery_project/model/order.dart';
import 'package:fooddelivery_project/restaurant/order.dart';
import 'package:fooddelivery_project/rider/acceptOrder.dart';
import 'package:fooddelivery_project/rider/cal_total_income_rider.dart';
import 'package:fooddelivery_project/rider/data_rider.dart';
import 'package:fooddelivery_project/rider/my_account.dart';
import 'package:fooddelivery_project/rider/order.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainRider extends StatefulWidget {
  const MainRider({Key? key}) : super(key: key);

  @override
  State<MainRider> createState() => _MainRiderState();
}

class _MainRiderState extends State<MainRider> {
  Widget? changePage;
  String? firstName;
  String? lastName, image;

  Order? orderr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changePage = ShowOrderCus();
    getRider();
  }

  Future<Null> getRider() async {
    await Firebase.initializeApp().then((value) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? idRider = preferences.getString('id');
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? token = await firebaseMessaging.getToken();
      print('token = $token');

      String url =
          '${MyHost().domain}/Project_Flutter/FoodDelivery/editTokenWhereId.php?isAdd=true&Token=$token&id=$idRider';

      await Dio().get(url).then((value) {
        print('update successfully');
      });

      FirebaseMessaging.onMessage.listen((event) {
        String? title = event.notification!.title;
        String? body = event.notification!.body;
        // dialog(context, 'ออเดอร์ = $title, จาก=$body');

        print('OpenApp title = $title, body = $body');
      });

      // Close App
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        String? title = event.notification!.title;
        String? body = event.notification!.body;
        print('CloseApp title = $title, body = $body');
        // dialog(context, 'ออเดอร์ = $title, จาก=$body');
      });
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      firstName = preferences.getString('firstName');
      lastName = preferences.getString('lastName');
      image = preferences.getString('Image');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${firstName}'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Color(0xFF778899),
                  backgroundImage: NetworkImage('${MyHost().domain}/${image}'),
                ),
                accountName: Text(
                  '${firstName}',
                  style: MyFont().lookpeachWhite(),
                ),
                accountEmail: null,
              ),
              dataOrderInfo(),
              // order(),
              editDataRider(),
              myAccount(),
              calTotalIncomeRider(),
              SizedBox(height: 420),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                ),
                title: Text(
                  'ออกจากระบบ',
                  style: MyFont().lookpeach18(),
                ),
                onTap: () {
                  MaterialPageRoute route =
                      MaterialPageRoute(builder: ((context) => MainPage()));
                  Navigator.pushAndRemoveUntil(
                      context, route, (route) => false);
                  dialog(context, 'ออกจากระบบเรียบร้อย');
                },
              ),
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
                Color.fromARGB(255, 223, 158, 153),
              ])),
          child: changePage,
        ));
  }

  ListTile calTotalIncomeRider() {
    return ListTile(
      leading: const Icon(Icons.manage_accounts),
      title: Text(
        'ข้อมูลส่วนตัว',
        style: MyFont().lookpeach18(),
      ),
      onTap: () {
        setState(() {
          changePage = const DataRider();
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile editDataRider() {
    return ListTile(
      leading: const Icon(Icons.monetization_on),
      title: Text(
        'ดูรายได้',
        style: MyFont().lookpeach18(),
      ),
      onTap: () {
        setState(
          () {
            changePage = const CalTotalIcomeRider();
          },
        );
        Navigator.pop(context);
      },
    );
  }

  ListTile dataOrderInfo() {
    return ListTile(
      leading: const Icon(Icons.list_alt),
      title: Text(
        'ออเดอร์ที่ลูกค้าสั่ง',
        style: MyFont().lookpeach18(),
      ),
      onTap: () {
        setState(
          () {
            changePage = const ShowOrderCus();
          },
        );
        Navigator.pop(context);
      },
    );
  }

  ListTile myAccount() {
    return ListTile(
      leading: const Icon(Icons.list_alt),
      title: Text(
        'บัญชี',
        style: MyFont().lookpeach18(),
      ),
      onTap: () {
        setState(
          () {
            changePage = const MyAccountRider();
          },
        );
        Navigator.pop(context);
      },
    );
  }

  ListTile order() {
    return ListTile(
      leading: const Icon(Icons.receipt_long),
      title: Text(
        'ออเดอร์',
        style: MyFont().lookpeach18(),
      ),
      onTap: () async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? idRider = preferences.getString('id');
        String url =
            '${MyHost().domain}/Project_Flutter/FoodDelivery/getOrderWhereIdRiderAccept.php?isAdd=true&idRider=$idRider';

        await Dio().get(url).then((value) {
          var result = json.decode(value.data);
          if (result == null) {
            dialog(context, 'ไม่มีออเดอร์');
          }
          print('result ============= $result');
          if (result.toString() != null) {
            for (var map in result) {
              orderr = Order.fromJson(map);
            }
          }
        });
        setState(
          () {
            // print('order Id ========= ${orderr!.id}');
            // changePage = AcceptOrder(
            //   idCus: '${orderr!.idCus}',
            //   idOrder: '${orderr!.id}',
            //   idRes: '${orderr!.idRes}',
            //   restaurantName: orderr!.restaurantName!,
            //   amount: orderr!.amount!,
            //   foodName: orderr!.foodName!,
            //   foodPrice: orderr!.foodPrice!,
            //   message: orderr!.foodPrice!,
            //   sum: orderr!.sum!,
            //   sumTotal: orderr!.sumTotal!,
            //   transport: orderr!.transport!,
            // );
          },
        );
        Navigator.pop(context);
      },
    );
  }
}
