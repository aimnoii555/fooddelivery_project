import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/auth/pending.dart';
import 'package:fooddelivery_project/customer/main_customer.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/restaurant/main_restaurant.dart';
import 'package:fooddelivery_project/rider/main_rider.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? username, password;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เข้าสู่ระบบ',
          style: MyFont().lookpeachWhite(),
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
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        width: 150,
                        height: 150,
                        child: Image.asset(MyImage().delivery)),
                  ),
                  Container(
                    width: 300.0,
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: MyFont().colorWhite(),
                      decoration: InputDecoration(
                        label: Text('ชื่อผู้ใช้',
                            style: MyFont().lookpeachWhite()),
                        prefixIcon: const Icon(
                          Icons.account_box_outlined,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 240, 237, 237)),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 255, 254, 254))),
                      ),
                      onChanged: (value) {
                        username = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Container(
                    width: 300.0,
                    child: TextFormField(
                      cursorColor: Colors.white,
                      style: MyFont().colorWhite(),
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        prefixIcon: const Icon(
                          Icons.password,
                          color: Colors.white,
                        ),
                        label:
                            Text('รหัสผ่าน', style: MyFont().lookpeachWhite()),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 252, 250, 250))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 253, 252, 252))),
                      ),
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 5.0)
                      ],
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: const LinearGradient(
                        begin: Alignment(-0.95, 0.0),
                        end: Alignment(1.0, 0.0),
                        colors: [
                          Colors.blue,
                          Color.fromARGB(255, 223, 158, 153),
                        ],
                        stops: [0.0, 1.0],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        checkValidate();
                      },
                      child: const Center(
                        child: Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'lookpeach',
                            color: const Color(0xffffffff),
                            letterSpacing: -0.3858822937011719,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkValidate() async {
    print('username === $username');
    if (username == null) {
      dialog(context, 'กรุณาป้อนชื่อผู้ใช้');
    } else if (password == null) {
      dialog(context, 'กรุณาป้อนรหัสผ่าน');
    } else {
      String url =
          '${MyHost().domain}/Project_Flutter/FoodDelivery/getUserWhereUser.php?isAdd=true&Username=$username';

      try {
        Response response = await Dio().get(url);

        var result = json.decode(response.data);
        print('result = $result');
        if (result.toString() == 'null') {
          dialog(context, 'ชื่อผู้ใช้ไม่ถูกต้อง');
        } else {
          for (var map in result) {
            User u = User.fromJson(map);
            Customer c = Customer.fromJson(map);
            Restaurant rs = Restaurant.fromJson(map);
            Rider r = Rider.fromJson(map);
            if (password == u.password || username == u.password) {
              String type = u.type!;
              String statusRider = r.status!;
              String statusRes = rs.status!;
              if (type == 'Customer') {
                displayMenuCustomer(map);
              } else if (type == 'Restaurant') {
                if (statusRes == '0') {
                  MaterialPageRoute route =
                      MaterialPageRoute(builder: (context) => Pending());
                  Navigator.push(context, route);
                } else {
                  displayMenuRestaurant(map);
                }
              } else if (type == 'Rider') {
                if (statusRider == '0') {
                  MaterialPageRoute route =
                      MaterialPageRoute(builder: ((context) => Pending()));
                  Navigator.push(context, route);
                } else {
                  displayMenuRider(map);
                }
              }
            } else {
              dialog(context, 'รหัสผ่านไม่ถูกต้อง');
            }
          }
        }
      } catch (e) {}
    }
  }

  displayMenuCustomer(dynamic map) async {
    Customer c = Customer.fromJson(map);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', c.id.toString());
    preferences.setString('Type', c.type.toString());
    preferences.setString('firstName', c.firstName.toString());
    

    MaterialPageRoute route =
        MaterialPageRoute(builder: ((context) => const MainCustomer()));
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  displayMenuRider(dynamic map) async {
    Rider r = Rider.fromJson(map);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', r.id.toString());
    preferences.setString('Type', r.type.toString());
    preferences.setString('Username', r.username.toString());
    preferences.setString('firstName', r.firstName.toString());
    preferences.setString('Image', r.image.toString());

    MaterialPageRoute route =
        MaterialPageRoute(builder: ((context) => const MainRider()));
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  displayMenuRestaurant(dynamic map) async {
    Restaurant rs = Restaurant.fromJson(map);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', rs.id.toString());
    preferences.setString('Type', rs.type.toString());
    preferences.setString('Username', rs.username.toString());
    preferences.setString('firstName', rs.firstName.toString());
    preferences.setString('restaurantName', rs.restaurantName.toString());
    preferences.setString('lastName', rs.lastName.toString());
    preferences.setString('Image', rs.image.toString());

    MaterialPageRoute route =
        MaterialPageRoute(builder: ((context) => const MainRestaurant()));
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }
}
