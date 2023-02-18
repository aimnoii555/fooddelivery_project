import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDataRider extends StatefulWidget {
  const EditDataRider({Key? key}) : super(key: key);

  @override
  State<EditDataRider> createState() => _EditDataRiderState();
}

class _EditDataRiderState extends State<EditDataRider> {
  String? firstName, lastName, address, phone, image, username, password;
  Rider? rider;
  File? file;
  bool _Obscure = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataRider();
  }

  Future<Null> getDataRider() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');

    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getUserWhereId.php?isAdd=true&id=$id';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);

      for (var map in result) {
        setState(() {
          rider = Rider.fromJson(map);
          firstName = rider!.firstName;
          lastName = rider!.lastName;
          address = rider!.address;
          phone = rider!.phone;
          username = rider!.username;
          password = rider!.password;
          print('nameRider = ${rider!.firstName}');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'แก้ไขข้อมูลส่วนตัว',
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
          child: rider == null
              ? showProgress()
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  var object =
                                      await ImagePicker.platform.pickImage(
                                    source: ImageSource.camera,
                                    maxHeight: 800.0,
                                    maxWidth: 800.0,
                                  );
                                  setState(() {
                                    file = File(object!.path);
                                  });
                                },
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                width: 250.0,
                                height: 250.0,
                                child: file == null
                                    ? Image.network(
                                        '${MyHost().domain}/${rider!.image}')
                                    : Image.file(file!),
                              ),
                              IconButton(
                                onPressed: () async {
                                  var object =
                                      await ImagePicker.platform.pickImage(
                                    source: ImageSource.gallery,
                                    maxHeight: 800.0,
                                    maxWidth: 800.0,
                                  );
                                  setState(() {
                                    file = File(object!.path);
                                  });
                                },
                                icon: const Icon(
                                  Icons.add_photo_alternate,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: 350.0,
                            child: TextFormField(
                              onChanged: (value) {
                                username = value.trim();
                              },
                              initialValue: username,
                              decoration: InputDecoration(
                                  label: const Text(
                                    'ชื่อผู้ใช้',
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  )),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Container(
                            width: 350.0,
                            child: TextFormField(
                              obscureText: _Obscure,
                              onChanged: (value) {
                                password = value.trim();
                              },
                              initialValue: password,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _Obscure = !_Obscure;
                                    });
                                  },
                                  icon: Icon(_Obscure
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                label: const Text(
                                  'รหัสผ่าน',
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            width: 350.0,
                            child: TextFormField(
                              onChanged: (value) {
                                firstName = value.trim();
                              },
                              initialValue: firstName,
                              decoration: InputDecoration(
                                label: const Text(
                                  'ชื่อ',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            width: 350.0,
                            child: TextFormField(
                              onChanged: (value) {
                                lastName = value.trim();
                              },
                              initialValue: lastName,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                labelText: 'นามสกุล',
                                labelStyle: MyFont().lookpeach(),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            width: 350.0,
                            child: TextFormField(
                              onChanged: (value) {
                                address = value.trim();
                              },
                              initialValue: address,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                labelText: 'ที่อยู่ ',
                                labelStyle: MyFont().lookpeach(),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            width: 350.0,
                            child: TextFormField(
                              onChanged: (value) {
                                phone = value.trim();
                              },
                              initialValue: phone,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                labelText: 'โทรศัพท์',
                                labelStyle: MyFont().lookpeach(),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          Container(
                            width: 350.0,
                            child: ElevatedButton(
                              child: Text(
                                'แก้ไข',
                                style: MyFont().lookpeachWhite18(),
                              ),
                              onPressed: () async {
                                Map<String, dynamic> map = Map();
                                Random random = Random();
                                int i = random.nextInt(1000000);
                                String nameFile = 'editRider$i.jpg';

                                map['file'] = await MultipartFile.fromFile(
                                  file!.path,
                                  filename: nameFile,
                                );

                                FormData formData = FormData.fromMap(map);

                                String urlEdit =
                                    '${MyHost().domain}/Project_Flutter/FoodDelivery/saveDataRider.php';

                                await Dio()
                                    .post(urlEdit, data: formData)
                                    .then((value) async {
                                  image =
                                      'Project_Flutter/FoodDelivery/Rider/$nameFile';
                                  String id = rider!.id!;
                                  String url =
                                      '${MyHost().domain}/Project_Flutter/FoodDelivery/editUserWhereId.php?isAdd=true&id=$id&Username=$username&Password=$password&First_Name=$firstName&Last_Name=$lastName&Address=$address&Phone=$phone&Image=$image';
                                  Response response = await Dio().get(url);
                                  if (response.toString() != 'true') {
                                    Navigator.pop(context);
                                    dialog(context, 'แก้ไขเรียบร้อย');
                                  } else {
                                    dialog(context, 'ไม่สามารถแก้ไขได้');
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ));
  }
}
