import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFood extends StatefulWidget {
  final String idCategory;
  const AddFood({Key? key, required this.idCategory}) : super(key: key);

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  String? foodName, foodPrice, detail, menuFood, idCategory;
  File? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idCategory = widget.idCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มเมนูอาหาร',
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
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () async {
                          try {
                            var object = await ImagePicker.platform.pickImage(
                              source: ImageSource.camera,
                              maxHeight: 800.0,
                              maxWidth: 800.0,
                            );
                            setState(() {
                              if (object != null) {
                                image = File(object.path);
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
                        width: 250.0,
                        height: 250.0,
                        child: image == null
                            ? Image.asset('images/foodDefault.png')
                            : Image.file(image!),
                      ),
                      IconButton(
                          onPressed: () async {
                            try {
                              var object = await ImagePicker.platform.pickImage(
                                source: ImageSource.gallery,
                                maxHeight: 800.0,
                                maxWidth: 800.0,
                              );
                              setState(() {
                                if (object != null) {
                                  image = File(object.path);
                                } else {
                                  print('No Image Selected');
                                }
                              });
                            } catch (e) {}
                          },
                          icon: const Icon(
                            Icons.add_photo_alternate,
                            color: Colors.white,
                            size: 36.0,
                          )),
                    ],
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
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.restaurant_menu,
                          color: Colors.white,
                        ),
                        labelText: 'ชื่ออาหาร',
                        labelStyle: MyFont().lookpeachWhite(),
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
                  SizedBox(height: 15.0),
                  Container(
                    width: 300.0,
                    child: TextFormField(
                      style: MyFont().colorWhite(),
                      cursorColor: Colors.white,
                      onChanged: (value) {
                        foodPrice = value.trim();
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.money,
                          color: Colors.white,
                        ),
                        labelText: 'ราคา',
                        labelStyle: MyFont().lookpeachWhite(),
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
                  SizedBox(height: 15.0),
                  Container(
                    width: 300.0,
                    child: TextFormField(
                      style: MyFont().colorWhite(),
                      cursorColor: Colors.white,
                      onChanged: (value) {
                        detail = value.trim();
                      },
                      maxLines: 3,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.details,
                          color: Colors.white,
                        ),
                        labelText: 'รายละเอียด',
                        labelStyle: MyFont().lookpeachWhite(),
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
                  SizedBox(height: 15.0),
                  Container(
                    width: 300.0,
                    child: TextFormField(
                      style: MyFont().colorWhite(),
                      cursorColor: Colors.white,
                      onChanged: (value) {
                        menuFood = value.trim();
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.restaurant_menu,
                          color: Colors.white,
                        ),
                        labelText: 'เมนูอาหาร',
                        labelStyle: MyFont().lookpeachWhite(),
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
                  SizedBox(height: 20.0),
                  Container(
                    width: 350,
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
                      onPressed: () async {
                        if (foodName == '') {
                          dialog(context, 'กรุณาใส่ชื่ออาหาร');
                        } else if (image == null) {
                          dialog(context, 'กรุณาเลือกรูปภาพอาหาร');
                        } else if (foodPrice == '') {
                          dialog(context, 'กรุณาใส่ราคาอาหาร');
                        } else {
                          Random randomFoodName = Random();
                          int i = randomFoodName.nextInt(1000000);
                          String foodFileName = 'food$i.jpg';

                          String url =
                              '${MyHost().domain}/Project_Flutter/FoodDelivery/saveDataFood.php';
                          try {
                            Map<String, dynamic> map = Map();
                            map['file'] = await MultipartFile.fromFile(
                              image!.path,
                              filename: foodFileName,
                            );
                            FormData formData = FormData.fromMap(map);
                            await Dio()
                                .post(url, data: formData)
                                .then((value) async {
                              String urlPathImage =
                                  '/Project_Flutter/FoodDelivery/Food/$foodFileName';
                              print('urlPathImage ====== $urlPathImage');

                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              String resID =
                                  preferences.getString('id').toString();

                              print(
                                  '-----------$resID,$foodName,$foodPrice,$detail,$menuFood');

                              String url =
                                  '${MyHost().domain}/Project_Flutter/FoodDelivery/addFood.php?isAdd=true&idCategory=$idCategory&idRes=$resID&FoodName=$foodName&FoodPrice=$foodPrice&Image=$urlPathImage&Detail=$detail&MenuFood=$menuFood&Depleted=open';

                              await Dio().get(url).then((value) => {
                                    print('value = $value'),
                                    Navigator.pop(context),
                                    dialog(context, 'เพิ่มเมนูอาหารเรียบร้อย'),
                                  });
                            });
                          } catch (e) {}
                        }
                      },
                      child: const Center(
                        child: Text(
                          'ตกลง',
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
          ),
        ),
      ),
    );
  }
}
