import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/model/category.dart';
import 'package:fooddelivery_project/restaurant/add_category.dart';
import 'package:fooddelivery_project/restaurant/food_data.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryData extends StatefulWidget {
  const CategoryData({Key? key}) : super(key: key);

  @override
  State<CategoryData> createState() => _CategoryDataState();
}

class _CategoryDataState extends State<CategoryData> {
  List<Category> categories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }

  Future<Null> getCategory() async {
    if (categories.length != 0) {
      categories.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idRes = preferences.getString('id');
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getCategoryWhereIdRes.php?isAdd=true&idRes=$idRes';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      for (var map in result) {
        Category category = Category.fromJson(map);

        setState(() {
          categories.add(category);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue,
              Color.fromARGB(255, 223, 158, 153),
            ]),
      ),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(8.0),
            child: Text(
              'ประเภทอาหาร',
              style: MyFont().lookpeachWhite18(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40, left: 10, right: 10),
            child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print('index = $index');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => FoodData(
                                idCategory: categories[index].id!,
                              )),
                        ),
                      );
                    },
                    child: Container(
                      child: Card(
                        color: Colors.blue.shade300,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 30, top: 30),
                          child: Text(
                            categories[index].categoryName!,
                            textAlign: TextAlign.center,
                            style: MyFont().lookpeachWhite18(),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
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
                        MaterialPageRoute route = MaterialPageRoute(
                            builder: (context) => AddCategory());
                        Navigator.push(context, route)
                            .then((value) => getCategory());
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
}
