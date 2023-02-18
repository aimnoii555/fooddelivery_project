import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/cal/calculateDistance.dart';
import 'package:fooddelivery_project/model/sale.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewSales extends StatefulWidget {
  const ViewSales({Key? key}) : super(key: key);

  @override
  State<ViewSales> createState() => _ViewSalesState();
}

class _ViewSalesState extends State<ViewSales> {
  List<Sale> sales = [];
  List<List<String>> listFoodName = [];
  List<List<String>> listFoodPrice = [];
  List<List<String>> listAmount = [];
  String? totalNet;
  String? dateTime;

  bool loadStatus = true;
  bool status = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalIncomeRestaurant();
  }

  Future<Null> totalIncomeRestaurant() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idRes = preferences.getString('id');
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getSaleWhereIdRes.php?isAdd=true&idRes=$idRes';

    String urlTotalNet =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getTotalNetWhereIdRes.php?isAdd=true&idRes=$idRes';

    await Dio().get(urlTotalNet).then((value) {
      var result = json.decode(value.data);
      for (var map in result) {
        Sale sale = Sale.fromJson(map);
        totalNet = sale.totalNet;
      }
    });

    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });
      var result = json.decode(value.data);

      if (result.toString() != '') {
        for (var map in result) {
          Sale sale = Sale.fromJson(map);
          List<String> foodName = Cal().subString(sale.foodName!);
          List<String> foodPrice = Cal().subString(sale.foodPrice!);
          List<String> amount = Cal().subString(sale.amount!);

          setState(() {
            sales.add(sale);
            listFoodName.add(foodName);
            listFoodPrice.add(foodPrice);
            listAmount.add(amount);
          });
        }
      } else {
        setState(() {
          status = false;
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
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 40, top: 30),
                child: totalNet == null
                    ? Text('')
                    : Text(
                        'รวม: ${totalNet} บาท',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'lookpeach',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
          loadStatus
              ? showProgress()
              : status
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 60.0, left: 10, right: 10),
                      child: ListView.builder(
                        itemCount: sales.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Color.fromARGB(255, 26, 70, 81),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'วว/ดด/ปป',
                                          style: MyFont().lookpeachWhite(),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'ชื่ออาหาร',
                                          style: MyFont().lookpeachWhite(),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'จำนวน',
                                          style: MyFont().lookpeachWhite(),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'ราคา',
                                          style: MyFont().lookpeachWhite(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: listFoodName[index].length,
                                  itemBuilder: (context, index2) {
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              '${sales[index].dateTime}',
                                              style: MyFont().lookpeachWhite(),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              '${listFoodName[index][index2]}',
                                              style: MyFont().lookpeachWhite(),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              '${listAmount[index][index2]}',
                                              style: MyFont().lookpeachWhite(),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              '${listFoodPrice[index][index2]}',
                                              style: MyFont().lookpeachWhite(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                        'ไม่มีประวัติขาย',
                        style: MyFont().lookpeachWhite(),
                      ),
                    ),
        ],
      ),
    ));
  }
}
