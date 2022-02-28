//หน้ารายการอาหารของร้าน

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/model/food_model.dart';
import 'package:fooddelivery_project/screens/add_food_menu.dart';
import 'package:fooddelivery_project/screens/edit_food_menu.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:fooddelivery_project/utility/my_style.dart';
import 'package:fooddelivery_project/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListFoodMenu extends StatefulWidget {
  const ListFoodMenu({Key? key}) : super(key: key);

  @override
  _ListFoodMenuState createState() => _ListFoodMenuState();
}

class _ListFoodMenuState extends State<ListFoodMenu> {
  bool loadStatus = true; //Process Load
  bool status = true; //มีข้อมูล
  List<FoodModel> foodModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readFoodMenu();
  }

  //method get data from database
  Future<Null> readFoodMenu() async {
    //เคลียร์เมนูอาหารที่ค้างไว้เพื่อไม่เมนูเก่าอัพลง database
    if (foodModels.length != 0) {
      loadStatus = true;
      foodModels.clear();
      status = true;
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idChef = preferences
        .getString('id')
        .toString(); //รับ id จากผู้ใช้งานที่สมัครมา เพื่อเรียกใช้ จาก sigin.dart
    print('idChef = $idChef');

    //แสดงตัวตัว สตริงไว้กับ path url เพื่อใช้ในการ get จากข้อมูล
    String urlReadFoodMenu =
        '${MyIpAddress().domain}/foodDelivery/getFoodWhereId.php?isAdd=true&IdChef=$idChef'; //url path ภาษา php ที่ใช้ในการติดต่อกับฐานข้อมูลเพื่ออ่านค่าจากฐานข้อมูลขึ้นมาแสดง

    //read ค่าจาก api จาก database
    await Dio().get(urlReadFoodMenu).then((value) {
      setState(() {
        loadStatus = false; //no Process Load
      });

      if (value.toString() != '') {
        //มีข้อมูล
        var result = json.decode(value.data); //แปลง json ให้เป็นภาษาไทย
        // print('result = $result');
        for (var map in result) {
          //
          FoodModel foodModel = FoodModel.fromJson(map);
          setState(
            () {
              foodModels.add(foodModel); //แสดงรายการอาหาร for loop
            },
          );
        }
      } else {
        setState(() {
          status = false; // ไม่มีข้อมูล
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        loadStatus
            ? MyStyle().showProgress()
            : showContent(), //ถ้ายังไม่มีรายการอาหารให้แสดง method showContent แสดงข้อความยังไม่มีรายการอาหาร
        addMenuButton(), //method ปุ่มเพื่มอาหาร
      ],
    );
  }

//method แสดงรายการอาหาร
  Widget showContent() {
    return status
        ? showListFood() //ถ้า status = true มีข้อมูล
        : Center(
            child: Text('ยังไม่มีรายการอาหาร'), //ถ้า status ไม่มีข้อมูล
          );
  }

  Future<void> _refresh() {
    return Future.delayed(Duration(seconds: 0));
  }

//method แสดงรายการอาหาร
  Widget showListFood() => RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        edgeOffset: 0,
        displacement: 200,
        strokeWidth: 5,
        color: Colors.yellow,
        onRefresh: _refresh,
        child: ListView.builder(
            itemCount: foodModels.length,
            itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Card(
                    child: Row(
                      children: <Widget>[
                        //พื้นที่ของจอแสดงรูปภาพ
                        Container(
                          padding: EdgeInsets.all(25.0),
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.2,
                          //get image from database มาแสดง
                          child: Image.network(
                            '${MyIpAddress().domain}/${foodModels[index].image!}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Container(
                            padding: EdgeInsets.only(right: 40.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    //get ชื่ออาหาร from database มาแสดง จาก foodModel
                                    '${foodModels[index].nameFood}',
                                    style: TextStyle(
                                        fontFamily: 'peach',
                                        fontSize: 16.0,
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    //get ราคาอาหาร from database มาแสดง จาก foodModel
                                    'ราคา ${foodModels[index].price} บาท',
                                    style: TextStyle(
                                        fontFamily: 'peach',
                                        fontSize: 10.0,
                                        color: Colors.blue),
                                  ),
                                  Text(
                                    //get รายละเอียดอาหาร from database มาแสดง จาก foodModel
                                    '${foodModels[index].detail}',
                                    style: TextStyle(
                                        fontFamily: 'peach', fontSize: 12.0),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      //ปุ่มแก้ไขเมนูอาหาร
                                      IconButton(
                                        onPressed: () {
                                          MaterialPageRoute route =
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditFood(
                                                        foodModel:
                                                            foodModels[index],
                                                      ));
                                          Navigator.push(context, route).then(
                                              (value) =>
                                                  readFoodMenu()); //ไปทำงานสำเร็จอ่านค้าใหม่ เพื่อให้ข้อมูล refresh หน้า
                                        },
                                        icon: Icon(Icons.edit,
                                            color: Colors.orange),
                                      ),
                                      //ปุ่มลบเมนูอาหาร
                                      IconButton(
                                        onPressed: () {
                                          deleteFood(foodModels[
                                              index]); //method delele food
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
      );

//method ลบรายการอาหาร
  Future<Null> deleteFood(FoodModel foodModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'ยืนยันการลบเมนูอาหาร ${foodModel.nameFood} หรือไม่?',
          style: TextStyle(fontFamily: 'peach', fontSize: 14.0),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  normalDialog(context, 'ลบเรียบร้อยแล้ว');
                  String urlDelete =
                      '${MyIpAddress().domain}/foodDelivery/deleteFood.php?isAdd=true&IdChef=${foodModel.id}'; //url path ภาษา php ที่ใช้ในการติดต่อกับฐานข้อมูลเพื่อ ลบข้อมูล
                  await Dio().get(urlDelete).then((value) => value == null
                      ? MyStyle().showProgress()
                      : readFoodMenu());
                },
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(
                    fontFamily: 'peach',
                    color: Colors.green,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                    fontFamily: 'peach',
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//method เพิ่มเมนูอาหาร
  Widget addMenuButton() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 20.0, right: 20.0),
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => AddFoodMenu());
                      Navigator.push(context, route)
                          .then((value) => readFoodMenu()); //refresh
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
