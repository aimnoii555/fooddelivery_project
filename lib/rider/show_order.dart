import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/cal/calculateDistance.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/order.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/rider/main_rider.dart';
import 'package:fooddelivery_project/rider/map_customer.dart';
import 'package:fooddelivery_project/rider/map_restaurant.dart';
import 'package:fooddelivery_project/rider/order.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowOrderAccept extends StatefulWidget {
  final Order order;
  final Restaurant restaurant;
  final Customer customer;
  final String restaurantName,
      transport,
      foodName,
      foodPrice,
      amount,
      sum,
      sumTotal,
      message,
      total,
      idOrder;
  const ShowOrderAccept({
    Key? key,
    required this.restaurant,
    required this.customer,
    required this.order,
    required this.restaurantName,
    required this.transport,
    required this.foodName,
    required this.foodPrice,
    required this.amount,
    required this.message,
    required this.sum,
    required this.sumTotal,
    required this.total,
    required this.idOrder,
  }) : super(key: key);

  @override
  State<ShowOrderAccept> createState() => _ShowOrderAcceptState();
}

class _ShowOrderAcceptState extends State<ShowOrderAccept> {
  Customer? customer;
  Restaurant? restaurant;
  Order? order;
  double? latRider, lngRider, latCus, lngCus, distance, latRes, lngRes;
  String? restaurantName,
      transport,
      foodName,
      foodPrice,
      amount,
      message,
      sum,
      total;
  String? sub;

  bool loadStatus = true;
  bool status = true;
  String? idRider;
  List<Order> orders = [];
  String? idOrder;
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

    restaurantName = widget.restaurantName;
    transport = widget.transport;
    foodName = widget.foodName;
    foodPrice = widget.foodPrice;
    amount = widget.amount;
    message = widget.message;
    sum = widget.sum;
    total = widget.total;
    idOrder = widget.idOrder;
    restaurant = widget.restaurant;
    customer = widget.customer;
    order = widget.order;
    getLocation();
    getIdRider();
  }

  Future<Null> getIdRider() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idRider = preferences.getString('id');
    print('idRider = $idRider');
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getOrderWhereIdRiderAccept.php?isAdd=true&idRider=$idRider';

    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false; // no Process Load
      });

      // print('value == $value');
      var result = json.decode(value.data);

      print('result == $result');
      if (result.toString() != '') {
        for (var map in result) {
          order = Order.fromJson(map);
          print('order = ${order!.foodName}');
          List<String> foodName = Cal().subString(order!.foodName!);
          List<String> foodPrice = Cal().subString(order!.foodPrice!);
          List<String> amount = Cal().subString(order!.amount!);
          List<String> sum = Cal().subString(order!.sum!);

          String transport = order!.transport!;

          transportDouble = double.parse(transport);

          print('transport = $transport');

          setState(() {
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
        if (order!.payment == 'ชำระเงินปลายทาง') {
          dialog(context, 'ชำระเงินปลายทาง ${total} บาท');
        }
      } else {
        setState(() {
          status = true; // ไม่มีข้อมูล
        });
      }
    });
  }

  Future<Null> getLocation() async {
    LocationData? locationDataCus = await getLocationData();
    setState(() {
      latRider = locationDataCus!.latitude; // Rider
      lngRider = locationDataCus.longitude;

      latCus = double.parse(customer!.lat!);
      lngCus = double.parse(customer!.lng!); // Customer

      latRes = double.parse(restaurant!.lat!);
      lngRes = double.parse(restaurant!.lng!); // Restaurant

      print('latRes = $latRes');

      print('latCus = $latCus');
    });
  }

  Future<LocationData?> getLocationData() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Future<LocationData?> getLocationDataRes() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 197, 195, 195),
        appBar: AppBar(
          title: Text(
            'รายละเอียดออเดอร์',
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
          child: latRider == null
              ? showProgress()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        child: InkWell(
                          onTap: () {
                            MaterialPageRoute route = MaterialPageRoute(
                                builder: (context) => MapRestaurant(
                                      restaurant: restaurant!,
                                      latRider: latRider!,
                                      lngRider: lngRider!,
                                      latRes: latRes!,
                                      lngRes: lngRes!,
                                    ));
                            Navigator.push(context, route);
                          },
                          child: Card(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: Text(
                                    'คลิกเพื่อดูตำแหน่งของร้านอาหาร',
                                    style: MyFont().lookpeach18(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        child: InkWell(
                          onTap: () {
                            MaterialPageRoute route = MaterialPageRoute(
                                builder: (context) => mapCustomer(
                                      customer: customer!,
                                      latRider: latRider!,
                                      lngRider: lngRider!,
                                      latCus: latCus!,
                                      lngCus: lngCus!,
                                    ));
                            Navigator.push(context, route);
                          },
                          child: Card(
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 50),
                                  child: Text(
                                    'คลิกเพื่อดูตำแหน่งของลูกค้า',
                                    style: MyFont().lookpeach18(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: 200,
                          child: Text(
                            ' ชื่อ ${customer!.firstName}',
                            style: const TextStyle(
                                fontFamily: 'lookpeach',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            'โทรศัพท์: ',
                            style: TextStyle(
                              fontFamily: 'lookpeach',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${customer!.phone}',
                            style: const TextStyle(
                              fontFamily: 'lookpeach',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 50),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.green,
                            ),
                            child: IconButton(
                                iconSize: 30,
                                color: Colors.white,
                                onPressed: () async {
                                  await FlutterPhoneDirectCaller.callNumber(
                                      customer!.phone!);
                                },
                                icon: Icon(Icons.phone)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'รายละเอียด: ',
                            style: TextStyle(
                              fontFamily: 'lookpeach',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 0, 174, 255)),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'รายละเอียด',
                                        style: MyFont().lookpeach(),
                                      ),
                                      content: Container(
                                        width: double.minPositive,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: ScrollPhysics(),
                                          itemCount: 1,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ListView.builder(
                                                  itemCount: listFoodName[index]
                                                      .length,
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index2) => Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 4,
                                                          child: Text(
                                                            '${listFoodName[index][index2]}',
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'lookpeach',
                                                                fontSize: 14),
                                                          )),
                                                      Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            '${listFoodPrice[index][index2]}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
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
                                                                fontSize: 14),
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
                                                    style: MyFont().lookpeach(),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 40.0),
                                                  child: Text(
                                                    'ประเภทชำระ ${orders[index].payment}',
                                                    style: const TextStyle(
                                                      fontFamily: 'lookpeach',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 20.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              'รวมสุทธิ ${total}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(),
                                                const Text(
                                                  'รายละเอียดการจัดส่ง',
                                                  style: TextStyle(
                                                    fontFamily: 'lookpeach',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                order!.message == 'null'
                                                    ? Text(
                                                        'ไม่มีรายละเอียดการจัดส่ง',
                                                        style: MyFont()
                                                            .lookpeach(),
                                                      )
                                                    : Text(
                                                        '${order!.message}',
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'lookpeach',
                                                            fontSize: 12,
                                                            color: Colors.red),
                                                      ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Text('ดูรายละเอียด',
                                style: MyFont().lookpeachWhite()),
                          ),
                        ],
                      ),
                      SizedBox(height: 80),
                      Row(
                        children: const [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'แจ้งไปยังลูกค้าว่ากำลังจัดส่ง',
                              style: TextStyle(
                                fontFamily: 'lookpeach',
                                fontSize: 13,
                                color: Color.fromARGB(255, 0, 47, 86),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text('แจ้งไปยังลูกค้าว่าจัดส่งสำเร็จ',
                                style: TextStyle(
                                  fontFamily: 'lookpeach',
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 0, 47, 86),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () async {
                                Order? orderr;
                                String url =
                                    '${MyHost().domain}/Project_Flutter/FoodDelivery/getOrderWhereIdRiderAccept.php?isAdd=true&idRider=$idRider';

                                await Dio().get(url).then((value) {
                                  var result = json.decode(value.data);
                                  for (var map in result) {
                                    orderr = Order.fromJson(map);
                                  }
                                });
                                if (orderr!.status == 'Cooking') {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SimpleDialog(
                                          title: Text('ยืนยันกำลังจัดส่ง'),
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.green),
                                                    child: Text('ยืนยัน'),
                                                    onPressed: () async {
                                                      String url =
                                                          '${MyHost().domain}/Project_Flutter/FoodDelivery/updateOrderStatus.php?isAdd=true&id=${order!.id}&Status=Delivery';
                                                      await Dio()
                                                          .get(url)
                                                          .then((value) async {
                                                        // String urlCus =
                                                        //     '${MyHost().domain}/Project_Flutter/FoodDelivery/getCusWhereId.php?isAdd=true&id=${order!.idCus}';

                                                        // await Dio()
                                                        //     .get(urlCus)
                                                        //     .then(
                                                        //         (value) async {
                                                        //   var result =
                                                        //       json.decode(
                                                        //           value.data);
                                                        //   for (var map
                                                        //       in result) {
                                                        //     Customer customer =
                                                        //         Customer
                                                        //             .fromJson(
                                                        //                 map);
                                                        //     String token =
                                                        //         customer.token!;

                                                        //     String title =
                                                        //         'FoodDelivery With Flutter';
                                                        //     String body =
                                                        //         'รอรับได้เลยกำลังจัดส่งอาหาร';

                                                        //     String
                                                        //         urlSendTokenCus =
                                                        //         '${MyHost().domain}/Project_Flutter/FoodDelivery/apiNotification.php?isAdd=true&token=$token&title=$title&body=$body';

                                                        //     await Dio()
                                                        //         .get(
                                                        //             urlSendTokenCus)
                                                        //         .then((value) {
                                                        //       print(
                                                        //           'valueCus = $value');
                                                        //     });
                                                        //   }
                                                        // });

                                                        Navigator.pop(context);
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'เเจ้งกำลังจัดส่งไปยังลูกค้าเรียบร้อย');
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.red),
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
                                } else {
                                  dialog(context, 'แจ้งออเดอร์ไปแล้ว');
                                }
                              },
                              child: Text(
                                'แจ้งกำลังจัดส่ง',
                                style: MyFont().lookpeachWhite(),
                              ),
                            ),
                          ),
                          Container(
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 0, 47, 86)),
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        title: Text(
                                          'ยันยันการแจ้งจัดส่งสำเร็จ',
                                          style: MyFont().lookpeach(),
                                        ),
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.green),
                                                    onPressed: () async {
                                                      String url =
                                                          '${MyHost().domain}/Project_Flutter/FoodDelivery/updateOrderStatus.php?isAdd=true&id=${order!.id}&Status=Finish';
                                                      await Dio()
                                                          .get(url)
                                                          .then((value) async {
                                                        // คำนวณหักไรเดอร์ %

                                                        int shiping = 30;
                                                        double percent = 15;

                                                        double totalPercent =
                                                            shiping - percent;
                                                        print(
                                                            'totalPercent = ${totalPercent * 1.50}');

                                                        String url =
                                                            '${MyHost().domain}/Project_Flutter/FoodDelivery/addSaleRider.php?isAdd=true&idRider=$idRider&DateTime=${order!.dateTime}&FoodName=$foodName&FoodPrice=$foodPrice&Amount=$amount&TotalNet=${totalPercent * 1.50}';

                                                        await Dio()
                                                            .get(url)
                                                            .then((value) {
                                                          MaterialPageRoute
                                                              route =
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          MainRider());
                                                          Navigator.push(
                                                              context, route);
                                                          dialog(context,
                                                              'จัดส่งสำเร็จออเดอร์ ${order!.id}');
                                                        });
                                                      });
                                                    },
                                                    child: Text(
                                                      'ตกลง',
                                                      style: MyFont()
                                                          .lookpeachWhite(),
                                                    )),
                                              ),
                                              Container(
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                Colors.red),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      'ยกเลิก',
                                                      style: MyFont()
                                                          .lookpeachWhite(),
                                                    )),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Text(
                                'จัดส่งสำเร็จ',
                                style: MyFont().lookpeachWhite(),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
        ));
  }
}
