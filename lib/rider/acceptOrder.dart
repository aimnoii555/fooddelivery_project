import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/order.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/restaurant/order.dart';
import 'package:fooddelivery_project/rider/show_order.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcceptOrder extends StatefulWidget {
  final String idRes,
      idOrder,
      idCus,
      restaurantName,
      transport,
      foodName,
      foodPrice,
      amount,
      sum,
      sumTotal,
      message,
      total;
  const AcceptOrder({
    Key? key,
    required this.idRes,
    required this.idOrder,
    required this.idCus,
    required this.restaurantName,
    required this.transport,
    required this.foodName,
    required this.foodPrice,
    required this.amount,
    required this.sum,
    required this.sumTotal,
    required this.message,
    required this.total,
  }) : super(key: key);

  @override
  State<AcceptOrder> createState() => _AcceptOrderState();
}

class _AcceptOrderState extends State<AcceptOrder> {
  String? idRider;
  Order? order;
  List<Order> orders = [];
  List<Restaurant> restaurants = [];
  List<Customer> customers = [];
  String? idRes,
      idOrder,
      idCus,
      restaurantName,
      transport,
      foodName,
      foodPrice,
      amount,
      sum,
      sumTotal,
      message,
      total;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idRes = widget.idRes;
    idOrder = widget.idOrder;
    idCus = widget.idCus;
    restaurantName = widget.restaurantName;
    transport = widget.transport;
    foodName = widget.foodName;
    foodPrice = widget.foodPrice;
    amount = widget.amount;
    sum = widget.sum;
    sumTotal = widget.sumTotal;
    message = widget.message;
    total = widget.total;
    print(foodName);
    getOrderCustomer();
    getDataRestaurant();
    getDataCustomer();
  }

  Future<Null> getOrderCustomer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idRider = preferences.getString('id');
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getOrderWhereId.php?isAdd=true&id=$idOrder';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      print('result = $result');
      for (var map in result) {
        Order order = Order.fromJson(map);

        setState(() {
          orders.add(order);
        });
      }
    });
  }

  Future<Null> getDataRestaurant() async {
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getResWhereId.php?isAdd=true&id=$idRes';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      for (var map in result) {
        Restaurant restaurant = Restaurant.fromJson(map);
        setState(() {
          restaurants.add(restaurant);
        });
      }
    });
  }

  Future<Null> getDataCustomer() async {
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getCusWhereId.php?isAdd=true&id=$idCus';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);

      for (var map in result) {
        Customer customer = Customer.fromJson(map);
        setState(() {
          customers.add(customer);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Order',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
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
          child: Container(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      String url =
                          '${MyHost().domain}/Project_Flutter/FoodDelivery/getOrderWhereIdRiderAccept.php?isAdd=true&idRider=$idRider';

                      await Dio().get(url).then((value) {
                        var result = json.decode(value.data);
                        for (var map in result) {
                          order = Order.fromJson(map);
                          print('status ===== ${order!.status}');
                        }
                        if (order!.status == 'Accept') {
                          dialog(context, 'รอให้ร้านอาหารรับออเดอร์');
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowOrderAccept(
                                idOrder: idOrder!,
                                restaurant: restaurants[index],
                                customer: customers[index],
                                order: orders[index],
                                amount: orders[index].amount!,
                                foodName: orders[index].foodName!,
                                foodPrice: orders[index].foodPrice!,
                                message: orders[index].message!,
                                restaurantName: orders[index].restaurantName!,
                                sum: orders[index].sum!,
                                sumTotal: orders[index].sumTotal!,
                                transport: orders[index].transport!,
                                total: total!,
                              ),
                            ),
                          );
                        }
                      });
                    },
                    child: Card(
                        child: Row(
                      children: [
                        Container(
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30, left: 50.0),
                            child: Text(
                              'คลิกเพื่อดูรายละเอียดการจัดส่ง',
                              style: MyFont().lookpeach18(),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
