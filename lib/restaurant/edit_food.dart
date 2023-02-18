import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/food.dart';
import 'package:fooddelivery_project/restaurant/food_data.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditFood extends StatefulWidget {
  Food food;
  EditFood({Key? key, required this.food}) : super(key: key);

  @override
  State<EditFood> createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  String? foodName, foodPrice, menuFood, detail, editImage;
  File? _image;
  Food? food;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    food = widget.food;
    foodName = food!.foodName;
    foodPrice = food!.foodPrice;
    menuFood = food!.menuFood;
    detail = food!.detail;
    editImage = food!.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'แก้ไขเมนูอาหาร ${food!.foodName}',
            style: MyFont().lookpeachWhite(),
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
          child: food == null
              ? showProgress()
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () async {
                                try {
                                  var object = await ImagePicker.platform
                                      .pickImage(
                                          source: ImageSource.camera,
                                          maxHeight: 800.0,
                                          maxWidth: 800.0);

                                  setState(() {
                                    if (object != null) {
                                      _image = File(object.path);
                                    } else {
                                      print('No Image Selected');
                                    }
                                  });
                                } catch (e) {}
                              },
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: 36.0,
                              ),
                            ),
                            Container(
                              width: 250,
                              height: 250,
                              child: food!.image == null
                                  ? showProgress()
                                  : _image == null
                                      ? Image.network(
                                          '${MyHost().domain}/$editImage')
                                      : Image.file(_image!),
                            ),
                            IconButton(
                              onPressed: () async {
                                var object =
                                    await ImagePicker.platform.pickImage(
                                  source: ImageSource.gallery,
                                  maxHeight: 800,
                                  maxWidth: 800,
                                );

                                setState(() {
                                  if (object != null) {
                                    _image = File(object.path);
                                  } else {
                                    print('No Image Selected');
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.add_photo_alternate,
                                color: Colors.white,
                                size: 36.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        width: 300.0,
                        child: TextFormField(
                          style: MyFont().colorWhite(),
                          cursorColor: Colors.white,
                          onChanged: (value) {
                            foodName = value.trim();
                          },
                          initialValue: foodName,
                          decoration: InputDecoration(
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
                            labelText: 'ชื่ออาหาร',
                            labelStyle: MyFont().lookpeachWhite(),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        width: 300.0,
                        child: TextFormField(
                          style: MyFont().colorWhite(),
                          cursorColor: Colors.white,
                          onChanged: (value) {
                            foodPrice = value.trim();
                          },
                          initialValue: foodPrice,
                          decoration: InputDecoration(
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
                            labelText: 'ราคา',
                            labelStyle: MyFont().lookpeachWhite(),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        width: 300.0,
                        child: TextFormField(
                          style: MyFont().colorWhite(),
                          cursorColor: Colors.white,
                          onChanged: (value) {
                            detail = value.trim();
                          },
                          initialValue: detail,
                          decoration: InputDecoration(
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
                            labelText: 'รายละเอียด',
                            labelStyle: MyFont().lookpeachWhite(),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        width: 300.0,
                        child: TextFormField(
                          style: MyFont().colorWhite(),
                          cursorColor: Colors.white,
                          onChanged: (value) {
                            menuFood = value.trim();
                          },
                          initialValue: menuFood,
                          decoration: InputDecoration(
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
                            labelText: 'เมนูอาหาร',
                            labelStyle: MyFont().lookpeachWhite(),
                          ),
                        ),
                      ),
                      SizedBox(height: 120.0),
                      Container(
                        width: 300,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: const LinearGradient(
                            begin: Alignment(-0.95, 0.0),
                            end: Alignment(1.0, 0.0),
                            colors: [
                              Colors.blue,
                              Color.fromARGB(255, 223, 158, 153),
                            ],
                            stops: [0.0, 1.0],
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            onSurface: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => SimpleDialog(
                                title: Text(
                                  'ยืนยันการแก้ไขข้อมูลอาหาร',
                                  style: MyFont().lookpeach(),
                                ),
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          String id = food!.id!;
                                          print('id = $id');

                                          Random random = Random();
                                          int i = random.nextInt(100000);
                                          String nameFile = 'editFood$i.jpg';

                                          Map<String, dynamic> map = Map();
                                          map['file'] =
                                              await MultipartFile.fromFile(
                                                  _image!.path,
                                                  filename: nameFile);
                                          FormData formData =
                                              FormData.fromMap(map);

                                          String urlUpload =
                                              '${MyHost().domain}/Project_Flutter/FoodDelivery/saveDataFood.php';
                                          print('urlUpload = $urlUpload');

                                          await Dio()
                                              .post(urlUpload, data: formData)
                                              .then((value) async {
                                            editImage =
                                                '/Project_Flutter/FoodDelivery/Food/$nameFile';

                                            String urlEdit =
                                                '${MyHost().domain}/Project_Flutter/FoodDelivery/editFoodWhereId.php?isAdd=true&id=$id&FoodName=$foodName&FoodPrice=$foodPrice&Detail=$detail&MenuFood=$menuFood&Image=$editImage';

                                            Response response =
                                                await Dio().get(urlEdit);

                                            print('response == $response');

                                            if (response.toString() != 'true') {
                                              dialog(context, 'แก้ไขเรียบร้อย');
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            } else {
                                              Navigator.pop(context);
                                              // ignore: use_build_context_synchronously
                                              dialog(
                                                  context, 'ไม่สามารถแก้ไขได้');
                                            }
                                          });

                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                          child: const Center(
                            child: Text(
                              'เข้าสู่ระบบ',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'lookpeach',
                                color: const Color(0xffffffff),
                                letterSpacing: -0.3858822937011719,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }
}
