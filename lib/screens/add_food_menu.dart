//เพิ่มข้อมูลอาหาร

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:fooddelivery_project/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFoodMenu extends StatefulWidget {
  const AddFoodMenu({Key? key}) : super(key: key);

  @override
  _AddFoodMenuState createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  String nameFood = '',
      foodPrice = '',
      detail = ''; //สร้างตัวแปรรับค่าข้อมูลมาเพื่อเพิ่มอาหาร
  File? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มเมนูอาหาร',
          style: TextStyle(fontFamily: 'peach'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            showTitleFood(), //method แสดงชื่อรูปภาพ
            SizedBox(height: 10.0),
            showImage(), //method แสดงรูปภาพ
            SizedBox(height: 10.0),
            showDetailTitle(), // method แสดงรายละเอียด
            SizedBox(height: 10.0),
            nameFoodForm(), //method ป้อนชื่ออาหาร
            SizedBox(height: 10.0),
            priceFoodForm(), //method ป้อนราคาอาหาร
            SizedBox(height: 10.0),
            detailFoodForm(), //method ป้อนรายละเอียดอาหาร
            SizedBox(height: 145.0),
            buttonAddFood(), //method ปุ่มเพิ่มอาหาร
          ],
        ),
      ),
    );
  }

//method ฟอร์มเพื่มชื่ออาหาร
  Widget nameFoodForm() => Container(
        width: 300.0,
        child: TextField(
          onChanged: (value) {
            nameFood = value
                .trim(); //ชื่ออาหาร ตัวแปร nameFood สร้างมาเพื่อ รับค่าข้อมูลจากฟอร์ม
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.fastfood),
            labelText: 'ชื่ออาหาร',
            labelStyle: TextStyle(fontFamily: 'peach'),
            border: OutlineInputBorder(),
          ),
        ),
      );

  //method เพิ่มราคาอาหาร
  Widget priceFoodForm() => Container(
        width: 300.0,
        child: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            foodPrice = value
                .trim(); //ราคาอาหาร ตัวแปร foodPrice สร้างมาเพื่อ รับค่าข้อมูลจากฟอร์ม
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.price_change_outlined),
            labelText: 'ราคา',
            labelStyle: TextStyle(
              fontFamily: 'peach',
            ),
            border: OutlineInputBorder(),
          ),
        ),
      );

//method ปุ่มเพิ่มอาหาร
  Widget buttonAddFood() {
    return Container(
      width: MediaQuery.of(context).size.width, //ขนาดปุ่ม
      child: RaisedButton.icon(
          color: Colors.green,
          icon: Icon(Icons.save),
          label: Text(
            'บันทึก',
            style: TextStyle(fontFamily: 'peach', color: Colors.white),
          ),
          onPressed: () {
            //check ชื่อว่าง
            if (_image == null) {
              normalDialog(context, 'กรุณาเลือกรูปภาพ');
            } else if (nameFood == '') {
              normalDialog(context, 'กรุณาใส่ชื่ออาหาร');
            } else if (foodPrice == '') {
              normalDialog(context, 'กรุณาใส่ราคา');
            } else {
              //ถ้าข้อมูลครบ เรียกใข้ method btnUploadFoodInsertData
              btnUploadFoodInsertData();
            }
          }),
    );
  }

//method ปุ่ม อัพโหลดข้อมูลอาหาร
  Future<Null> btnUploadFoodInsertData() async {
    Random randomNameFood = Random(); //สุ่มชื่ออาหาร
    int i = randomNameFood.nextInt(10000000);
    String foodFileName = 'food$i.jpg';

    String urlUploadFood =
        '${MyIpAddress().domain}/FoodDelivery/saveDataFood.php'; //url php อัพโหลด รูปภาพ

    try {
      //Map map เป็น Data Structure อีกตัวหนึ่ง ซึ่งเป็นแบบ key-value (คล้ายๆ List
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(_image!.path, filename: foodFileName);
      FormData formData = FormData.fromMap(
          map); //FormData เป็นการอัพโหลดภาพและไฟล์ไปยังเซิร์ฟเวอร์

      await Dio().post(urlUploadFood, data: formData).then(
        (value) async {
          String urlPathImage =
              '/FoodDelivery/Food/$foodFileName'; //ถ้าทำงานสำเร็จไปเก็บไว้ในไฟล์ Food ในโฟลเดอร์
          print('urlPathImage = ${MyIpAddress().domain}$urlPathImage');

          SharedPreferences preferences = await SharedPreferences.getInstance();
          String idChef = preferences.getString('id').toString();

          String urlInsertData =
              '${MyIpAddress().domain}/foodDelivery/addFood.php?isAdd=true&IdChef=$idChef&NameFood=$nameFood&Image=$urlPathImage&Price=$foodPrice&Detail=$detail';

          await Dio()
              .get(urlInsertData)
              .then((value) => Navigator.pop(context));
          normalDialog(context, 'เพิ่มเมนูอาหารเรียบร้อย');
        },
      );
    } catch (e) {}
  }

  Widget detailFoodForm() => Container(
        width: 300.0,
        child: TextField(
          onChanged: (value) {
            detail = value.trim();
          },
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.details),
            labelText: 'รายละเอียด',
            labelStyle: TextStyle(fontFamily: 'peach'),
            border: OutlineInputBorder(),
          ),
        ),
      );

  Text showDetailTitle() {
    return Text(
      'รายละเอียดอาหาร',
      style: TextStyle(fontFamily: 'peach', fontSize: 18.0),
    );
  }

  Text showTitleFood() {
    return Text(
      'รูปภาพ อาหาร',
      style: TextStyle(
        fontFamily: 'peach',
        fontSize: 20.0,
      ),
    );
  }

  Row showImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          onPressed: () {
            chooseImage(ImageSource.camera);
          },
          icon: Icon(
            Icons.add_a_photo,
            size: 40.0,
          ),
        ),
        Container(
          width: 250.0,
          height: 250.0,
          child: _image == null
              ? Image.asset('images/foodDefult.png')
              : Image.file(_image!),
        ),
        IconButton(
          onPressed: () {
            chooseImage(ImageSource.gallery);
          },
          icon: Icon(Icons.add_photo_alternate, size: 40.0),
        ),
      ],
    );
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.platform.pickImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );

      setState(() {
        if (object != null) {
          _image = File(object.path);
        } else {
          print('No Image Selected');
        }
      });
    } catch (e) {}
  }
}
