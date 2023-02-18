import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/cal/calculateDistance.dart';
import 'package:fooddelivery_project/customer/about_restaurant.dart';
import 'package:fooddelivery_project/customer/select_food.dart';
import 'package:fooddelivery_project/customer/show_categories.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/category.dart';
import 'package:fooddelivery_project/model/sale.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class ShowRestaurant extends StatefulWidget {
  const ShowRestaurant({Key? key}) : super(key: key);

  @override
  State<ShowRestaurant> createState() => _ShowRestaurantState();
}

class _ShowRestaurantState extends State<ShowRestaurant> {
  List<Restaurant> restaurants = [];
  List<Widget> resData = [];
  List<Widget> resRecommend = [];
  String? orderAmount;

  List<Category> categories = [];

  String? resName;
  Restaurant? restaurant;
  Category? category;
  Sale? sale;

  double? lat1, lng1, lat2, lng2, distance;
  String distanceString = '';
  int? transport = 0;
  double? orderAmountDouble;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRes();
  }

  Future<LocationData?> getLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Future<Null> getRes() async {
    if (restaurants.length != 0) {
      resData.clear();
      resRecommend.clear();
  
    }

    LocationData? locationData = await getLocation();
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getResWhereType.php?isAdd=true&Type=Restaurant';

    await Dio().get(url).then(
      (value) {
        var result = json.decode(value.data);
        int index = 0;

        for (var map in result) {
          restaurant = Restaurant.fromJson(map);
          orderAmount = restaurant!.orderAmountRes!;

          resName = restaurant!.restaurantName!;

          if (this.mounted)
            // ignore: curly_braces_in_flow_control_structures
            setState(() {
              //ตำแหน่งของ Customer
              lat1 = locationData!.latitude!;
              lng1 = locationData.longitude!;
              // ตำแหน่งของ Resturant
              lat2 = double.parse(restaurant!.lat!);
              lng2 = double.parse(restaurant!.lng!);
              //print('lat2 = $lat2, lng2 = $lng2');
              distance = Cal().calShipping(lat1!, lng1!, lat2!, lng2!);
              var myFormat = NumberFormat('#0.0#', 'en_US');
              distanceString = myFormat.format(distance);

              // print('distance = $distanceString');
            });

          orderAmountDouble = double.parse(restaurant!.orderAmountRes!);
          print('orderAmountDouble = $orderAmountDouble');

          if (distance! <= 10 && resName!.isNotEmpty) {
            // print('resName === $resName');
            if (orderAmountDouble! >= 0 || orderAmountDouble! <= 50) {
              if (restaurant!.statusOff != 'close') {
                setState(
                  () {
                    restaurants.add(restaurant!);
                    resData.add(
                      selectRes(restaurant!, index),
                    );
                    index++;
                  },
                );
              }
            }
          }

          if (distance! <= 10 &&
              resName!.isNotEmpty &&
              orderAmountDouble! >= 500) {
            // print('resName === $resName');
            if (restaurant!.statusOff != 'close') {
              setState(
                () {
                  restaurants.add(restaurant!);
                  resRecommend.add(
                    selectRes(restaurant!, index),
                  );
                  index++;
                },
              );
            }
          }
        }
      },
    );
  }



  Widget selectRes(Restaurant restaurant, int index) {
    return GestureDetector(
      onTap: () {
        print('Click index = $index');

        MaterialPageRoute route = MaterialPageRoute(
          builder: ((context) => AboutRestaurant(
                restaurant: restaurants[index],
              )),
        );
        Navigator.push(context, route);
      },
      child: Card(
        color: Colors.blue.shade300,
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Container(
              child: CircleAvatar(
                radius: 26,
                backgroundImage:
                    NetworkImage('${MyHost().domain}/${restaurant.image}'),
              ),
            ),
            Text(
              'ร้าน ${resName}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontFamily: 'lookpeach',
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          child: Text(
            resRecommend.length == 0 ? '' : 'ร้านอาหารแนะนำ',
            style: MyFont().lookpeachWhite18(),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10.0, top: 150),
          child: Text(
            resData.length == 0 ? '' : 'ร้านอาหารทั่วไป',
            style: MyFont().lookpeachWhite18(),
          ),
        ),
        RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            getRes();
          },
          child: resData.length == 0
              ? showProgress()
              : Container(
                  height: MediaQuery.of(context).size.height * 0.27,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                    child: GridView.count(
                      physics: ScrollPhysics(),
                      crossAxisCount: 4,
                      crossAxisSpacing: 2.0,
                      mainAxisSpacing: 2.0,
                      children: resRecommend,
                    ),
                  ),
                ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.99,
          child: resData.length == 0
              ? showProgress()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(10, 180, 10, 0),
                  child: GridView.count(
                    physics: ScrollPhysics(),
                    crossAxisCount: 4,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                    children: resData,
                  ),
                ),
        ),
      ],
    );
  }
}
