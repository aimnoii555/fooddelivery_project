//แก้ไขข้อมูลอาหาร

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fooddelivery_project/model/food_model.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:fooddelivery_project/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditFood extends StatefulWidget {
  final FoodModel foodModel;

  EditFood({Key? key, required this.foodModel}) : super(key: key);

  @override
  _EditFoodState createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  FoodModel? foodModel;
  File? _image;
  //สร้างตัวแปรเพื่อรับค่าทำการแก้ไข
  String name = '', price = '', detail = '', editImage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //รับค่าตัวแปรจาก FoodModel มาแสดงข้อมูลเก่า
    foodModel = widget.foodModel;
    name = foodModel!.nameFood!;
    price = foodModel!.price!;
    detail = foodModel!.detail!;
    editImage = foodModel!.image!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แก้ไขเมนู ${foodModel!.nameFood}',
          style: TextStyle(fontFamily: 'peach'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            editImageFood(),
            editFoodName(),
            priceForm(),
            detailForm(),
            btnEditFood(),
          ],
        ),
      ),
    );
  }

//method ปุ่มแก้ไขรูปภาพ
  Widget btnEditFood() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: RaisedButton.icon(
        color: Colors.yellowAccent,
        onPressed: () {
          if (name.isEmpty || price.isEmpty || detail.isEmpty) {
            normalDialog(context, 'กรุณากรอกให้ครบทุกช่อง');
          } else {
            confirmEdit();
          }
        },
        icon: Icon(Icons.edit),
        label: Text(
          'บันทึก',
          style: TextStyle(fontFamily: 'peach'),
        ),
      ),
    );
  }

  Future<Null> confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'ยืนยันแก้ไขข้อมูลหรือไม่?',
          style: TextStyle(
            fontFamily: 'peach',
          ),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  editValueOnMySQL();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Text(
                  'ยืนยัน',
                  style: TextStyle(fontFamily: 'peach'),
                ),
              ),
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text(
                  'ยกเลิก',
                  style: TextStyle(fontFamily: 'peach'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

//Method button บันทึกเมื่อแก้ไขเสร็จ
  Future<Null> editValueOnMySQL() async {
    Map<String, dynamic> map = Map();
    Random randomName = Random();
    int i = randomName.nextInt(100000);
    String nameFile = 'editFood$i.jpg';

//อัพโหลดภาพและไฟล์ไปยังเซิร์ฟเวอร์
    map['file'] =
        await MultipartFile.fromFile(_image!.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);
    print('formData = $formData');

    String urlUpload = '${MyIpAddress().domain}/FoodDelivery/saveDataFood.php';
    await Dio().post(urlUpload, data: formData).then((value) async {
      //เปลี่ยนชื่อรูปภาพเมื่อ ถ้าอัพโหลดสำเร็จ
      editImage = 'FoodDelivery/Food/$nameFile';

      String id = foodModel!.id!;
      print('id = $id');

      String url =
          '${MyIpAddress().domain}/foodDelivery/editFoodWhereId.php?isAdd=true&id=$id&NameFood=$name&Image=$editImage&Price=$price&Detail=$detail';

      Response response = await Dio().get(url);

      if (response.toString() == 'true') {
        normalDialog(context, 'ไม่สามารถแก้ไขได้ กรุณาลองอีกครั้ง');
      } else {
        Navigator.pop(context);
        normalDialog(context, 'แก้ไขเรียบร้อย');
      }
    });
  }

  // Future<Null> editValueOnMySQL() async {
  //   Map<String, dynamic> map = Map();
  //   Random randomName = Random();
  //   int i = randomName.nextInt(100000);
  //   String nameFile = 'editChef$i.jpg';

  //   map['file'] =
  //       await MultipartFile.fromFile(_image!.path, filename: nameFile);
  //   FormData formData = FormData.fromMap(map);
  //   print('formData = $formData');

  //   String urlImage = '${MyIpAddress().domain}/FoodDelivery/saveDataFood.php';

  //   String id = foodModel!.id!;

  //   await Dio().post(urlUpload, data: formData).then((value) async {
  //     //เปลี่ยนชื่อรูปภาพเมื่อ ถ้าอัพโหลดสำเร็จ
  //     urlPicture = 'FoodDelivery/Chef/$nameFile';

  //     String id = userModel!.id!;
  //     print('id = $id');

  //     String urlImage = '${MyIpAddress().domain}/foodDelivery/editFoodWhereId.php?isAdd=true&id=$id&NameFood=$name&Image=$editImage&Price=$price&Detail=$detail';

  //     Response response = await Dio().get(url);

  //     if (response.toString() == 'true') {
  //       normalDialog(context, 'ไม่สามารถแก้ไขได้ กรุณาลองอีกครั้ง');
  //     } else {
  //       Navigator.pop(context);
  //     }
  //   });

  //   // await Dio().post(urlImage, data: formData).then(
  //   //   (value) async {
  //   //     editImage = 'FoodDelivery/Food/$nameFile';
  //   //     String urlEditFood =
  //   //         '${MyIpAddress().domain}/foodDelivery/editFoodWhereId.php?isAdd=true&id=$id&NameFood=$name&Image=$editImage&Price=$price&Detail=$detail';
  //   //     Response response = await Dio().get(urlEditFood);
  //   //     if (response.toString() == 'true') {
  //   //       normalDialog(context, 'เกิดข้อผิดพลาด กรุณาลองอีกครั้ง');
  //   //     } else {
  //   //       Navigator.pop(context);
  //   //     }
  //   //   },
  //   // );
  // }

  //method เลือกรูปภาพ จากกล้อง หรือ แกลลอรี่
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
          print('No Image Select');
        }
      });
    } catch (e) {}
  }

  //method แก้ไขรูปภาพ
  Widget editImageFood() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        IconButton(
          onPressed: () {
            chooseImage(ImageSource.camera);
          },
          icon: Icon(
            Icons.add_a_photo,
            size: 30.0,
          ),
        ),
        Container(
          width: 250.0,
          height: 250.0,
          child: _image == null
              ? Image.network('${MyIpAddress().domain}/$editImage')
              : Image.file(_image!),
        ),
        IconButton(
          onPressed: () {
            chooseImage(ImageSource.gallery);
          },
          icon: Icon(
            Icons.add_photo_alternate,
            size: 30.0,
          ),
        ),
      ]);

//method ฟอร์มแก้ไขชื่ออาหาร
  Widget editFoodName() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: 300,
            child: TextFormField(
              onChanged: (value) {
                name = value
                    .trim(); //รับค่าข้อมูลที่ป้อนมาใน Form เก็บไว้ใน ตัวแปร name เพื่อแก้ไข
              },
              initialValue: name, //แสดงชื่ออาหารเก่าเพื่อแก้ไข
              style: TextStyle(fontFamily: 'peach'),
              decoration: InputDecoration(
                labelText: 'ชื่อเมนูอาหาร',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

//method ฟอร์มราคาอาหาร
  Widget priceForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: 300,
            child: TextFormField(
              onChanged: (value) {
                price = value
                    .trim(); //รับค่าข้อมูลที่ป้อนมาใน Form เก็บไว้ใน ตัวแปร price เพื่อแก้ไข
              },
              keyboardType: TextInputType.number,
              initialValue: price, //แสดงราคาอาหาร เก่าเพื่อแก้ไข
              style: TextStyle(fontFamily: 'peach'),
              decoration: InputDecoration(
                labelText: 'ราคา',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

//method รายละเอียด
  Widget detailForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0),
            width: 300,
            child: TextFormField(
              onChanged: (value) {
                detail = value
                    .trim(); //รับค่าข้อมูลที่ป้อนมาใน Form เก็บไว้ใน ตัวแปร detail เพื่อแก้ไข
              },
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              maxLength: 250,
              initialValue: detail, //แสดงรายละเอียดเก่าเพื่อแก้ไข
              style: TextStyle(fontFamily: 'peach'),
              decoration: InputDecoration(
                labelText: 'รายละเอียด',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
