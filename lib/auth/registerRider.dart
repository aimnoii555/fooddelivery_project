import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/auth/login.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RegisterRider extends StatefulWidget {
  String type;
  RegisterRider({Key? key, required this.type}) : super(key: key);

  @override
  State<RegisterRider> createState() => _RegisterRiderState();
}

class _RegisterRiderState extends State<RegisterRider> {
  String? username,
      password,
      firstName,
      lastName,
      address,
      type,
      bankNumber,
      bankName,
      licensePlate,
      phone,
      image;
  bool _isObscure = true;
  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('พนักงานส่งอาหาร'),
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
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  children: [
                    Container(
                      width: 150.0,
                      height: 150.0,
                      child: Image.asset(MyImage().rider),
                    ),
                    SizedBox(height: 15.0),
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
                                  file = File(object.path);
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
                          child: file == null
                              ? Image.asset('images/image_default.png')
                              : Image.file(file!),
                        ),
                        IconButton(
                          onPressed: () async {
                            var object = await ImagePicker.platform.pickImage(
                              source: ImageSource.gallery,
                              maxHeight: 800.0,
                              maxWidth: 800.0,
                            );
                            setState(() {
                              if (object != null) {
                                file = File(object.path);
                              } else {
                                print('No Image Selected');
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.add_photo_alternate,
                            size: 36.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        style: MyFont().colorWhite(),
                        onChanged: (value) {
                          username = value.trim();
                        },
                        decoration: InputDecoration(
                            label: Text(
                              'ชื่อผู้ใช้',
                              style: MyFont().lookpeachWhite(),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.white),
                            )),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        style: MyFont().colorWhite(),
                        obscureText: _isObscure,
                        onChanged: (value) {
                          password = value.trim();
                        },
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                            label: Text(
                              'รหัสผ่าน',
                              style: MyFont().lookpeachWhite(),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.white),
                            )),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        style: MyFont().colorWhite(),
                        onChanged: (value) {
                          firstName = value.trim();
                        },
                        decoration: InputDecoration(
                            label: Text(
                              'ชื่อ',
                              style: MyFont().lookpeachWhite(),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.white),
                            )),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        style: MyFont().colorWhite(),
                        onChanged: (value) {
                          lastName = value.trim();
                        },
                        decoration: InputDecoration(
                            label: Text(
                              'นามสกุล',
                              style: MyFont().lookpeachWhite(),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.white),
                            )),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: MyFont().colorWhite(),
                        onChanged: (value) {
                          phone = value.trim();
                        },
                        decoration: InputDecoration(
                            label: Text(
                              'โทรศัพท์',
                              style: MyFont().lookpeachWhite(),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.white),
                            )),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        style: MyFont().colorWhite(),
                        onChanged: (value) {
                          address = value.trim();
                        },
                        decoration: InputDecoration(
                            label: Text(
                              'ที่อยู่ ',
                              style: MyFont().lookpeachWhite(),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.white),
                            )),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        maxLines: 2,
                        style: MyFont().colorWhite(),
                        onChanged: (value) {
                          licensePlate = value.trim();
                        },
                        decoration: InputDecoration(
                            hintText: 'ป้ายทะเบียนรถตัวอย่าง กกก อุดรธานี 999',
                            hintStyle: MyFont().lookpeachWhite(),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.white),
                            )),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: MyFont().colorWhite(),
                        onChanged: (value) {
                          bankNumber = value.trim();
                        },
                        decoration: InputDecoration(
                            label: Text(
                              'หมายเลขบัญชีธนาคาร',
                              style: MyFont().lookpeachWhite(),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.white),
                            )),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        style: MyFont().colorWhite(),
                        onChanged: (value) {
                          bankName = value.trim();
                        },
                        decoration: InputDecoration(
                          label: Text(
                            'ชื่อธนาคาร',
                            style: MyFont().lookpeachWhite(),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
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
                        onPressed: () async {
                          type = widget.type;
                          if (username == null) {
                            dialog(context, 'กรุณาป้อนชื่อผู้ใช้');
                          } else if (password == null) {
                            dialog(context, 'กรุณาป้อนรหัสผ่าน');
                          } else if (firstName == null) {
                            dialog(context, 'กรุณาป้อนชื่อ');
                          } else if (lastName == null) {
                            dialog(context, 'กรุณาป้อนนามสกุล');
                          } else if (address == null) {
                            dialog(context, 'กรุณาป้อนที่อยู่');
                          } else if (bankNumber == null) {
                            dialog(context, 'กรุณาป้อนหมายบัญชีธนาคาร');
                          } else if (bankName == null) {
                            dialog(context, 'กรุณาป้อนชื่อธนาคาร');
                          } else if (licensePlate == null) {
                            dialog(context, 'กรุณาป้อนป้ายทะเบียนรถ');
                          } else if (file == null) {
                            dialog(context, 'กรุณาเลือกรูปภาพ');
                          } else {
                            Random random = Random();
                            int i = random.nextInt(1000000);
                            String nameImage = 'Rider$i.jpg';

                            String url =
                                '${MyHost().domain}/Project_Flutter/FoodDelivery/saveDataRider.php';

                            try {
                              Map<String, dynamic> map = Map();
                              map['file'] = await MultipartFile.fromFile(
                                  file!.path,
                                  filename: nameImage);
                              FormData formData = FormData.fromMap(map);
                              await Dio()
                                  .post(url, data: formData)
                                  .then((value) {
                                image =
                                    '/Project_Flutter/FoodDelivery/Rider/$nameImage';
                              });
                            } catch (e) {}

                            checkDuplicate();
                          }
                        },
                        child: const Center(
                          child: Text(
                            'ตกลง',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'lookpeachWhite',
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
        ));
  }

  checkDuplicate() async {
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getUserWhereUser.php?isAdd=true&Username=$username';

    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        saveDataRider();
      } else {
        dialog(context, 'ชื่อผู้ใช้ $username ถูกใช้งานแล้ว');
      }
    } catch (e) {}
  }

  saveDataRider() async {
    DateTime dateTime = DateTime.now();
    String regisDate = DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
    print('regisDate = $regisDate');
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/addUser.php?isAdd=true&Type=$type&Username=$username&Password=$password&First_Name=$firstName&Last_Name=$lastName&Address=$address&Phone=$phone&Bank_Number=$bankNumber&Bank_Name=$bankName&LicensePlate=$licensePlate&Image=$image&Status=0&DateTime=$regisDate';

    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
        dialog(context, 'สมัครเรียบร้อยแล้ว');
      } else {
        dialog(context, 'ไม่สามารถสมัครได้ กรุณาลองใหม่');
      }
    } catch (e) {}
  }
}
