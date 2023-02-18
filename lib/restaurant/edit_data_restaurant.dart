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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDataRestaurant extends StatefulWidget {
  const EditDataRestaurant({Key? key}) : super(key: key);

  @override
  State<EditDataRestaurant> createState() => _EditDataRestaurantState();
}

class _EditDataRestaurantState extends State<EditDataRestaurant> {
  String? resName, address, phone, image, username, password;
  var lat, lng;
  Location location = Location();
  File? file;
  Restaurant? restaurant;
  bool _Obscure = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    location.onLocationChanged.listen((event) {
      lat = event.latitude;
      lng = event.longitude;
      // print('lat = $lat, lng = $lng');
    });
    getOldData();
  }

  Future<Null> getOldData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idRes = preferences.getString('id').toString();
    print('idRes = $idRes');

    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getUserWhereId.php?isAdd=true&id=$idRes';

    Response response = await Dio().get(url);

    var result = json.decode(response.data);

    for (var map in result) {
      // print('map = $map');
      setState(() {
        restaurant = Restaurant.fromJson(map);
        resName = restaurant!.restaurantName;
        address = restaurant!.address;
        phone = restaurant!.phone;
        username = restaurant!.username;
        password = restaurant!.password;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: restaurant == null
              ? Text('แก้ไขข้อมูลร้าน')
              : Text('แก้ไขข้อมูลร้าน $resName'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            getOldData();
          },
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    colors: [
                  Colors.blue,
                  Color.fromARGB(255, 223, 158, 153),
                ])),
            child: restaurant == null
                ? showProgress()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  try {
                                    var object =
                                        await ImagePicker.platform.pickImage(
                                      source: ImageSource.camera,
                                      maxHeight: 800.0,
                                      maxWidth: 800.0,
                                    );
                                    setState(() {
                                      file = File(object!.path);
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
                                    ? Image.network(
                                        '${MyHost().domain}/${restaurant!.image}')
                                    : Image.file(file!),
                              ),
                              IconButton(
                                onPressed: () async {
                                  try {
                                    var object =
                                        await ImagePicker.platform.pickImage(
                                      source: ImageSource.gallery,
                                      maxHeight: 800.0,
                                      maxWidth: 8000.0,
                                    );

                                    setState(() {
                                      file = File(object!.path);
                                    });
                                  } catch (e) {}
                                },
                                icon: const Icon(
                                  Icons.add_photo_alternate,
                                  size: 36.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 350.0,
                          child: TextFormField(
                            onChanged: (value) {
                              username = value.trim();
                            },
                            style: const TextStyle(color: Colors.white),
                            initialValue: username,
                            decoration: InputDecoration(
                                focusColor: Colors.white,
                                label: Text(
                                  'ชื่อผู้ใช้',
                                  style: MyFont().lookpeachWhite(),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white))),
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
                            style: MyFont().lookpeachWhite(),
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
                                focusColor: Colors.white,
                                label: Text(
                                  'รหัสผ่าน',
                                  style: MyFont().lookpeachWhite(),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: 350.0,
                          child: TextFormField(
                            style: MyFont().colorWhite(),
                            cursorColor: Colors.white,
                            onChanged: (value) {
                              resName = value.trim();
                            },
                            initialValue: resName,
                            decoration: InputDecoration(
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              labelText: 'ชื่อร้าน',
                              labelStyle: MyFont().lookpeachWhite(),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          width: 350.0,
                          child: TextFormField(
                            style: MyFont().colorWhite(),
                            cursorColor: Colors.white,
                            maxLines: 3,
                            onChanged: (value) {
                              address = value.trim();
                            },
                            initialValue: address,
                            decoration: InputDecoration(
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              labelText: 'ที่อยู่ ',
                              labelStyle: MyFont().lookpeachWhite(),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          width: 350.0,
                          child: TextFormField(
                            style: MyFont().colorWhite(),
                            cursorColor: Colors.white,
                            onChanged: (value) {
                              phone = value.trim();
                            },
                            initialValue: phone,
                            decoration: InputDecoration(
                              focusColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              labelText: 'โทรศัพท์',
                              labelStyle: MyFont().lookpeachWhite(),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          color: Colors.grey,
                          width: 360,
                          height: 250.0,
                          child: lat == null
                              ? showProgress()
                              : GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(lat, lng), zoom: 16.0),
                                  mapType: MapType.normal,
                                  onMapCreated: (context) {},
                                  markers: {
                                    Marker(
                                      markerId: MarkerId('Marker'),
                                      position: LatLng(lat, lng),
                                      infoWindow: InfoWindow(
                                        title:
                                            'ตำแหน่งของคุณ ${restaurant!.restaurantName}',
                                        snippet:
                                            'ละติจูด: $lat, ลองติจูด: $lng',
                                      ),
                                    ),
                                  },
                                ),
                        ),
                        SizedBox(height: 10),
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
                              Map<String, dynamic> map = Map();
                              Random random = Random();
                              int i = random.nextInt(1000000);
                              String nameFile = 'editRes$i.jpg';

                              // if (file == null) {

                              // }

                              map['file'] = await MultipartFile.fromFile(
                                  file!.path,
                                  filename: nameFile);

                              FormData formData = FormData.fromMap(map);

                              String url =
                                  '${MyHost().domain}/Project_Flutter/FoodDelivery/saveDataRes.php';
                              print('URL === $url');
                              await Dio()
                                  .post(url, data: formData)
                                  .then((value) async {
                                image =
                                    '/Project_Flutter/FoodDelivery/Restaurant/$nameFile';

                                String id = restaurant!.id!;
                                String url =
                                    '${MyHost().domain}/Project_Flutter/FoodDelivery/editUserWhereId.php?isAdd=true&id=$id&Username=$username&Password=$password&Restaurant_Name=$resName&Address=$address&Phone=$phone&Lat=$lat&Lng=$lng&Image=$image';

                                Response response = await Dio().get(url);

                                if (response.toString() != 'true') {
                                  Navigator.pop(context);
                                  // ignore: use_build_context_synchronously
                                  dialog(
                                      context, 'แก้ไขข้อมูลร้านเรียบร้อยแล้ว');
                                } else {
                                  dialog(context, 'ไม่สามารถแก้ไขได้');
                                }
                              });
                            },
                            child: const Center(
                              child: Text(
                                'แก้ไข',
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
        ));
  }
}
