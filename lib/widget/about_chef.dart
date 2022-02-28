import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fooddelivery_project/model/user_model.dart';
import 'package:fooddelivery_project/utility/my_api.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:fooddelivery_project/utility/my_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';

class AboutChef extends StatefulWidget {
  final UserModel userModel;
  const AboutChef({Key? key, required this.userModel}) : super(key: key);

  @override
  _AboutChefState createState() => _AboutChefState();
}

class _AboutChefState extends State<AboutChef> {
  UserModel? userModel;
  double? lat1, lng1, lat2, lng2, distance;
  String distanceString = '';
  int? transport = 0;
  CameraPosition? position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;

    findLat1Lng1();
  }

  Future<Null> findLat1Lng1() async {
    LocationData? locationData = await findLocationData();
    setState(() {
      lat1 = locationData!.latitude!; //ตำแหน่งของ User
      lng1 = locationData.longitude!;
      lat2 = double.parse(userModel!.lat!); // ตำแหน่งของ ร้านค้า
      lng2 = double.parse(userModel!.lng!);
      print('lat2 = $lat2, lng2 = $lng2');
      distance = MyAPI().calculateDistance(lat1!, lng1!, lat2!, lng2!);
      var myFormat = NumberFormat('#0.0#', 'en_US');
      distanceString = myFormat.format(distance);

      transport = MyAPI().calculateTransport(distance!);
      print('transport = $transport');
      print('distance = $distance');
    });
  }

  Future<LocationData?> findLocationData() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          image(),
          address(),
          phone(),
          showDistance(),
          showTransport(),
          lat1 == 0 ? MyStyle().showProgress() : showMap(),
        ],
      ),
    );
  }

  Marker userMarker() {
    return Marker(
      markerId: MarkerId('userMarker'),
      position: LatLng(lat1!, lng1!),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(title: 'ตำแหน่งของคุณ'),
    );
  }

  Marker chefMarker() {
    return Marker(
      markerId: MarkerId('userMarker'),
      position: LatLng(lat2!, lng2!),
      icon: BitmapDescriptor.defaultMarkerWithHue(150.0),
      infoWindow: InfoWindow(title: 'ร้านคุณ: ${userModel!.nameChef!}'),
    );
  }

  Set<Marker> mySet() {
    return <Marker>[
      userMarker(),
      chefMarker(),
    ].toSet();
  }

  Container showMap() {
    if (lat1 != null) {
      LatLng latLng1 = LatLng(lat1!, lng2!); //ละติจูดของ User
      position = CameraPosition(target: latLng1, zoom: 16.0);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 300.0,
      width: 350.0,
      child: lat1 == null
          ? MyStyle().showProgress()
          : GoogleMap(
              initialCameraPosition: position!,
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: mySet(),
            ),
    );
  }

  ListTile showTransport() {
    return ListTile(
      leading: Icon(Icons.price_change_outlined),
      title: Text(transport == 0 ? '' : '$transport บาท'),
    );
  }

  Row image() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              image: DecorationImage(
                image: NetworkImage(
                    '${MyIpAddress().domain}/${userModel!.urlPicture!}'),
                fit: BoxFit.cover,
              ),
            ),
            margin: EdgeInsets.all(16.0),
            width: 150.0,
            height: 150.0,
          ),
        ),
      ],
    );
  }

  ListTile showDistance() {
    return ListTile(
      leading: Icon(Icons.directions_bike),
      title: Text(distanceString == null
          ? MyStyle().showProgress().toString()
          : '$distanceString กิโลเมตร'),
    );
  }

  ListTile phone() {
    return ListTile(
      leading: Icon(Icons.phone),
      title: Text(userModel!.phone!),
    );
  }

  ListTile address() {
    return ListTile(
      leading: Icon(Icons.home),
      title: Text(userModel!.address!),
    );
  }
}
