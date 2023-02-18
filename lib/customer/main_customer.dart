import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/customer/data_customer.dart';
import 'package:fooddelivery_project/customer/show_restaurant.dart';
import 'package:fooddelivery_project/customer/statusOrder.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/main_page.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainCustomer extends StatefulWidget {
  const MainCustomer({Key? key}) : super(key: key);

  @override
  State<MainCustomer> createState() => _MainCustomerState();
}

class _MainCustomerState extends State<MainCustomer> {
  String? firstName, user;
  Widget? changeWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCus();
    changeWidget = ShowRestaurant();
  }

  Future<Null> getCus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      firstName = preferences.getString('firstName');
      print(firstName);
    });

    await Firebase.initializeApp().then((value) async {
      String? idCus = preferences.getString('id');
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? token = await firebaseMessaging.getToken();
      print('TokenRes = $token');

      String url =
          '${MyHost().domain}/Project_Flutter/FoodDelivery/editTokenWhereId.php?isAdd=true&Token=$token&id=$idCus';

      await Dio().get(url).then((value) {
        print('update successfully');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${firstName} '),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: null,
                  accountEmail: Text(
                    '${firstName}',
                    style: MyFont().lookpeachWhite(),
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      changeWidget = const ShowRestaurant();
                      Navigator.pop(context);
                    });
                  },
                  leading: const Icon(Icons.restaurant_menu),
                  title: Text(
                    'ร้านอาหาร',
                    style: MyFont().lookpeach18(),
                  ),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    setState(() {
                      changeWidget = const StatusOrder();
                      Navigator.pop(context);
                    });
                  },
                  leading: const Icon(Icons.list),
                  title: Text(
                    'สถานะการสั่งซื้อ',
                    style: MyFont().lookpeach18(),
                  ),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    setState(() {
                      changeWidget = DataCustomer();
                      Navigator.pop(context);
                    });
                  },
                  leading: const Icon(Icons.manage_accounts),
                  title: Text(
                    'ข้อมูลส่วนตัว',
                    style: MyFont().lookpeach18(),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Divider(),
                    ListTile(
                      onTap: () {
                        MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => MainPage(),
                        );
                        Navigator.pushAndRemoveUntil(
                            context, route, (route) => false);
                        dialog(context, 'ออกจากระบบเรียบร้อย');
                      },
                      leading: const Icon(Icons.logout),
                      title: Text(
                        'ออกจากระบบ',
                        style: MyFont().lookpeach18(),
                      ),
                    )
                  ],
                ),
              ],
            )
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
        child: changeWidget,
      ),
    );
  }
}
