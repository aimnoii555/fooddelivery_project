//page show information of chef

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/model/user_model.dart';
import 'package:fooddelivery_project/screens/add_info_chef.dart';
import 'package:fooddelivery_project/screens/edit_info_chef.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:fooddelivery_project/utility/my_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationChef extends StatefulWidget {
  const InformationChef({Key? key}) : super(key: key);

  @override
  _InformationChefState createState() => _InformationChefState();
}

class _InformationChefState extends State<InformationChef> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataUser();
  }

//get ค่าจาก ข้อมูลจาก database มาแสดง
  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id').toString();

    String url =
        '${MyIpAddress().domain}/foodDelivery/getUserWhereId.php?isAdd=true&id=$id';

    await Dio().get(url).then(
      (value) {
        // print('Value = $value');
        var result = json.decode(value.data); //convert json ให้เป็นภาษาไทย
        // print('result = $result');

        //เก็บค่า result ไว้ตัวแปร Model
        for (var map in result) {
          userModel = UserModel.fromJson(map);
          setState(() {
            print('nameChef = ${userModel!.nameChef}');
          });

          // if (userModel.nameChef.isEmpty) {}
          // if (userModel.nameChef!.isEmpty) {}
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        userModel == null
            ? MyStyle().showProgress()
            : userModel!.nameChef!.isEmpty
                ? showNoData()
                : showListInfoChef(),
        addEdit(context), //button add and edit
      ],
    );
  }

  Widget showListInfoChef() {
    double maxWidth = MediaQuery.of(context).size.width * 0.7;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: <Widget>[
          Text(
            'ชื่อร้านของคุณ: ${userModel!.nameChef}',
            style: TextStyle(
              fontFamily: 'peach',
              fontSize: 18.0,
            ),
          ),
          showImage(),
          Row(
            children: [
              Text(
                'ที่อยู่',
                style:
                    TextStyle(fontFamily: 'peach', fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Text(
              userModel!.address!,
              style: TextStyle(fontFamily: 'peach'),
            ),
          ),
          SizedBox(height: 15.0),
          showMap(),
        ],
      ),
    );
  }

  Container showImage() {
    return Container(
      width: 200.0,
      height: 200.0,
      child: Image.network('${MyIpAddress().domain}/${userModel!.urlPicture!}'),
    );
  }

  //marker
  Set<Marker> chefMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('ร้านของคุณ'),
        position: LatLng(
          double.parse(userModel!.lat!),
          double.parse(userModel!.lng!),
        ),
        infoWindow: InfoWindow(
          title: 'ตำแหน่งร้านของคุณ:  ${userModel!.nameChef!}',
          snippet: 'ละติจูด: ${userModel!.lat!}, ลองติจูด: ${userModel!.lng!}',
        ),
      ),
    ].toSet();
  }

//show map in หน้าแสดงข้อมูลของร้านค้า
  Widget showMap() {
    double lat = double.parse(userModel!
        .lat!); //ดึงค่าละติจูดจาก database มาแสดงตำแหน่งใน แผ่นที่ มาแปลงเป็น Double
    double lng = double.parse(userModel!
        .lng!); // ดึงค่าลองติจูดจาก database มาแสดงตำแหน่งใน แผ่นที่ มาแปลงเป็น Double

    LatLng latLng = LatLng(lat, lng);
    CameraPosition position = CameraPosition(target: latLng, zoom: 16.0);

    return Expanded(
      // padding: EdgeInsets.all(10.0),
      // height: 300.0,
      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: chefMarker(),
      ),
    );
  }

  Widget showNoData() => MyStyle().titleCenter('ไม่มีมีข้อมูล');

//button edit
  Row addEdit(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 25.0, bottom: 25.0),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () {
                  routeToAddInfo(context); //route ไปยังหน้าเพิ่มข้อมูล
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  //method เพิ่มข้อมูลของ ร้านค้า
  void routeToAddInfo(BuildContext context) {
    Widget widget =
        userModel!.nameChef!.isEmpty ? AddInfoChef() : EditInfoChef();
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => widget);
    Navigator.push(context, route).then((value) => readDataUser());
  }
}
