import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/model/user_model.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:fooddelivery_project/utility/my_style.dart';
import 'package:fooddelivery_project/utility/normal_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfoChef extends StatefulWidget {
  const EditInfoChef({Key? key}) : super(key: key);

  @override
  _EditInfoChefState createState() => _EditInfoChefState();
}

class _EditInfoChefState extends State<EditInfoChef> {
  UserModel? userModel;
  String nameChef = '', address = '', phone = '', urlPicture = '';
  Location location = Location();
  var lat, lng;
  File? _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDataOld();
    location.onLocationChanged.listen(
      (event) {
        lat = event.latitude;
        lng = event.longitude;
        // print('lat = $lat, lng = $lng');
      },
    );
  }

//method getAllDataOld ดึงข้อมูลเก่ามาแสดงเพื่อแก้ไข
  Future<Null> getAllDataOld() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idChef = preferences.getString('id').toString();
    print('idchef == $idChef');

    String url =
        '${MyIpAddress().domain}/foodDelivery/getUserWhereId.php?isAdd=true&id=$idChef';

    Response response = await Dio().get(url);
    // print('res = $response');
    var result = json.decode(response.data);
    // print(result);

    for (var map in result) {
      // print(map);
      setState(() {
        userModel = UserModel.fromJson(map);
        nameChef = userModel!.nameChef!;
        address = userModel!.address!;
        phone = userModel!.phone!;
        urlPicture = userModel!.urlPicture!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null ? MyStyle().showProgress() : showDetailChef(),
      appBar: AppBar(
        title: Text(
          'แก้ไขรายละเอียดร้าน',
          style: TextStyle(fontFamily: 'peach'),
        ),
      ),
    );
  }

  Widget showDetailChef() {
    return SingleChildScrollView(
      child: Column(
        children: [
          editImage(),
          nameChefForm(), //เรียกใช้ method nameChefForm
          addressChefForm(),
          phoneChefForm(),
          lat == null ? MyStyle().showProgress() : editMap(),
          SizedBox(height: 15.0),
          editButtonChef(),
        ],
      ),
    );
  }

  Widget editButtonChef() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton.icon(
        color: Colors.yellowAccent,
        onPressed: () {
          confirmDialogEdit();
        },
        icon: Icon(Icons.edit),
        label: Text(
          'บันทึก',
          style: TextStyle(fontFamily: 'peach'),
        ),
      ),
    );
  }

  Future<Null> confirmDialogEdit() async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text(
                'ยืนยันการแก้ไขข้อมูลร้านค้า',
                style: TextStyle(fontFamily: 'peach'),
              ),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      OutlineButton(
                        borderSide: BorderSide(color: Colors.green),
                        onPressed: () {
                          Navigator.pop(context);
                          editButtonOk();
                        },
                        child: Text(
                          'ตกลง',
                          style: TextStyle(fontFamily: 'peach'),
                        ),
                      ),
                      SizedBox(width: 5.0),
                      OutlineButton(
                        borderSide: BorderSide(color: Colors.red),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'ยกเลิก',
                          style: TextStyle(fontFamily: 'peach'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
  }

//Method ปุ่มบันทึกเมื่อแก้ไขเสร็จ
  Future<Null> editButtonOk() async {
    Map<String, dynamic> map = Map();
    Random randomName = Random();
    int i = randomName.nextInt(100000);
    String nameFile = 'editChef$i.jpg';

    map['file'] =
        await MultipartFile.fromFile(_image!.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);
    print('formData = $formData');

    String urlUpload = '${MyIpAddress().domain}/FoodDelivery/saveDataChef.php';
    await Dio().post(urlUpload, data: formData).then((value) async {
      //เปลี่ยนชื่อรูปภาพเมื่อ ถ้าอัพโหลดสำเร็จ
      urlPicture = 'FoodDelivery/Chef/$nameFile';

      String id = userModel!.id!;
      print('id = $id');

      String url =
          '${MyIpAddress().domain}/foodDelivery/editUserWhereId.php?isAdd=true&id=$id&NameChef=$nameChef&Phone=$phone&Address=$address&UrlPicture=$urlPicture&Lat=$lat&Lng=$lng';

      Response response = await Dio().get(url);

      if (response.toString() == 'true') {
        normalDialog(context, 'ไม่สามารถแก้ไขได้ กรุณาลองอีกครั้ง');
      } else {
        Navigator.pop(context);
      }
    });
  }

//method แก้ไข Marker บน Google Map
  Set<Marker> editMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myMarker'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: 'ตำแหน่งร้านของคุณ: ${userModel!.nameChef!}',
            snippet: 'ละติจูด: $lat, ลองติจูด: $lng'),
      ),
    ].toSet();
  }

  Widget editMap() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16.0,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      margin: EdgeInsets.only(top: 16.0),
      height: 250.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: editMarker(),
      ),
    );
  }

  Widget editImage() => Container(
        margin: EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                chooseEditImage(ImageSource.camera);
              },
              icon: Icon(Icons.add_a_photo),
            ),
            Container(
              width: 250.0,
              height: 250.0,
              child: _image == null
                  ? Image.network('${MyIpAddress().domain}$urlPicture')
                  : Image.file(_image!),
            ),
            IconButton(
              onPressed: () {
                chooseEditImage(ImageSource.gallery);
              },
              icon: Icon(Icons.add_photo_alternate),
            ),
          ],
        ),
      );

  Future<Null> chooseEditImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.platform.pickImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );

      setState(() {
        if (object != null) {
          _image = File(object.path);
          print('Image ======== $_image');
        } else {
          print('No Image Selected');
        }
      });
    } catch (e) {}
  }

  //method nameChefForm form แก้ไขชื่อร้าน
  Widget nameChefForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16.0),
          width: 250.0,
          child: TextFormField(
            onChanged: (value) {
              nameChef = value;
            },
            initialValue:
                nameChef, //แสดงข้อมูลเก่าใน TextFormField เพื่อแก้ไขข้อมูล
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ชื่อร้าน',
                labelStyle: TextStyle(fontFamily: 'peach')),
          ),
        ),
      ],
    );
  }

  Widget addressChefForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16.0),
          width: 250.0,
          child: TextFormField(
            onChanged: (value) {
              address = value;
            },
            initialValue:
                address, //แสดงข้อมูลเก่าใน TextFormField เพื่อแก้ไขข้อมูล
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ที่อยู่',
                labelStyle: TextStyle(fontFamily: 'peach')),
          ),
        ),
      ],
    );
  }

  Widget phoneChefForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16.0),
          width: 250.0,
          child: TextFormField(
            onChanged: (value) {
              phone = value;
            },
            initialValue:
                phone, //แสดงข้อมูลเก่าใน TextFormField เพื่อแก้ไขข้อมูล
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'เบอร์โทรศัพท์',
                labelStyle: TextStyle(fontFamily: 'peach')),
          ),
        ),
      ],
    );
  }
}
