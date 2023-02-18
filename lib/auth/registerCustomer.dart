import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/auth/login.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/image.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RegisterCustomer extends StatefulWidget {
  String? type;
  RegisterCustomer({Key? key, required this.type}) : super(key: key);

  @override
  State<RegisterCustomer> createState() => _RegisterCustomerState();
}

class _RegisterCustomerState extends State<RegisterCustomer> {
  String? username, password, last_name, first_name, address, phone, type;
  double? lat, lng;
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
    print('lat = $lat, lng = $lng');
  }

  Future<LocationData> location() async {
    Location location = Location();
    return location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ผู้ส่งอาหาร'),
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
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Image.asset(MyImage().customer),
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
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 250, 249, 249))),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 241, 240, 240)),
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
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
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
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 240, 237, 237))),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255)),
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
                            prefixIcon: Icon(Icons.badge, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 242, 240, 240))),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 247, 245, 245)),
                            )),
                      ),
                    ),
                    const SizedBox(height: 15.0),
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
                            prefixIcon: const Icon(
                              Icons.account_box,
                              color: Colors.white,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 246, 245, 245))),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 243, 242, 242)),
                            )),
                      ),
                    ),
                    const SizedBox(height: 15.0),
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
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 245, 243, 243))),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 248, 246, 246)),
                            )),
                      ),
                    ),
                    const SizedBox(height: 15.0),
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
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 251, 249, 249))),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 248, 246, 246)),
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
                                    markerId: const MarkerId('ตำแหน่งของคุณ'),
                                    position: LatLng(lat!, lng!),
                                    infoWindow: InfoWindow(
                                      title: 'ตำแหน่งของคุณ',
                                      snippet: 'ละติจูด: $lat, ลองติจูด: $lng',
                                    ),
                                  ),
                                }),
                    ),
                    const SizedBox(height: 15.0),
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
                        onPressed: () {
                          type = widget.type;
                          if (username == null) {
                            dialog(context, 'กรุณาป้อนชื่อผู้ใช้');
                          } else if (password == null) {
                            dialog(context, 'กรุณาป้อนรหัสผ่าน');
                          } else if (first_name == null) {
                            dialog(context, 'กรุณาป้อนชื่อ');
                          } else if (last_name == null) {
                            dialog(context, 'กรุณาป้อนนามสกุล');
                          } else if (address == null) {
                            dialog(context, 'กรุณาป้อนที่อยู่');
                          } else if (phone == null) {
                            dialog(context, 'กรุณาป้อนเบอร์โทรศัพท์');
                          } else {
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
        saveDataCustomer();
      } else {
        dialog(context, 'ชื่อผู้ใช้ $username ถูกใช้งานแล้ว');
      }
    } catch (e) {}
  }

  saveDataCustomer() async {
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/addUser.php?isAdd=true&Type=$type&Username=$username&Password=$password&First_Name=$first_name&Last_Name=$last_name&Address=$address&Phone=$phone&Lat=$lat&Lng=$lng&Status=1';

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
