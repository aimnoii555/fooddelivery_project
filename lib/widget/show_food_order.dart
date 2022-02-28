import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/model/order_model.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';

class ShowFoodOrder extends StatefulWidget {
  const ShowFoodOrder({Key? key}) : super(key: key);

  @override
  _ShowFoodOrderState createState() => _ShowFoodOrderState();
}

class _ShowFoodOrderState extends State<ShowFoodOrder> {
  String? idUser;
  bool statusOrder = true;
  List<OrderModel> orderModels = [];
  List<int> statusInt = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: statusOrder ? NoOrder() : content(),
    );
  }

  Widget content() => Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: orderModels.length,
          itemBuilder: (context, index) => Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.4,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        nameChef(index),
                        nameFood(index),
                        dateTime(index),
                        price(index),
                        stepIndicator(statusInt[index]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget stepIndicator(int index) => Column(
        children: [
          StepsIndicator(
            lineLength: 70,
            selectedStepColorIn: Colors.red,
            nbSteps: 4,
            selectedStep: index,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Order'),
              Text('Cooking'),
              Text('Delivery'),
              Text('Finish'),
            ],
          ),
        ],
      );

  Text nameFood(int index) {
    return Text(
        '${orderModels[index].nameFood!.substring(1, orderModels[index].nameFood!.length - 1)}');
  }

  Text price(int index) => Text('฿ ${orderModels[index].sum!}');

  Text dateTime(int index) => Text('เวลา ${orderModels[index].dateTime!}');

  Text nameChef(int index) {
    return Text(
      'ร้าน ${orderModels[index].nameChef!}',
      style: TextStyle(fontFamily: 'peach', fontSize: 16.0),
    );
  }

  Center NoOrder() => Center(child: Text('ไม่มีประวัติการสั้งอาหาร'));

  Future<Null> findUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    idUser = sharedPreferences.getString('id');
    print('idUser = $idUser');
    readOrderFromIdUser();
  }

  Future readOrderFromIdUser() async {
    if (idUser != null) {
      String url =
          '${MyIpAddress().domain}/FoodDelivery/getOrderWhereIdUser.php?isAdd=true&idUser=$idUser';
      Response response = await Dio().get(url);
      print('res = $response');

      if (response.toString() != 'null') {
        var result = jsonDecode(response.data);

        for (var map in result) {
          OrderModel model = OrderModel.fromJson(map);
          int status = 0;
          switch (model.status) {
            case 'UserOrder':
              status = 0;
              break;
            case 'Cooking':
              status = 1;
              break;
            case 'Delivery':
              status = 2;
              break;
            case 'Finish':
              status = 3;
              break;
            default:
          }

          setState(() {
            statusOrder = false;
            orderModels.add(model);
            statusInt.add(status);
          });
        }
      }
    }
  }
}
