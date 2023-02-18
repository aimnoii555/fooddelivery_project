import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/customer/payment_omise.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/cart.dart';
import 'package:fooddelivery_project/model/food.dart';
import 'package:fooddelivery_project/model/sqlite_helper.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOut extends StatefulWidget {
  final double sumDouble;
  final String restaurantName;
  CheckOut({Key? key, required this.sumDouble, required this.restaurantName})
      : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  Restaurant? restaurant;

  Cart? cart;

  List<Cart> carts = [];
  List<Food> foods = [];
  double total = 0.0;
  double transportDouble = 0.0;
  bool status = true;
  int amount = 1;
  String? sumCon;
  String? payment, message;
  double sumAmount = 0.0;
  double sumDouble = 0.0;
  String? distance;
  String? restaurantName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restaurantName = widget.restaurantName;
    sumDouble = widget.sumDouble;
    print('sumDouble ========== $sumDouble');
    getCart();
  }

  Future<Null> getCart() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idCus = preferences.getString('id');
    var object = await DBHelper().getCartList(idCus!);
    print('object length = ${object.length}');
    if (object.length == 0) {
      dialog(context, 'ไม่มีรายการในตะกร้า');
    }
    if (object.length != 0) {
      for (var resultTotal in object) {
        int sumString = resultTotal.sum!;
        String transport = resultTotal.transport!;
        distance = resultTotal.distance;
        transportDouble = double.parse(transport);
        print('transportDouble = $transportDouble');
        double sumInt = double.parse(sumString.toString());
        setState(() {
          status = false;
          carts = object;
          total = total + sumInt;

          print('total = $total');
        });
      }
    } else {
      setState(() {
        status = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Check Out'),
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
            padding: const EdgeInsets.all(30.0),
            child: ListView(
              children: [
                Container(
                  child: Text(
                    'เลือกประเภทการชำระเงิน',
                    style: MyFont().lookpeachWhite20(),
                  ),
                ),
                Row(
                  children: [
                    Radio(
                        activeColor: Colors.black,
                        value: 'Omise',
                        groupValue: payment,
                        onChanged: (value) {
                          setState(() {
                            payment = value.toString();
                          });
                        }),
                    Text(
                      'Omise',
                      style: MyFont().lookpeachWhite18(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        activeColor: Colors.black,
                        value: 'ชำระเงินปลายทาง',
                        groupValue: payment,
                        onChanged: (value) {
                          setState(() {
                            payment = value.toString();
                          });
                        }),
                    Text(
                      'ชำระเงินปลายทาง',
                      style: MyFont().lookpeachWhite18(),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  child: TextFormField(
                    style: MyFont().colorWhite(),
                    maxLines: 3,
                    decoration: InputDecoration(
                      label: Text(
                        'รายละเอียดการจัดส่ง',
                        style: MyFont().lookpeachWhite(),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      message = value.trim();
                    },
                  ),
                ),
                SizedBox(height: 20),
                Divider(),
                Container(
                  padding: EdgeInsets.only(top: 60, bottom: 10),
                  child: Text(
                    'สรุปรายการสั่งซื้อ',
                    style: MyFont().lookpeachWhite20(),
                  ),
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'รวม',
                        style: TextStyle(
                          fontFamily: 'lookpeach',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${sumDouble} บาท',
                        style: MyFont().lookpeachWhite(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'ระยะทาง',
                        style: TextStyle(
                          fontFamily: 'lookpeach',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${distance} กิโลเมตร',
                        style: MyFont().lookpeachWhite(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'ค่าจัดส่ง',
                        style: TextStyle(
                          fontFamily: 'lookpeach',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${transportDouble} บาท',
                        style: MyFont().lookpeachWhite(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'รวมยอด',
                        style: TextStyle(
                          fontFamily: 'lookpeach',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${sumDouble + transportDouble} บาท',
                        style: MyFont().lookpeachWhite(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 160),
                Container(
                  height: 40,
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
                    onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();

                      String? idCus = preferences.getString('id');
                      String? cusName = preferences.getString('firstName');

                      DateTime dateTime = DateTime.now();
                      String orderDate =
                          DateFormat('dd-MM-yyyy HH:mm').format(dateTime);

                      print('orderDate === $orderDate');

                      String idRes = carts[0].idRes!;
                      String ResName = carts[0].restaurantName!;
                      String distance = carts[0].distance!;
                      String transport = carts[0].transport!;

                      List<String> idFoods = [];
                      List<String> foodNames = [];
                      List<String> foodPrices = [];
                      List<String> amounts = [];
                      List<String> sums = [];

                      // นำข้อมูลอาหารในตะกร้าทั้งหมดมาเก็บไว้ model
                      for (var model in carts) {
                        idFoods.add(model.idFood!);
                        foodNames.add(model.foodName!);
                        foodPrices.add(model.foodPrice.toString());
                        amounts.add(model.amount.toString());
                        sums.add(model.sum.toString());
                      }

                      String idFood = idFoods.toString();
                      String foodName = foodNames.toString();
                      String foodPrice = foodPrices.toString();
                      String amount = amounts.toString();
                      String sum = sums.toString();

                      print(
                          'idFood = $idFood, foodName = $foodName, foodPrice = $foodPrice, amount = $amount, sum = $sum, payment= $payment');

                      String url =
                          '${MyHost().domain}/Project_Flutter/FoodDelivery/addOrder.php?isAdd=true&DateTime=$orderDate&idCus=$idCus&Customer_Name=$cusName&idRes=$idRes&Restaurant_Name=$ResName&Distance=$distance&Transport=$transport&idFood=$idFood&FoodName=$foodName&FoodPrice=$foodPrice&Amount=$amount&Sum=$sum&SumTotal=$sumDouble&idRider=none&Message=$message&Payment=$payment&Status=Wait';

                      if (payment == null) {
                        dialog(context, 'กรุณาเลือกประเภทการชำระงิน');
                      }
                      if (payment == 'ชำระเงินปลายทาง') {
                        await DBHelper().deleteAllCart().then((value) async {
                          await Dio().get(url).then((value) async {
                            Fluttertoast.showToast(msg: 'สั่งซื้อเรียบร้อย');
                            Navigator.pop(context);
                            Navigator.pop(context);

                            String url =
                                '${MyHost().domain}/Project_Flutter/FoodDelivery/getUserWhereRider.php?isAdd=true&Type=Rider';

                            await Dio().get(url).then((value) async {
                              var result = json.decode(value.data);

                              for (var map in result) {
                                Rider rider = Rider.fromJson(map);
                                String token = rider.token!;
                                print('Token_Rider = $token');

                                String title = 'มีออเดอร์';
                                String body =
                                    'มีลูกค้าสั่งอาหารจากร้าน ${restaurantName}';

                                String urlSendToken =
                                    '${MyHost().domain}/Project_Flutter/FoodDelivery/apiNotification.php?isAdd=true&token=$token&title=$title&body=$body';

                                await Dio().get(urlSendToken).then((value) {
                                  print('value = $value');
                                });
                              }
                            });
                          });
                        });
                      }

                      if (payment == 'Omise') {
                        MaterialPageRoute route = MaterialPageRoute(
                            builder: (context) => PaymentOmise(
                                  sumDouble: sumDouble,
                                  transportDouble: transportDouble,
                                ));

                        Navigator.push(context, route);
                      }
                    },
                    child: const Center(
                      child: Text(
                        'สั่งซื้อ',
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
        ));
  }
}
