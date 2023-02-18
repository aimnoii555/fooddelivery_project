import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/auth/login.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/image.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class RegisterRestaurant extends StatefulWidget {
  String type;
  RegisterRestaurant({Key? key, required this.type}) : super(key: key);

  @override
  State<RegisterRestaurant> createState() => _RegisterRestaurantState();
}

class _RegisterRestaurantState extends State<RegisterRestaurant> {
  String? username,
      password,
      res_name,
      first_name,
      last_name,
      address,
      phone,
      type,
      image;
  double? lat, lng;
  File? file;
  bool _isObscure = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  Future<Null> getLocation() async {
    LocationData locationData = await location();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });
  }

  Future<LocationData> location() async {
    Location locationData = Location();
    return locationData.getLocation();
  }

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
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Image.asset(MyImage().restaurant),
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
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
                          height: 250.0,
                          width: 250.0,
                          child: file == null
                              ? Image.asset('images/image_default.png')
                              : Image.file(file!),
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
                                  file = File(object.path);
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
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
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
                              style: MyFont().lookpeachWhite18(),
                            ),
                            prefixIcon: const Icon(
                              Icons.account_box,
                              color: Colors.white,
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
                            label: Text(
                              'รหัสผ่าน',
                              style: MyFont().lookpeachWhite18(),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
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
                          res_name = value.trim();
                        },
                        decoration: InputDecoration(
                            label: Text(
                              'ชื่อร้าน',
                              style: MyFont().lookpeachWhite18(),
                            ),
                            prefixIcon: const Icon(
                              Icons.restaurant,
                              color: Colors.white,
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
                          first_name = value.trim();
                        },
                        decoration: InputDecoration(
                            label: Text(
                              'ชื่อ',
                              style: MyFont().lookpeachWhite18(),
                            ),
                            prefixIcon: const Icon(
                              Icons.badge,
                              color: Colors.white,
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
                          last_name = value.trim();
                        },
                        decoration: InputDecoration(
                            label: Text(
                              'นามสกุล',
                              style: MyFont().lookpeachWhite18(),
                            ),
                            prefixIcon: Icon(
                              Icons.account_box,
                              color: Colors.white,
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
                              'ที่อยู่  ',
                              style: MyFont().lookpeachWhite18(),
                            ),
                            prefixIcon: const Icon(
                              Icons.home,
                              color: Colors.white,
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
                          phone = value.trim();
                        },
                        decoration: InputDecoration(
                            label: Text(
                              'โทรศัพท์',
                              style: MyFont().lookpeachWhite18(),
                            ),
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.white,
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
                      color: Colors.grey,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 200.0,
                      child: lat == null
                          ? showProgress()
                          : GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(lat!, lng!),
                                zoom: 16.0,
                              ),
                              mapType: MapType.normal,
                              onMapCreated: (controller) => {},
                              markers: {
                                Marker(
                                  markerId: MarkerId('ตำแหน่งของคุณ'),
                                  position: LatLng(lat!, lng!),
                                  infoWindow: InfoWindow(
                                    title: 'ตำแหน่งของคุณ',
                                    snippet: 'ละติจูด: $lat, ลองติจูด: $lng',
                                  ),
                                ),
                              },
                            ),
                    ),
                    SizedBox(height: 15.0),
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
                          type = widget.type;
                          if (username == '') {
                            dialog(context, 'กรุณาป้อนชื่อผู้ใช้');
                          } else if (password == '') {
                            dialog(context, 'กรุณาป้อนรหัสผ่าน');
                          } else if (res_name == '') {
                            dialog(context, 'กรุณาป้อนชื่อร้าน');
                          } else if (first_name == '') {
                            dialog(context, 'กรุณาป้อนชื่อ');
                          } else if (last_name == '') {
                            dialog(context, 'กรุณาป้อนนามสกุล');
                          } else if (address == '') {
                            dialog(context, 'กรุณาป้อนที่อยู่');
                          } else if (phone == '') {
                            dialog(context, 'กรุณาป้อนเบอร์โทรศัพท์');
                          } else if (file == null) {
                            dialog(context, 'กรุณาเลือกรูปภาพของร้าน');
                          } else {
                            Random random = Random();
                            int i = random.nextInt(1000000);
                            String nameImage = 'Res$i.jpg';

                            String url =
                                '${MyHost().domain}/Project_Flutter/FoodDelivery/saveDataRes.php';

                            try {
                              Map<String, dynamic> map = Map();
                              map['file'] = await MultipartFile.fromFile(
                                  file!.path,
                                  filename: nameImage);
                              FormData formData = FormData.fromMap(map);
                              await Dio().post(url, data: formData).then(
                                    (value) => {
                                      image =
                                          '/Project_Flutter/FoodDelivery/Restaurant/$nameImage',
                                      print('image ============= $image'),
                                    },
                                  );
                            } catch (e) {}
                            checkDuplicate();
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
              )
            ],
          ),
        ));
  }

  checkDuplicate() async {
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getUserWhereUser.php?isAdd=true&Username=$username';

    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        saveDataRestaurant();
      } else {
        dialog(context, 'ชื่อผู้ใช้ ${username} ถูกใช้งานแล้ว');
      }
    } catch (e) {}
  }

  saveDataRestaurant() async {
    DateTime dateTime = DateTime.now();
    String regisDate = DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
    print('regisDate = $regisDate');

    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/addUser.php?isAdd=true&Type=$type&Username=$username&Password=$password&Restaurant_Name=$res_name&First_Name=$first_name&Last_Name=$last_name&Address=$address&Phone=$phone&Image=$image&Lat=$lat&Lng=$lng&Status=0&StatusOff=close&OrderAmountRes=0&DateTime=$regisDate';
    print('url = $url');
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
        dialog(context, 'สมัครเรียบร้อยแล้ว');
      } else {
        dialog(context, 'ไม่สามารถสมัครได้ กรุณาลองใหม่');
      }
    } catch (e) {}
  }
}
