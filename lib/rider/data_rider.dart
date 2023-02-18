import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/rider/edit_data_rider.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataRider extends StatefulWidget {
  const DataRider({Key? key}) : super(key: key);

  @override
  State<DataRider> createState() => _DataRiderState();
}

class _DataRiderState extends State<DataRider> {
  Rider? rider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataRider();
  }

  getDataRider() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');
    print('id = $id');

    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      for (var map in result) {
        rider = Rider.fromJson(map);
        setState(() {
          print('nameRes = ${rider!.firstName}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [
            Colors.blue,
            Color.fromARGB(255, 223, 158, 153),
          ])),
      child: rider == null
          ? showProgress()
          : Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('ชื่อ: ',
                            style: TextStyle(
                                fontFamily: 'lookpeach',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text(
                          '${rider!.firstName}',
                          style: MyFont().lookpeachWhite(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('นามสกุล: ',
                            style: TextStyle(
                                fontFamily: 'lookpeach',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text(
                          '${rider!.lastName}',
                          style: const TextStyle(
                            fontFamily: 'lookpeach',
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('ป้ายทะเบียนรถ: ',
                            style: TextStyle(
                                fontFamily: 'lookpeach',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text(
                          '${rider!.licensePlate}',
                          style: MyFont().lookpeachWhite(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('ชื่อธนาคาร: ',
                            style: TextStyle(
                                fontFamily: 'lookpeach',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text(
                          '${rider!.bankName}',
                          style: MyFont().lookpeachWhite(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('หมายเลขบัญชี: ',
                            style: TextStyle(
                                fontFamily: 'lookpeach',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text(
                          '${rider!.bankNumber}',
                          style: MyFont().lookpeachWhite(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('ที่อยู่: ',
                            style: TextStyle(
                              fontFamily: 'lookpeach',
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white,
                            )),
                        Text(
                          '${rider!.address}',
                          style: MyFont().lookpeachWhite18(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'โทรศัพท์: ',
                          style: TextStyle(
                            fontFamily: 'lookpeach',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          '${rider!.phone}',
                          style: MyFont().lookpeachWhite18(),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.0),
                    Container(
                      width: 250.0,
                      height: 250.0,
                      child: rider!.image == null
                          ? Image.asset('images/image_default.png')
                          : Image.network('${MyHost().domain}/${rider!.image}'),
                    ),
                    const SizedBox(height: 140),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                MaterialPageRoute route = MaterialPageRoute(
                                    builder: ((context) =>
                                        const EditDataRider()));
                                Navigator.push(context, route)
                                    .then((value) => getDataRider());
                              },
                              child: const Icon(
                                Icons.edit,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    ));
  }
}
