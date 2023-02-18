import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/cal/calculateDistance.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/order.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/rider/acceptOrder.dart';

import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowOrderCus extends StatefulWidget {
  const ShowOrderCus({Key? key}) : super(key: key);

  @override
  State<ShowOrderCus> createState() => _ShowOrderCusState();
}

class _ShowOrderCusState extends State<ShowOrderCus> {
  bool loadStatus = true;
  bool status = true;
  String? idRider;
  String? idOrder;
  Order? order;
  List<Order> orders = [];

  List<List<String>> listFoodName = [];
  List<List<String>> listFoodPrice = [];
  List<List<String>> listAmount = [];
  List<List<String>> listSum = [];
  List<double> totals = [];
  double sumTotal = 0.0;
  double transportDouble = 0.0;

  String? statusOrder;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getIdRider();
  }

  Future<Null> getIdRider() async {
    if (orders.length != 0) {
      loadStatus = true;
      orders.clear();
      status = true;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idRider = preferences.getString('id');
    print('idRider = $idRider');
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getOrderWhereIdRider.php?isAdd=true';

    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false; // no Process Load
      });

      // print('value == $value');
      var result = json.decode(value.data);

      print('result == $result');
      if (result.toString() != '') {
        if (result == null) {
          dialog(context, 'ไม่มีออเดอร์');
        }
        for (var map in result) {
          order = Order.fromJson(map);
          List<String> foodName = Cal().subString(order!.foodName!);
          List<String> foodPrice = Cal().subString(order!.foodPrice!);
          List<String> amount = Cal().subString(order!.amount!);
          List<String> sum = Cal().subString(order!.sum!);

          double total = 0.0;

          String transport = order!.transport!;

          transportDouble = double.parse(transport);

          print('transport = $transport');

          for (var item in sum) {
            total = total + double.parse(item);

            print('total= $total');
          }

          String dis = order!.distance!;

          double disDouble = double.parse(dis);

          print('dis ============= $dis');

          if (disDouble <= 10) {
            setState(() {
              sumTotal = total + transportDouble;
              print('total = $sumTotal');
              orders.add(order!);
              listFoodName.add(foodName);
              listFoodPrice.add(foodPrice);
              listAmount.add(amount);
              listSum.add(sum);
              totals.add(sumTotal);

              // print(
              //     'listFoodName == $listFoodName,listFoodPrice = $listFoodPrice, listAmount = $listAmount,listSum = $listSum, total = $totals');
            });
          }
        }
      } else {
        setState(() {
          status = true; // ไม่มีข้อมูล
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        getIdRider();
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
            statusOrder = orders[index].status;
            print(statusOrder);

            return Visibility(
              visible: true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                  child: Card(
                    color:
                        index % 2 == 0 ? Colors.grey.shade500 : Colors.white38,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text(
                            'รายการจากร้าน ${orders[index].restaurantName}',
                            style: MyFont().lookpeach18(),
                          ),
                          Text(
                            '${orders[index].dateTime}',
                            style: MyFont().lookpeach18(),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green),
                                  child: const Text(
                                    'รับออเดอร์ ',
                                  ),
                                  onPressed: () async {
                                    return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('รายละเอียด'),
                                            content: Container(
                                              width: double.minPositive,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: 1,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index2) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      ListView.builder(
                                                        itemCount:
                                                            listFoodName[index]
                                                                .length,
                                                        shrinkWrap: true,
                                                        physics:
                                                            ScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index2) =>
                                                                Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 4,
                                                                child: Text(
                                                                  '${listFoodName[index][index2]}',
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'lookpeach',
                                                                      fontSize:
                                                                          14),
                                                                )),
                                                            Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  '${listFoodPrice[index][index2]}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'lookpeach',
                                                                  ),
                                                                )),
                                                            Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  '${listAmount[index][index2]}',
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'lookpeach',
                                                                      fontSize:
                                                                          14),
                                                                )),
                                                            Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                    '${listSum[index][index2]}')),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          'ค่าจัดส่ง ${orders[index].transport} บาท',
                                                          style: MyFont()
                                                              .lookpeach(),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(right: 40.0),
                                                        child: Text(
                                                          'ประเภทชำระ ${orders[index].payment}',
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'lookpeach',
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              margin: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                    'รวมสุทธิ ${totals[index].toString()}',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 15),
                                                        width: 200,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary:
                                                                      const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          81,
                                                                          167,
                                                                          238)),
                                                          onPressed: () async {
                                                            // if () {

                                                            // }
                                                            SharedPreferences
                                                                preferences =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            String? idRider =
                                                                preferences
                                                                    .getString(
                                                                        'id');
                                                            idOrder =
                                                                orders[index]
                                                                    .id;
                                                            String idRes =
                                                                orders[index]
                                                                    .idRes!;
                                                            String idCus =
                                                                orders[index]
                                                                    .idCus!;
                                                            print(
                                                                'idCus = $idCus');

                                                            String url =
                                                                '${MyHost().domain}/Project_Flutter/FoodDelivery/acceptOrderWhereIdRider.php?isAdd=true&id=$idOrder&idRider=$idRider';

                                                            await Dio()
                                                                .get(url)
                                                                .then(
                                                                    (value) async {
                                                              String url =
                                                                  '${MyHost().domain}/Project_Flutter/FoodDelivery/updateOrderStatus.php?isAdd=true&id=$idOrder&Status=Accept';

                                                              await Dio()
                                                                  .get(url)
                                                                  .then(
                                                                      (value) async {
                                                                //---------------------
                                                                // String urlCus =
                                                                //     '${MyHost().domain}/Project_Flutter/FoodDelivery/getCusWhereId.php?isAdd=true&id=$idCus';

                                                                // await Dio()
                                                                //     .get(urlCus)
                                                                //     .then(
                                                                //         (value) async {
                                                                //   var result = json
                                                                //       .decode(value
                                                                //           .data);
                                                                //   for (var map
                                                                //       in result) {
                                                                //     Customer
                                                                //         customer =
                                                                //         Customer.fromJson(
                                                                //             map);
                                                                //     String
                                                                //         token =
                                                                //         customer
                                                                //             .token!;

                                                                //     String
                                                                //         title =
                                                                //         'FoodDelivery With Flutter';
                                                                //     String
                                                                //         body =
                                                                //         'พนักงานจัดส่งรับออเดอร์แล้ว';

                                                                //     String
                                                                //         urlSendTokenCus =
                                                                //         '${MyHost().domain}/Project_Flutter/FoodDelivery/apiNotification.php?isAdd=true&token=$token&title=$title&body=$body';

                                                                //     await Dio()
                                                                //         .get(
                                                                //             urlSendTokenCus)
                                                                //         .then(
                                                                //             (value) {
                                                                //       print(
                                                                //           'valueCus = $value');
                                                                //     });
                                                                //   }
                                                                // });
                                                                //---------------------

                                                                // String url =
                                                                //     '${MyHost().domain}/Project_Flutter/FoodDelivery/getResWhereId.php?isAdd=true&id=$idRes';

                                                                // await Dio()
                                                                //     .get(url)
                                                                //     .then(
                                                                //         (value) async {
                                                                //   var result = json
                                                                //       .decode(value
                                                                //           .data);

                                                                //   for (var map
                                                                //       in result) {
                                                                //     Restaurant
                                                                //         restaurant =
                                                                //         Restaurant.fromJson(
                                                                //             map);
                                                                //     String
                                                                //         token =
                                                                //         restaurant
                                                                //             .token!;
                                                                //     String
                                                                //         title =
                                                                //         'มีออเดอร์';
                                                                //     String
                                                                //         body =
                                                                //         'มีคำสั่งซื้อจากลูกค้า';

                                                                //     String
                                                                //         urlSendTokenRes =
                                                                //         '${MyHost().domain}/Project_Flutter/FoodDelivery/apiNotification.php?isAdd=true&token=$token&title=$title&body=$body';

                                                                //     await Dio()
                                                                //         .get(
                                                                //             urlSendTokenRes)
                                                                //         .then(
                                                                //             (value) {
                                                                //       print(
                                                                //           'valueRes = $value');
                                                                //     });
                                                                //   }
                                                                // });

                                                                MaterialPageRoute
                                                                    route =
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            AcceptOrder(
                                                                              idRes: idRes,
                                                                              idOrder: idOrder!,
                                                                              idCus: idCus,
                                                                              amount: listAmount[index][index2],
                                                                              foodName: listFoodName[index][index2],
                                                                              foodPrice: listFoodPrice[index][index2],
                                                                              message: orders[index].message!,
                                                                              restaurantName: orders[index].restaurantName!,
                                                                              sum: listSum[index][index2],
                                                                              sumTotal: orders[index].sumTotal!,
                                                                              transport: orders[index].transport!,
                                                                              total: totals[index].toString(),
                                                                            ));
                                                                // ignore: use_build_context_synchronously
                                                                Navigator.pushAndRemoveUntil(
                                                                    context,
                                                                    route,
                                                                    (route) =>
                                                                        false);
                                                                // ignore: use_build_context_synchronously
                                                                dialog(context,
                                                                    'รับออเดอร์เรียบร้อย');
                                                              });
                                                            });
                                                          },
                                                          child: Text(
                                                            'ตกลง',
                                                            style: MyFont()
                                                                .lookpeachWhite(),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
