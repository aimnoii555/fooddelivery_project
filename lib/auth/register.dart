import 'package:flutter/material.dart';
import 'package:fooddelivery_project/auth/registerCustomer.dart';
import 'package:fooddelivery_project/auth/registerRestaurant.dart';
import 'package:fooddelivery_project/auth/registerRider.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/image.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? type;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'สมัครสมาชิก',
            style: MyFont().lookpeachWhite(),
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
          child: ListView(
            padding: EdgeInsets.all(30.0),
            children: [
              Column(
                children: [
                  Text(
                    'เลือกประเภทผู้ใช้งาน',
                    style: MyFont().lookpeachWhite25(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      width: 150.0,
                      height: 150.0,
                      child: Image.asset(MyImage().delivery),
                    ),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Customer',
                        activeColor: Colors.white,
                        groupValue: type,
                        onChanged: (value) {
                          setState(
                            () {
                              type = value.toString();
                            },
                          );
                        },
                      ),
                      Text(
                        'ผู้สั่งอาหาร',
                        style: MyFont().lookpeachWhite20(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Restaurant',
                        activeColor: Colors.white,
                        groupValue: type,
                        onChanged: (value) {
                          setState(
                            () {
                              type = value.toString();
                            },
                          );
                        },
                      ),
                      Text(
                        'ร้านอาหาร',
                        style: MyFont().lookpeachWhite20(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Rider',
                        activeColor: Colors.white,
                        groupValue: type,
                        onChanged: (value) {
                          setState(
                            () {
                              type = value.toString();
                            },
                          );
                        },
                      ),
                      Text(
                        'พนักงานผู้ส่งอาหาร',
                        style: MyFont().lookpeachWhite20(),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 280),
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
                    if (type == 'Restaurant') {
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (value) => RegisterRestaurant(
                                type: type!,
                              ));
                      Navigator.push(context, route);
                    } else if (type == 'Customer') {
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (value) => RegisterCustomer(type: type));
                      Navigator.push(context, route);
                    } else if (type == 'Rider') {
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (value) => RegisterRider(type: type!));
                      Navigator.push(context, route);
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
        ));
  }
}
