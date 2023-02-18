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
import 'package:steps_indicator/steps_indicator.dart';

class StatusOrder extends StatefulWidget {
  const StatusOrder({Key? key}) : super(key: key);

  @override
  State<StatusOrder> createState() => _StatusOrderState();
}

class _StatusOrderState extends State<StatusOrder> {
  bool statusOrder = true;
  List<Order> orders = [];
  List<int> statusInt = [];
  String? idCus;
  List<List<String>> listFoodName = [];
  List<List<String>> listFoodPrice = [];
  List<List<String>> listAmount = [];
  List<List<String>> listSum = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatusCook();
  }

  Future<Null> getStatusCook() async {
    if (orders.length != 0) {
      orders.clear();
      statusInt.clear();
      listFoodName.clear();
      listFoodPrice.clear();
      listAmount.clear();
      listSum.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idCus = preferences.getString('id');

    if (idCus != null) {
      String url =
          '${MyHost().domain}/Project_Flutter/FoodDelivery/getOrderWhereIdCus.php?isAdd=true&idCus=$idCus';

      Response response = await Dio().get(url);

      if (response.toString() == 'null') {
        dialog(context, 'ไม่มีสถานะการสั่งซื้อ');
      }

      if (response.toString() != 'null') {
        var result = json.decode(response.data);
        for (var map in result) {
          Order order = Order.fromJson(map);
          List<String> foodName = Cal().subString(order.foodName!);
          List<String> foodPrice = Cal().subString(order.foodPrice!);
          List<String> amount = Cal().subString(order.amount!);
          List<String> sum = Cal().subString(order.sum!);
          print(sum);

          int status = 0;
          switch (order.status) {
            case 'Wait':
              status = 0;
              break;
            case 'Accept':
              status = 1;
              break;
            case 'Cooking':
              status = 2;
              break;
            case 'Delivery':
              status = 3;
              break;
            case 'Finish':
              status = 4;
              break;
            default:
          }

          setState(() {
            statusOrder = false;
            orders.add(order);
            statusInt.add(status);
            listFoodName.add(foodName);
            listFoodPrice.add(foodPrice);
            listAmount.add(amount);
            listSum.add(sum);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
          child: Text(
            'สถานะการสั่งซื้อ',
            style: MyFont().lookpeachWhite20(),
          ),
        ),
        const SizedBox(height: 15.0),
        RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            getStatusCook();
          },
          child: orders.length == 0
              ? showProgress()
              : statusOrder
                  ? const Center(
                      child: Text('ไม่มีออเดอร์'),
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 40.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: orders.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: Color.fromARGB(255, 105, 180, 242),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            'ร้าน ${orders[index].restaurantName}',
                                            style: MyFont().lookpeachWhite18(),
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    'ชื่อาหาร',
                                                    style: MyFont()
                                                        .lookpeachWhite20(),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'จำนวน',
                                                    style: MyFont()
                                                        .lookpeachWhite20(),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'ราคา',
                                                    style: MyFont()
                                                        .lookpeachWhite20(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: ScrollPhysics(),
                                            itemCount:
                                                listFoodName[index].length,
                                            itemBuilder: (context, index2) =>
                                                Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    '${listFoodName[index][index2]}',
                                                    style: MyFont()
                                                        .lookpeachWhite18(),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    '${listAmount[index][index2]}',
                                                    style: MyFont()
                                                        .lookpeachWhite18(),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    '${listFoodPrice[index][index2]}',
                                                    style: MyFont()
                                                        .lookpeachWhite18(),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 15.0),
                                          stepIndicator(statusInt[index]),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text(
                                                'กำลังรับออเดอร์',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'lookpeach',
                                                    fontSize: 9),
                                              ),
                                              Text(
                                                'รับออเดอร์แล้ว',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'lookpeach',
                                                    fontSize: 9),
                                              ),
                                              Text(
                                                'เริ่มทำอาหาร',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'lookpeach',
                                                    fontSize: 9),
                                              ),
                                              Text(
                                                'กำลังจัดส่ง',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'lookpeach',
                                                    fontSize: 9),
                                              ),
                                              Text(
                                                'จัดส่งสำเร็จ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'lookpeach',
                                                    fontSize: 9),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
        ),
      ],
    );
  }

  Column stepIndicator(int index) {
    return Column(
      children: [
        StepsIndicator(
          lineLength: 65,
          selectedStepColorIn: Colors.red,
          nbSteps: 5,
          selectedStep: index,
        ),
      ],
    );
  }
}
