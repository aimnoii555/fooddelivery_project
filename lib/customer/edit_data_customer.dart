import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDataCustomer extends StatefulWidget {
  const EditDataCustomer({Key? key}) : super(key: key);

  @override
  State<EditDataCustomer> createState() => _EditDataCustomerState();
}

class _EditDataCustomerState extends State<EditDataCustomer> {
  String? firstName, lastName, address, phone, username, password;
  File? file;
  var lat, lng;
  Location location = Location();
  Customer? customer;
  bool _Obscure = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataOld();
    location.onLocationChanged.listen((event) {
      lat = event.latitude;
      lng = event.longitude;
    });
  }

  Future<Null> getDataOld() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');

    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getUserWhereId.php?isAdd=true&id=$id';

    Response response = await Dio().get(url);
    print('respone === $response');

    var result = json.decode(response.data);

    for (var map in result) {
      setState(() {
        customer = Customer.fromJson(map);
        username = customer!.username;
        password = customer!.password;
        firstName = customer!.firstName;
        lastName = customer!.lastName;
        address = customer!.address;
        phone = customer!.phone;
        print('${firstName},${lastName},${address},${phone}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'แก้ไขข้อมูลส่วนตัว',
            style: MyFont().lookpeachWhite18(),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            getDataOld();
          },
          child: ListView(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomRight,
                        colors: [
                      Colors.blue,
                      Color.fromARGB(255, 223, 158, 153),
                    ])),
                child: customer == null
                    ? showProgress()
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 15.0),
                                Container(
                                  child: TextFormField(
                                    style: MyFont().colorWhite(),
                                    cursorColor: Colors.white,
                                    initialValue: username,
                                    decoration: InputDecoration(
                                      label: Text(
                                        'ชื่อผู้ใช้',
                                        style: MyFont().lookpeachWhite18(),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: const BorderSide(
                                              color: Colors.white)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: const BorderSide(
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15.0),
                                Container(
                                  child: TextFormField(
                                    obscureText: _Obscure,
                                    initialValue: password,
                                    style: MyFont().colorWhite(),
                                    cursorColor: Colors.white,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _Obscure = !_Obscure;
                                          });
                                        },
                                        icon: Icon(_Obscure
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      ),
                                      label: Text(
                                        'รหัสผ่าน',
                                        style: MyFont().lookpeachWhite18(),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  width: 350.0,
                                  child: TextFormField(
                                    style: MyFont().colorWhite(),
                                    onChanged: (value) {
                                      firstName = value.trim();
                                    },
                                    initialValue: firstName,
                                    decoration: InputDecoration(
                                      label: Text(
                                        'ชื่อ',
                                        style: MyFont().lookpeachWhite18(),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Container(
                                  width: 350.0,
                                  child: TextFormField(
                                    style: MyFont().colorWhite(),
                                    onChanged: (value) {
                                      lastName = value.trim();
                                    },
                                    initialValue: lastName,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      labelText: 'นามสกุล',
                                      labelStyle: MyFont().lookpeachWhite(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Container(
                                  width: 350.0,
                                  child: TextFormField(
                                    style: MyFont().colorWhite(),
                                    onChanged: (value) {
                                      address = value.trim();
                                    },
                                    initialValue: address,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      labelText: 'ที่อยู่ ',
                                      labelStyle: MyFont().lookpeachWhite(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Container(
                                  width: 350.0,
                                  child: TextFormField(
                                    cursorColor: Colors.white,
                                    style: MyFont().colorWhite(),
                                    onChanged: (value) {
                                      phone = value.trim();
                                    },
                                    initialValue: phone,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      labelText: 'โทรศัพท์',
                                      labelStyle: MyFont().lookpeachWhite(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Container(
                                  width: 350,
                                  height: 250.0,
                                  child: lat == null
                                      ? showProgress()
                                      : GoogleMap(
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(lat, lng),
                                            zoom: 15.0,
                                          ),
                                          mapType: MapType.normal,
                                          markers: {
                                            Marker(
                                              markerId: MarkerId('Marker'),
                                              position: LatLng(lat, lng),
                                              infoWindow: InfoWindow(
                                                title:
                                                    'ละติจูด${lat},ลองติจูด${lng}',
                                                snippet: 'ตำแหน่งของคุณ',
                                              ),
                                            ),
                                          },
                                        ),
                                ),
                                SizedBox(height: 100.0),
                                Container(
                                  width: 350,
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
                                    onPressed: () async {
                                      String id = customer!.id!;
                                      String url =
                                          '${MyHost().domain}/Project_Flutter/FoodDelivery/editUserWhereId.php?isAdd=true&id=$id&First_Name=$firstName&Username=$username&Password=$password&Last_Name=$lastName&Address=$address&Phone=$phone&Lat=$lat&Lng=$lng';

                                      Response response = await Dio().get(url);

                                      if (response.toString() != 'true') {
                                        Navigator.pop(context);
                                        dialog(context, 'แก้ไขเรียบร้อย');
                                      } else {
                                        dialog(context, 'ไม่สามารถแก้ไขได้');
                                      }
                                    },
                                    child: const Center(
                                      child: Text(
                                        'แก้ไข',
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
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ));
  }
}
