import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/restaurant/edit_data_restaurant.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantData extends StatefulWidget {
  const RestaurantData({Key? key}) : super(key: key);

  @override
  State<RestaurantData> createState() => _RestaurantDataState();
}

class _RestaurantDataState extends State<RestaurantData> {
  Restaurant? restaurant;
  bool _Obscure = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        restaurant == null
            ? showProgress()
            : Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 15, top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'ชื่อร้าน ',
                              style: TextStyle(
                                  fontFamily: 'lookpeach',
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${restaurant!.restaurantName}',
                              style: MyFont().lookpeachWhite18(),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 250.0,
                            height: 250.0,
                            child: Image.network(
                                '${MyHost().domain}/${restaurant!.image}'),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.0, left: 15.0),
                        child: Row(
                          children: [
                            Text(
                              'ชื่อผู้ใช้ ',
                              style: MyFont().lookpeachWhite18(),
                            ),
                            Text(
                              '${restaurant!.username}',
                              style: MyFont().lookpeachWhite(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15.0),
                        child: Row(
                          children: [
                            Text(
                              'รหัสผ่าน ',
                              style: MyFont().lookpeachWhite18(),
                            ),
                            Text(
                              _Obscure ? ' ✱✱✱✱✱✱' : '${restaurant!.password}',
                              style: MyFont().lookpeachWhite(),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _Obscure = !_Obscure;
                                });
                              },
                              icon: Icon(
                                _Obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text(
                              'ชื่อ ',
                              style: MyFont().lookpeachWhite18(),
                            ),
                            Text(
                              '${restaurant!.firstName}',
                              style: MyFont().lookpeachWhite(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text(
                              'นามสกุล ',
                              style: MyFont().lookpeachWhite18(),
                            ),
                            Text(
                              '${restaurant!.lastName}',
                              style: MyFont().lookpeachWhite(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15.0),
                        child: Row(
                          children: [
                            const Text(
                              'ที่อยู่: ',
                              style: TextStyle(
                                  fontFamily: 'lookpeach',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16.0),
                            ),
                            Text(
                              '${restaurant!.address}',
                              style: MyFont().lookpeachWhite(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8.0, left: 15.0),
                        child: Row(
                          children: [
                            const Text(
                              'โทรศัพท์: ',
                              style: TextStyle(
                                  fontFamily: 'lookpeach',
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${restaurant!.phone}',
                              style: MyFont().lookpeachWhite(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15.0),
                        color: Colors.grey,
                        width: 360.0,
                        height: 250.0,
                        child: restaurant!.lat == null
                            ? showProgress()
                            : GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    double.parse(restaurant!.lat!),
                                    double.parse(restaurant!.lng!),
                                  ),
                                  zoom: 16.0,
                                ),
                                mapType: MapType.normal,
                                onMapCreated: (controller) {},
                                markers: {
                                  Marker(
                                    markerId: MarkerId('ร้านของคุณ'),
                                    position: LatLng(
                                      double.parse(restaurant!.lat!),
                                      double.parse(restaurant!.lng!),
                                    ),
                                    infoWindow: InfoWindow(
                                      title:
                                          'ร้านของคุณ ${restaurant!.firstName}',
                                      snippet:
                                          'ละติจูด: ${restaurant!.lat}, ลองติจูด: ${restaurant!.lng}',
                                    ),
                                  ),
                                },
                              ),
                      ),
                      SizedBox(height: 20),
                      if (restaurant!.statusOff == 'open')
                        Container(
                          width: 300,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              String? idRes = preferences.getString('id');
                              String url =
                                  '${MyHost().domain}/Project_Flutter/FoodDelivery/updateResStatusOff.php?isAdd=true&id=$idRes&StatusOff=close';

                              await Dio().get(url).then((value) {
                                dataRestaurant();
                                dialog(context, 'คุณปิดร้านแล้ว');
                              });
                            },
                            child: Text('ปิดร้าน'),
                          ),
                        ),
                      if (restaurant!.statusOff == 'close')
                        Container(
                          width: 300,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              String? idRes = preferences.getString('id');
                              String url =
                                  '${MyHost().domain}/Project_Flutter/FoodDelivery/updateResStatusOff.php?isAdd=true&id=$idRes&StatusOff=open';

                              await Dio().get(url).then((value) {
                                dataRestaurant();
                                dialog(context, 'คุณเปิดร้านแล้ว');
                              });
                            },
                            child: Text('เปิดร้าน'),
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.only(right: 18, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton(
                                  onPressed: () {
                                    MaterialPageRoute route = MaterialPageRoute(
                                        builder: ((context) =>
                                            EditDataRestaurant()));
                                    Navigator.push(context, route)
                                        .then((value) => dataRestaurant());
                                  },
                                  child: Icon(Icons.edit),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  dataRestaurant() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');

    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getUserWhereId.php?isAdd=true&id=$id';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);

      for (var map in result) {
        restaurant = Restaurant.fromJson(map);
        setState(() {
          print('nameRes = ${restaurant!.firstName}');
        });
      }
    });
  }
}
