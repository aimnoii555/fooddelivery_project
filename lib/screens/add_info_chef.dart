//page เพิ่มข้อมูลร้านค้า

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:fooddelivery_project/utility/my_style.dart';
import 'package:fooddelivery_project/utility/normal_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddInfoChef extends StatefulWidget {
  const AddInfoChef({Key? key}) : super(key: key);

  @override
  _AddInfoChefState createState() => _AddInfoChefState();
}

class _AddInfoChefState extends State<AddInfoChef> {
  //Field keep lat lng
  var lat, lng;
  File? _image;
  //Field เก็บข้อมูล ชื่อร้าน ที่อยู่ เบอร์
  String nameChef = '', address = '', phone = '', urlImage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLng();
  }

  //method ละติจูด ลองจิจูด
  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude!;
      lng = locationData.longitude!;
    });
    print('lat = $lat, lng = $lng');
  }

  //method location
  Future<LocationData> findLocationData() async {
    Location location = Location();
    return location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'เพิ่มข้อมูลร้านค้า',
          style: TextStyle(
            fontFamily: 'peach',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            groupImage(),
            SizedBox(height: 15.0),
            nameForm(), //method nameForm กรอกชื่อ
            SizedBox(height: 15.0),
            addressForm(),
            SizedBox(height: 15.0),
            PhoneForm(),
            SizedBox(height: 20.0),
            lat == null ? MyStyle().showProgress() : showMap(),
            SizedBox(height: 20.0),
            saveButton(),
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        color: Colors.blue,
        onPressed: () {
          //when data empty แจ้งเตือน
          if (nameChef == '' || nameChef.isEmpty) {
            normalDialog(context, 'กรุณาป้อนชื่อร้านค้า');
          } else if (address == '' || address.isEmpty) {
            normalDialog(context, 'กรุณาป้อนที่อยู่');
          } else if (phone == '' || phone.isEmpty) {
            normalDialog(context, 'กรุณาป้อนเบอร์โทรศัพท์');
          } else if (_image == null) {
            normalDialog(context, 'กรุณาเลือกรูปภาพ');
          } else {
            uploadImage();
          }
        },
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
        label: Text(
          'บันทึก',
          style: TextStyle(fontFamily: 'peach', color: Colors.white),
        ),
      ),
    );
  }

//upload ภาพขึ้น Server
  Future<Null> uploadImage() async {
    Random random = Random();
    int i = random.nextInt(
        100000); //random name จำนวน 6 หลัก ไม่ให้ซ้ำกันเวลาอัพโหลดขึ้น Server
    String nameImage = 'chef$i.jpg';

    String url = '${MyIpAddress().domain}/FoodDelivery/saveDataChef.php';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(_image!.path, filename: nameImage);
      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) => {
            print('Response = $value'),
            urlImage = '/FoodDelivery/Chef/$nameImage', //get image name
            print('urlImage = $urlImage'),
            editUserChef()
          }); //get image ที่อยู่โฟล์เดอร์
    } catch (e) {}
  }

//method แก้ไข User
  Future<Null> editUserChef() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences
        .getString('id')
        .toString(); // รับ id มากจากตอนที่เข้าสู่ระบบ signin.dart

    String url =
        '${MyIpAddress().domain}/FoodDelivery/editUserWhereId.php?isAdd=true&id=$id&NameChef=$nameChef&Address=$address&Phone=$phone&UrlPicture=$urlImage&Lat=$lat&Lng=$lng';

    await Dio().get(url).then(
      (value) {
        if (value.toString() == 'true') {
          Navigator.pop(
              context); //เมือจัดการสมาชิกเสร็จกลับไปหน้าหลักของ Main Chef

        } else {
          Navigator.pop(
              context); //เมือจัดการสมาชิกเสร็จกลับไปหน้าหลักของ Main Chef
          normalDialog(context, 'เพิ่มเรียบร้อย');
        }
      },
    );
  }

  //method marker
  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('ตำแหน่งของคุณ'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: 'ร้านค้าของคุณ',
          snippet: 'ละติจูด: $lat, ลองติจูด: $lng',
        ),
      ),
    ].toSet();
  }

  //method show google map API
  Container showMap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      height: 300.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) => {},
        markers: myMarker(),
      ),
    );
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 36.0,
          ),
        ),
        Container(
          height: 250.0,
          width: 250.0,
          child: _image == null
              ? Image.asset('images/imageDefult.png')
              : Image.file(_image!),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36.0,
          ),
        ),
      ],
    );
  }

  //method input image from camera and gallery
  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.platform.pickImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        if (object != null) {
          _image = File(object.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {}
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => nameChef = value.trim(),
              decoration: InputDecoration(
                labelText: 'ชื่อร้านค้า',
                labelStyle: TextStyle(fontFamily: 'peach'),
                prefixIcon: Icon(
                  Icons.account_box,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              //เมื่อกรอกข้อมูลบน TextField จะไปเก็บใน value
              onChanged: (value) {
                address = value.trim();
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'ที่อยู่',
                labelStyle: TextStyle(fontFamily: 'peach'),
                prefixIcon: Icon(
                  Icons.house,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget PhoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              //เมื่อกรอกข้อมูลบน TextField จะไปเก็บใน value
              onChanged: (value) {
                phone = value.trim();
              },
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'โทรศัพท์',
                labelStyle: TextStyle(fontFamily: 'peach'),
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
