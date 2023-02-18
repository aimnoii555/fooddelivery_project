import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/customer/debouncer.dart';
import 'package:fooddelivery_project/customer/select_food.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/category.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/restaurant/add_category.dart';
import 'package:fooddelivery_project/restaurant/food_data.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowCategory extends StatefulWidget {
  final Restaurant restaurant;
  const ShowCategory({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<ShowCategory> createState() => _ShowCategoryState();
}

class _ShowCategoryState extends State<ShowCategory> {
  List<Category> categories = [];
  Restaurant? restaurant;
  String? idRes;
  final Debouncer debouncer = Debouncer(milliseconds: 500);
  List<Category> filterCategories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restaurant = widget.restaurant;
    getCategory();
  }

  Future<Null> getCategory() async {
    if (categories.length != 0) {
      categories.clear();
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idRes = restaurant!.id;
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getCategoryWhereIdRes.php?isAdd=true&idRes=$idRes';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      if (result == null) {
        dialog(context, 'ไม่มีรายการอาหาร');
      }
      for (var map in result) {
        Category category = Category.fromJson(map);

        setState(() {
          categories.add(category);
          filterCategories.add(category);
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
            margin: EdgeInsets.only(left: 5),
            width: 380,
            height: 90,
            padding: const EdgeInsets.only(top: 40.0),
            child: TextFormField(
              cursorColor: Colors.white,
              style: MyFont().colorWhite(),
              onChanged: (value) {
                debouncer.run(() {
                  setState(() {
                    filterCategories = categories
                        .where((u) => (u.categoryName!
                            .toLowerCase()
                            .contains(value.toLowerCase())))
                        .toList();
                  });
                });
              },
              decoration: InputDecoration(
                hintText: 'ค้นหารประเภทอาหาร',
                hintStyle: MyFont().lookpeachWhite(),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 100, left: 10, right: 10),
            child: categories.length == 0
                ? showProgress()
                : ListView.builder(
                    itemCount: filterCategories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          print('index = $index');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectFood(
                                restaurant: restaurant!,
                                idCategory: categories[index].id!,
                                category: categories[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          child: Card(
                            color: Colors.blue.shade300,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 30, top: 30),
                              child: Text(
                                ('${filterCategories[index].categoryName}'),
                                textAlign: TextAlign.center,
                                style: MyFont().lookpeachWhite18(),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
          ),
        ],
      ),
    ));
  }
}
