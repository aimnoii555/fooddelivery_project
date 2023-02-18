import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/cal/calculateDistance.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/order.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowOrderFood extends StatefulWidget {
  const ShowOrderFood({Key? key}) : super(key: key);

  @override
  State<ShowOrderFood> createState() => _ShowOrderFoodState();
}

class _ShowOrderFoodState extends State<ShowOrderFood> {
  List<Order> orders = [];
  List<List<String>> listFoodName = [];
  List<List<String>> listFoodPrice = [];
  List<List<String>> listAmount = [];
  List<List<String>> listSum = [];
  List<double> totals = [];
  double sumTotal = 0.0;

  bool loadStatus = true;
  bool status = true;

  String? idOrder, idRes, dateTime, foodName, foodPrice, amount, totalNet;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrder();
  }

  Future<Null> getOrder() async {
    if (orders.length != 0) {
      loadStatus = true;
      orders.clear();
      listFoodName.clear();
      listFoodPrice.clear();
      listAmount.clear();
      listSum.clear();
      status = true;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idRes = preferences.getString('id');
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getOrderWhereIdRes.php?isAdd=true&idRes=$idRes';

    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });
      var result = json.decode(value.data);

      if (result == null) {
        dialog(context, 'ไม่มีออเดอร์');
      }

      if (result.toString() != '') {
        for (var map in result) {
          Order order = Order.fromJson(map);
          List<String> foodName = Cal().subString(order.foodName!);
          List<String> foodPrice = Cal().subString(order.foodPrice!);
          List<String> amount = Cal().subString(order.amount!);
          List<String> sum = Cal().subString(order.sum!);

          setState(() {
            orders.add(order);
            listFoodName.add(foodName);
            listFoodPrice.add(foodPrice);
            listAmount.add(amount);
            listSum.add(sum);
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
        body: RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2));
        getOrder();
      },
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
                colors: [
              Colors.blue,
              Color.fromARGB(255, 223, 158, 153),
            ])),
        child: loadStatus
            ? showProgress()
            : status
                ? showContent()
                : const Center(
                    child: Text('No Order'),
                  ),
      ),
    ));
  }

  Widget showContent() {
    return Container(
      child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return Visibility(
              visible: true,
              child: Card(
                color: index % 2 == 0
                    ? Colors.blue.shade300
                    : Color.fromARGB(96, 124, 208, 232),
                child: Column(
                  children: [
                    Text(
                      'หมายเลขออเดอร์ ${orders[index].id}',
                      style: MyFont().lookpeachWhite18(),
                    ),
                    Text(
                      ' ${orders[index].dateTime}',
                      style: MyFont().lookpeachWhite(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'ชื่ออาหาร',
                              style: TextStyle(
                                fontFamily: 'lookpeach',
                                color: Color.fromARGB(255, 248, 247, 247),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'ราคา',
                              style: TextStyle(
                                fontFamily: 'lookpeach',
                                color: Color.fromARGB(255, 250, 250, 250),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'จำนวน',
                              style: TextStyle(
                                fontFamily: 'lookpeach',
                                color: Color.fromARGB(255, 249, 247, 247),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'รวม',
                              style: TextStyle(
                                fontFamily: 'lookpeach',
                                color: Color.fromARGB(255, 247, 246, 246),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: listFoodName[index].length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index2) => Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text(
                                  '${listFoodName[index][index2]}',
                                  style: MyFont().lookpeachWhite(),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  '${listFoodPrice[index][index2]}',
                                  style: MyFont().lookpeachWhite(),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  '${listAmount[index][index2]}',
                                  style: MyFont().lookpeachWhite(),
                                )),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  '${listSum[index][index2]}',
                                  style: MyFont().lookpeachWhite(),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 181, 163, 4)),
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        title: Text(
                                          'ยืนยันเริ่มทำอาหารออเดอร์ ${orders[index].id} หรือไม่?',
                                          style: const TextStyle(
                                            fontFamily: 'lookpeach',
                                            fontSize: 13,
                                          ),
                                        ),
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              Colors.green),
                                                  child: Text('ยืนยัน'),
                                                  onPressed: () async {
                                                    idOrder = orders[index].id;
                                                    idRes = orders[index].idRes;
                                                    dateTime =
                                                        orders[index].dateTime;
                                                    foodName =
                                                        orders[index].foodName;
                                                    foodPrice =
                                                        orders[index].foodPrice;
                                                    amount =
                                                        orders[index].amount;
                                                    totalNet =
                                                        orders[index].sumTotal;
                                                    print(index);
                                                    String url =
                                                        '${MyHost().domain}/Project_Flutter/FoodDelivery/updateOrderStatus.php?isAdd=true&id=${orders[index].id}&Status=Cooking';

                                                    await Dio()
                                                        .get(url)
                                                        .then((value) async {
                                                      Navigator.pop(context);

                                                      dialog(context,
                                                          'รับออเดอร์เรียบร้อย $idOrder');

                                                      String url =
                                                          '${MyHost().domain}/Project_Flutter/FoodDelivery/addSale.php?isAdd=true&idRes=$idRes&DateTime=$dateTime&FoodName=$foodName&FoodPrice=$foodPrice&Amount=$amount&TotalNet=$totalNet';
                                                      await Dio()
                                                          .get(url)
                                                          .then((value) async {
                                                        String url =
                                                            '${MyHost().domain}/Project_Flutter/FoodDelivery/updateOrderAmountRes.php?isAdd=true&id=$idRes&OrderAmountRes=$totalNet';
                                                        await Dio().get(url);
                                                        getOrder();
                                                      });
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.red,
                                                  ),
                                                  child: Text('ยกเลิก'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                'เริ่มทำอาหาร',
                                style: MyFont().lookpeachWhite18(),
                              )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
