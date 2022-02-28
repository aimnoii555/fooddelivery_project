import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddelivery_project/model/cart_model.dart';
import 'package:fooddelivery_project/model/food_model.dart';
import 'package:fooddelivery_project/model/user_model.dart';
import 'package:fooddelivery_project/utility/debouncer.dart';
import 'package:fooddelivery_project/utility/my_api.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:fooddelivery_project/utility/my_style.dart';
import 'package:fooddelivery_project/utility/normal_dialog.dart';
import 'package:fooddelivery_project/utility/sqlite_helper.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class ShowMenuFood extends StatefulWidget {
  final UserModel userModel;
  const ShowMenuFood({Key? key, required this.userModel}) : super(key: key);

  @override
  _ShowMenuFoodState createState() => _ShowMenuFoodState();
}

class _ShowMenuFoodState extends State<ShowMenuFood> {
  UserModel? userModel;
  String idChef = '';

  List<FoodModel> foodModels = [];
  List<FoodModel> filterfoodModels = [];

  int amount = 1;
  late double lat1, lng1, lat2, lng2;
  Location location = Location();
  final Debouncer debouncer = Debouncer(milliseconds: 5000);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    readFoodMenu();
    findLocation();
    _searchBar();
  }

  Future<Null> findLocation() async {
    location.onLocationChanged.listen((event) {
      lat1 = event.latitude!;
      lng1 = event.longitude!;
      //print('lat1 = $lat1, lng1 = $lng1');
    });
  }

  Future<Null> readFoodMenu() async {
    idChef = userModel!.id!;
    String url =
        '${MyIpAddress().domain}/FoodDelivery/getFoodWhereId.php?isAdd=true&IdChef=$idChef';

    Response response = await Dio().get(url);
    //print('res --> $response');
    var result = json.decode(response.data);
    for (var map in result) {
      FoodModel foodModel = FoodModel.fromJson(map);
      setState(() {
        foodModels.add(foodModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return foodModels.length == 0
        ? MyStyle().showProgress()
        : ListView.builder(
            itemCount: foodModels.length,
            itemBuilder: (context, index) {
              return showListFood(index);
            },
          );
  }

  _searchBar() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Search'),
        onChanged: (value) {
          debouncer.run(() {
            foodModels = foodModels
                .where((u) => (u.nameFood
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase())))
                .toList();
            print('filterFoodModel = $foodModels');
          });
        },
      ),
    );
  }

  Card showListFood(int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      margin: EdgeInsets.only(right: 10.0, top: 10.0, left: 10.0),
      child: GestureDetector(
        onTap: () {
          // print('You Click Index = $index');
          amount = 1;
          addOrder(index);
        },
        child: Row(
          children: [
            showImageFood(index),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.3,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    nameFood(index),
                    price(index),
                    detail(context, index),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> addOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                foodModels[index].nameFood!,
                style: TextStyle(
                  fontFamily: 'peach',
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 220.0,
                height: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: NetworkImage(
                        '${MyIpAddress().domain}/${foodModels[index].image}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        amount++;
                        // print('amount= $amount');
                      });
                    },
                    icon: Icon(
                      Icons.add_circle,
                      size: 36.0,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    amount.toString(),
                    style: TextStyle(fontFamily: 'peach', fontSize: 18.0),
                  ),
                  IconButton(
                    onPressed: () {
                      if (amount > 1) {
                        setState(() {
                          amount--;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.remove_circle,
                      size: 36.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    onPressed: () {
                      Navigator.pop(context);
                      //print('Order ${foodModels[index].nameFood} Amount= $amount');
                      addCart(index);
                    },
                    child: Text(
                      'เพื่มในตะกร้า',
                      style:
                          TextStyle(fontFamily: 'peach', color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ยกเลิก',
                      style:
                          TextStyle(fontFamily: 'peach', color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> addCart(int index) async {
    String nameChef = userModel!.nameChef!;
    String idFood = foodModels[index].id!;
    String nameFood = foodModels[index].nameFood!;
    String price = foodModels[index].price!;

    double priceDouble = double.parse(price);
    double sum = priceDouble * amount;
    lat2 = double.parse(userModel!.lat!);
    lng2 = double.parse(userModel!.lng!);

    double distance = MyAPI().calculateDistance(lat1, lng1, lat2, lng2);
    var myFormat = NumberFormat('#0.0#', 'en_US');
    String distanceString = myFormat.format(distance);

    int? transport = MyAPI().calculateTransport(distance);
    print('transport = $transport');

    // print(
    //     'idChef = $idChef, nameChef = $nameChef, idFood = $idFood, nameFood = $nameFood, price = $price, amount = $amount, sum=$sum, distanceString = $distanceString, transport = $transport');

    String url =
        '${MyIpAddress().domain}/foodDelivery/addCart.php?isAdd=true&IdChef=$idChef&NameChef=$nameChef&IdFood=$idFood&NameFood=$nameFood&Price=$price&Amount=$amount&Sum=$sum&Distance=$distanceString&Transport=$transport';

    Map<String, dynamic> map = Map();
    map['idChef'] = idChef;
    map['nameChef'] = nameChef;
    map['idFood'] = idFood;
    map['nameFood'] = nameFood;
    map['price'] = price;
    map['amount'] = amount.toString();
    map['sum'] = sum.toString();
    map['distance'] = distanceString.toString();
    map['transport'] = transport.toString();
    print('map = ${map.toString()}');

    CartModel cartModel = CartModel.fromJson(map);

    var object = await SQLiteHelper().readAllCart();
    print('object = ${object.length}');

    if (object.length == 0) {
      await SQLiteHelper().insertData(cartModel).then((value) {
        print('insert Success');
        showToast();
      });
    } else {
      String idChefSQL = object[0].idChef!;
      print('idChef = $idChef');
      if (idChef == idChefSQL) {
        await SQLiteHelper().insertData(cartModel).then((value) {
          showToast();
        });
      } else {
        normalDialog(context, 'มีรายการอาหารร้าน ${object[0].nameChef} แล้ว');
      }
    }

    // Future<Null> getCart(index) async {
    //   String url =
    //       '${MyIpAddress().domain}/foodDelivery/getCartWhereId.php?isAdd=true&IdChef=$idChef';
    //   await Dio().get(url).then(
    //     (value) {
    //       if (value.toString() == 'true') {
    //         normalDialog(context, 'เพิ่มในตะกร้าเรียบร้อย');
    //       } else {
    //         Navigator.pop(context);
    //       }
    //     },
    //   );
    // }

//---------------------------------------------------------------------
  }

  Text price(int index) {
    return Text(
      'ราคา ${foodModels[index].price!} บาท',
      style: TextStyle(fontFamily: 'peach', fontSize: 16.0),
    );
  }

  Container detail(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 20.0),
      width: MediaQuery.of(context).size.width * 0.5 - 15.0,
      child: Text(
        'รายละเอียด ${foodModels[index].detail!}',
        style: TextStyle(fontFamily: 'peach', fontSize: 14.0),
      ),
    );
  }

  Text nameFood(int index) {
    return Text(
      '${foodModels[index].nameFood!}',
      style: TextStyle(
          fontFamily: 'peach', fontSize: 18.0, fontWeight: FontWeight.bold),
    );
  }

  Container showImageFood(int index) {
    return Container(
      margin: EdgeInsets.only(
        top: 10.0,
        left: 10.0,
        bottom: 10.0,
      ),
      width: 120.0,
      height: 120.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        image: DecorationImage(
          image: NetworkImage(
            '${MyIpAddress().domain}/${foodModels[index].image}',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void showToast() {
    Fluttertoast.showToast(msg: 'เพิ่มลงในตะกร้าเรียบร้อยแล้ว');
  }
}
