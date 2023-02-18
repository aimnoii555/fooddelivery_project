import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/food.dart';
import 'package:fooddelivery_project/restaurant/add_category.dart';
import 'package:fooddelivery_project/restaurant/add_food.dart';
import 'package:fooddelivery_project/restaurant/edit_food.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodData extends StatefulWidget {
  final String idCategory;
  const FoodData({Key? key, required this.idCategory}) : super(key: key);

  @override
  State<FoodData> createState() => _FoodDataState();
}

class _FoodDataState extends State<FoodData> {
  List<Food> foods = [];
  String? idCategory;

  bool loadStatus = true; // Process Load
  bool status = true; // have data
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idCategory = widget.idCategory;
    getFoodData();
  }

  Future<Void?> getFoodData() async {
    if (foods.length != 0) {
      loadStatus = true;
      foods.clear();
      status = true;
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String resID = preferences.getString('id').toString();
    print('idRes = $resID');

    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getFoodWhereCategory.php?isAdd=true&idCategory=$idCategory';

    await Dio().get(url).then((value) {
      setState(
        () {
          loadStatus = false; // no Process loead
        },
      );
      if (value.toString() != '') {
        var result = json.decode(value.data);

        for (var map in result) {
          Food food = Food.fromJson(map);
          setState(() {
            foods.add(food);
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
        appBar: AppBar(
          title: Text(
            'ข้อมูลอาหาร',
            style: MyFont().lookpeachWhite18(),
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
          child: Stack(
            children: [
              loadStatus
                  ? showProgress()
                  : status
                      ? displayMenuRestaurant()
                      : const Center(
                          child: Text('ยังไม่มีรายการอาหาร'),
                        ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 20.0, right: 20.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            addFood();
                          },
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  addFood() {
    MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => AddFood(idCategory: idCategory!));
    Navigator.push(context, route).then((value) => getFoodData());
  }

  editDataFood(int index) {
    MaterialPageRoute route = MaterialPageRoute(
        builder: ((context) => EditFood(
              food: foods[index],
            )));
    Navigator.push(context, route).then((value) => getFoodData());
  }

  Future<Null> deleteDataFood(Food foods) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'ยืนยันการลบเมนูอาหาร ${foods.foodName}',
          style: MyFont().lookpeach(),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    dialog(context, 'Delete Food Finish');
                    String urlDelete =
                        '${MyHost().domain}/Project_Flutter/FoodDelivery/deleteFood.php?isAdd=true&idRes=${foods.id}';
                    await Dio().get(urlDelete).then((value) {
                      if (value == null) {
                        showProgress();
                      } else {
                        getFoodData();
                      }
                    });
                  },
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget displayMenuRestaurant() {
    return Container(
      child: ListView.builder(
        itemCount: foods.length,
        itemBuilder: ((context, index) {
          return Container(
            child: Card(
              color: Color.fromARGB(255, 151, 212, 236),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(20.0),
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    child: status == false
                        ? showProgress()
                        : Image.network(
                            '${MyHost().domain}${foods[index].image}',
                            fit: BoxFit.cover,
                          ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Text(
                                foods[index].foodName!,
                                style: MyFont().lookpeachWhite20(),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'ราคา ${foods[index].foodPrice} บาท',
                                style: MyFont().lookpeachWhite(),
                              ),
                              Text(
                                'เมนูอาหาร ${foods[index].menuFood}',
                                style: MyFont().lookpeachWhite(),
                              ),
                              Text(
                                'รายละเอียด ${foods[index].detail}',
                                style: MyFont().lookpeachWhite(),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      editDataFood(index);
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      deleteDataFood(foods[index]);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (foods[index].depleted == 'close')
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green),
                              onPressed: () async {
                                String url =
                                    '${MyHost().domain}/Project_Flutter/FoodDelivery/updateFoodDepleted.php?isAdd=true&Depleted=open&id=${foods[index].id}';
                                await Dio()
                                    .get(url)
                                    .then((value) => getFoodData());
                              },
                              child: Text('แสดงอาหาร'),
                            ),
                          if (foods[index].depleted == 'open')
                            ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                              onPressed: () async {
                                String url =
                                    '${MyHost().domain}/Project_Flutter/FoodDelivery/updateFoodDepleted.php?isAdd=true&Depleted=close&id=${foods[index].id}';
                                await Dio()
                                    .get(url)
                                    .then((value) => getFoodData());
                              },
                              child: Text('อาหารหมด'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
