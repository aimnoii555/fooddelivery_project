//หน้ารายการอาหารที่ลูกค้าสั่ง

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/model/order_model.dart';
import 'package:fooddelivery_project/model/user_model.dart';
import 'package:fooddelivery_project/utility/my_api.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:fooddelivery_project/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListChef extends StatefulWidget {
  const OrderListChef({Key? key}) : super(key: key);

  @override
  _OrderListChefState createState() => _OrderListChefState();
}

class _OrderListChefState extends State<OrderListChef> {
  late UserModel userModel;
  String? idChef;
  List<OrderModel> orderModels = [];
  List<List<String>> listNameFoods = [];
  List<List<String>> listPrice = [];
  List<List<String>> listAmount = [];
  List<List<String>> listSum = [];
  List<double> totals = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readOrder();
  }

  Future<Null> readOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idChef = preferences.getString('id');
    print('idChef ====== $idChef');

    String url =
        '${MyIpAddress().domain}/FoodDelivery/getOrderWhereIdChef.php?isAdd=true&idChef=$idChef';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      for (var item in result) {
        OrderModel model = OrderModel.fromJson(item);
        List<String> nameFoods = MyAPI().subString(model.nameFood!);
        List<String> price = MyAPI().subString(model.price!);
        List<String> amount = MyAPI().subString(model.amount!);
        List<String> sum = MyAPI().subString(model.sum!);

        double total = 0.0;
        double sumTotal = 0.0;
        for (var item in sum) {
          total = total + double.parse(item);
        }
        // print('model ===== ${model.idFood}');
        setState(() {
          orderModels.add(model);
          listNameFoods.add(nameFoods);
          listPrice.add(price);
          listAmount.add(amount);
          listSum.add(sum);
          totals.add(total);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: orderModels.length == 0
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: orderModels.length,
              itemBuilder: (context, index) => Card(
                color: index % 2 == 0 ? Colors.grey.shade100 : Colors.white,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${orderModels[index].nameUser}'),
                        Text('${orderModels[index].dateTime}'),
                        title(),
                        ListView.builder(
                          itemCount: listNameFoods[index].length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index2) => Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child:
                                      Text('${listNameFoods[index][index2]}')),
                              Expanded(
                                  flex: 3,
                                  child: Text('${listPrice[index][index2]}')),
                              Expanded(
                                  flex: 3,
                                  child: Text('${listAmount[index][index2]}')),
                              Expanded(
                                  flex: 2,
                                  child: Text('${listSum[index][index2]}')),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'รวมสุทธิ ${totals[index].toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            RaisedButton.icon(
                              color: Colors.green.shade300,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              onPressed: () {},
                              icon: Icon(Icons.restaurant),
                              label: Text(
                                'รับออเดอร์',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            RaisedButton.icon(
                              color: Colors.red.shade300,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              onPressed: () {},
                              icon: Icon(Icons.cancel),
                              label: Text(
                                'ยกเลิก',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Container title() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text('ชื่ออาหาร'),
          ),
          Expanded(
            flex: 3,
            child: Text('ราคา'),
          ),
          Expanded(
            flex: 3,
            child: Text('จำนวน'),
          ),
          Expanded(
            flex: 2,
            child: Text('รวม'),
          ),
        ],
      ),
    );
  }
}
