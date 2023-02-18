import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/customer/edit_data_customer.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataCustomer extends StatefulWidget {
  const DataCustomer({Key? key}) : super(key: key);

  @override
  State<DataCustomer> createState() => _DataCustomerState();
}

class _DataCustomerState extends State<DataCustomer> {
  Customer? customer;
  User? user;
  String? username;
  String? password;
  bool _isObscure = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataCus();
  }

  getDataCus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');

    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getUserWhereId.php?isAdd=true&id=$id';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      print('result ========== $result');
      for (var map in result) {
        customer = Customer.fromJson(map);
        setState(() {
          print('Customer ====== ${customer!.username}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return customer == null
        ? showProgress()
        : Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'ข้อมูลส่วนตัว',
                      style: MyFont().lookpeachWhite25(),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            'ชื่อผู้ใช้ ',
                            style: MyFont().lookpeachWhite18(),
                          ),
                          Text(
                            '${customer!.username}',
                            style: MyFont().lookpeachWhite(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            'รหัสผ่าน ',
                            style: MyFont().lookpeachWhite18(),
                          ),
                          Text(
                            _isObscure ? '✱✱✱✱✱✱' : '${customer!.password}',
                            style: MyFont().lookpeachWhite(),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                            icon: Icon(_isObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            'ชื่อ: ',
                            style: MyFont().fontWeightWhite18(),
                          ),
                          Text(
                            '${customer!.firstName}',
                            style: MyFont().lookpeachWhite(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            'นามสกุล: ',
                            style: MyFont().fontWeightWhite18(),
                          ),
                          Text(
                            '${customer!.lastName}',
                            style: MyFont().lookpeachWhite(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            'ที่อยู่: ',
                            style: MyFont().fontWeightWhite18(),
                          ),
                          Text(
                            '${customer!.address}',
                            style: MyFont().lookpeachWhite(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(
                            'โทรศัพท์: ',
                            style: MyFont().fontWeightWhite18(),
                          ),
                          Text(
                            '${customer!.phone}',
                            style: MyFont().lookpeachWhite(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 350,
                      height: 250,
                      color: Colors.grey,
                      child: customer!.lat == null
                          ? showProgress()
                          : GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(double.parse(customer!.lat!),
                                    double.parse(customer!.lng!)),
                                zoom: 16.0,
                              ),
                              mapType: MapType.normal,
                              onMapCreated: (contoller) {},
                              markers: {
                                Marker(
                                  markerId: MarkerId('MarkerId'),
                                  position: LatLng(
                                    double.parse(customer!.lat!),
                                    double.parse(customer!.lng!),
                                  ),
                                  infoWindow: InfoWindow(
                                    title: 'ตำแหน่งของคุณ',
                                    snippet:
                                        'ละติจูด: ${customer!.lat!}, ลองติจูด: ${customer!.lng}',
                                  ),
                                ),
                              },
                            ),
                    ),
                    SizedBox(height: 250),
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton(
                                onPressed: () {
                                  MaterialPageRoute route = MaterialPageRoute(
                                    builder: ((context) => EditDataCustomer()),
                                  );
                                  Navigator.push(context, route).then(
                                    (value) => getDataCus(),
                                  );
                                },
                                child: Icon(Icons.edit),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
