//แสดงรายการข้อร้านค้าใน User
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/model/user_model.dart';
import 'package:fooddelivery_project/screens/show_chef_food_menu.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:fooddelivery_project/utility/my_style.dart';

class ShowListChefAll extends StatefulWidget {
  const ShowListChefAll({Key? key}) : super(key: key);

  @override
  _ShowListChefAllState createState() => _ShowListChefAllState();
}

class _ShowListChefAllState extends State<ShowListChefAll> {
  List<UserModel> userModels = [];
  List<Widget> ChefData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readChef();
  }

  // method readChef อ่านข้อมูลจากร้านค้ามาแสดงใน User
  Future<Null> readChef() async {
    String url =
        '${MyIpAddress().domain}/foodDelivery/getUserWhereChooseType.php?isAdd=true&ChooseType=Chef';
    await Dio().get(url).then(
      (value) {
        //print('value = $value');
        var result = json.decode(value.data); //convert json
        int index = 0;
        for (var map in result) {
          UserModel model = UserModel.fromJson(map); //แสดงข้อมูลจาก json
          // print('NameChef = ${model.nameChef}');
          String nameChef = model.nameChef!; //ตัวแปรแสดงชื่อร้าน
          //ถ้าชื่อร้านในมีใน database ให้แสดงข้อมูล
          if (nameChef.isNotEmpty) {
            print('NameChef = ${model.nameChef}');
            setState(
              () {
                userModels.add(model); //add data show Chef
                ChefData.add(
                  createData(model, index),
                );
                index++;
              },
            );
          }
        }
      },
    );
  }

  Widget createData(UserModel userModel, int index) {
    return GestureDetector(
      onTap: () {
        print('You CLick index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowChefFoodMenu(
            userModel: userModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 80.0,
                height: 80.0,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      '${MyIpAddress().domain}/${userModel.urlPicture}'),
                )),
            SizedBox(height: 10.0),
            Text(
              userModel.nameChef!,
              style: TextStyle(fontFamily: 'peach', fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChefData.length == 0
        ? MyStyle().showProgress()
        : GridView.extent(
            maxCrossAxisExtent: 200.0,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: ChefData,
          );
  }
}
