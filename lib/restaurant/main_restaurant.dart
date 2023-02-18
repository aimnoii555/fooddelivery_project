import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/main_page.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/restaurant/category_data.dart';
import 'package:fooddelivery_project/restaurant/data_restaurant.dart';
import 'package:fooddelivery_project/restaurant/food_data.dart';
import 'package:fooddelivery_project/restaurant/my_account_res.dart';
import 'package:fooddelivery_project/restaurant/order.dart';
import 'package:fooddelivery_project/restaurant/view_sales.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainRestaurant extends StatefulWidget {
  const MainRestaurant({Key? key}) : super(key: key);

  @override
  State<MainRestaurant> createState() => _MainRestaurantState();
}

class _MainRestaurantState extends State<MainRestaurant> {
  String? firstName, username, restaurantName, image;
  User? user;

  Widget? currentWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRes();
    currentWidget = ShowOrderFood();
  }

  Future<Null> getRes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      firstName = preferences.getString('firstName');
      username = preferences.getString('username');
      restaurantName = preferences.getString('restaurantName');
      image = preferences.getString('Image');

      print('firstName = $firstName');
    });

    await Firebase.initializeApp().then((value) async {
      String? idRes = preferences.getString('id');
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? token = await firebaseMessaging.getToken();
      print('TokenRes = $token');

      String url =
          '${MyHost().domain}/Project_Flutter/FoodDelivery/editTokenWhereId.php?isAdd=true&Token=$token&id=$idRes';

      await Dio().get(url).then((value) {
        print('update successfully');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${restaurantName}',
            style: MyFont().lookpeachWhite(),
          ),
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
                  '${restaurantName}',
                  style: MyFont().lookpeachWhite(),
                ),
                accountEmail: null,
              ),
              dataOrderFood(context),
              manageDataFood(context),
              editDataRestaurant(context),
              totalIncomeRestaurant(),
              myAccountRes(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(
                      'ออกจากระบบ',
                      style: MyFont().lookpeach18(),
                    ),
                    onTap: () {
                      setState(
                        () {
                          MaterialPageRoute route = MaterialPageRoute(
                              builder: ((context) => MainPage()));
                          Navigator.pushAndRemoveUntil(
                              context, route, (route) => false);
                          dialog(context, 'ออกจากระบบเรียบร้อย');
                        },
                      );
                    },
                  )
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
          child: currentWidget,
        ));
  }

  ListTile editDataRestaurant(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.manage_accounts),
      title: Text(
        'ข้อมูลร้านอาหาร',
        style: MyFont().lookpeach18(),
      ),
      onTap: () {
        setState(() {
          currentWidget = RestaurantData();
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile manageDataFood(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.restaurant_menu),
      title: Text(
        'ข้อมูลอาหาร',
        style: MyFont().lookpeach18(),
      ),
      subtitle: Text(
        'ข้อมูลอาหารของร้านค้า',
        style: MyFont().lookpeach(),
      ),
      onTap: () {
        setState(() {
          currentWidget = CategoryData();
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile dataOrderFood(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.list_sharp),
      title: Text(
        'ออเดอร์',
        style: MyFont().lookpeach18(),
      ),
      subtitle: Text('ออเดอร์ที่ลูกค้าสั่งเข้ามา'),
      onTap: () {
        setState(() {
          currentWidget = ShowOrderFood();
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile totalIncomeRestaurant() {
    return ListTile(
      leading: Icon(Icons.money),
      title: Text(
        'ยอดขาย',
        style: MyFont().lookpeach18(),
      ),
      subtitle: Text('ยอดขายตามช่วงเวลา'),
      onTap: () {
        setState(() {
          currentWidget = ViewSales();
          Navigator.pop(context);
        });
      },
    );
  }

  ListTile myAccountRes() {
    return ListTile(
      leading: Icon(Icons.account_balance_outlined),
      title: Text(
        'บัญชี',
        style: MyFont().lookpeach18(),
      ),
      subtitle: Text('ยอดขายตามช่วงเวลา'),
      onTap: () {
        setState(() {
          currentWidget = MyAccountRes();
          Navigator.pop(context);
        });
      },
    );
  }
}
