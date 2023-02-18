import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/cal/calculateDistance.dart';
import 'package:fooddelivery_project/model/sale.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalTotalIcomeRider extends StatefulWidget {
  const CalTotalIcomeRider({Key? key}) : super(key: key);

  @override
  State<CalTotalIcomeRider> createState() => _CalTotalIcomeRiderState();
}

class _CalTotalIcomeRiderState extends State<CalTotalIcomeRider> {
  List<Sale> sales = [];
  List<List<String>> listFoodName = [];
  List<List<String>> listFoodPrice = [];
  List<List<String>> listAmount = [];
  String? totalNet;
  String? dateTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotalIcome();
  }

  Future<Null> getTotalIcome() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idRider = preferences.getString('id');
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getSaleWhereIdRider.php?isAdd=true&idRider=$idRider';

    String urlTotalNet =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getTotalNetWhereIdRider.php?isAdd=true&idRider=$idRider';

    await Dio().get(urlTotalNet).then((value) {
      var result = json.decode(value.data);
      for (var map in result) {
        Sale sale = Sale.fromJson(map);
        totalNet = sale.totalNet;
      }
    });

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);

      if (result.toString() != '') {
        for (var map in result) {
          Sale sale = Sale.fromJson(map);
          setState(() {
            sales.add(sale);
          });
        }
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
      child: Column(
        children: [
          SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Text(
                          sales[index].dateTime!,
                          style: MyFont().lookpeach18(),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text('รวม ', style: MyFont().lookpeach20()),
                              Text(
                                '${totalNet} บาท',
                                style: MyFont().lookpeach18(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    ));
  }
}
