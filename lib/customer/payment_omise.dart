import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/cart.dart';
import 'package:fooddelivery_project/model/user.dart';

import 'package:fooddelivery_project/style/font.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:omise_flutter/omise_flutter.dart';

import 'package:http/http.dart' as http;

class PaymentOmise extends StatefulWidget {
  final double sumDouble, transportDouble;
  const PaymentOmise(
      {Key? key,
      required,
      required this.sumDouble,
      required this.transportDouble})
      : super(key: key);

  @override
  State<PaymentOmise> createState() => _PaymentOmiseState();
}

class _PaymentOmiseState extends State<PaymentOmise> {
  String? name, surname, cardNumber, expiryDateMonth, expiryDateYear, cvc;
  String? amount;
  var formkey = GlobalKey<FormState>();
  Cart? cart;
  List<Cart> carts = [];
  Restaurant? restaurant;
  String idRes = '';
  double total = 0.0;
  double transportDouble = 0.0;
  String? totalString;
  double sumDouble = 0.0;
  double sumTotal = 0.0;

  MaskTextInputFormatter cardNumberMask =
      MaskTextInputFormatter(mask: '#### - #### - #### - ####');
  MaskTextInputFormatter expiryDateMask =
      MaskTextInputFormatter(mask: '## / ####');
  MaskTextInputFormatter cvcMask = MaskTextInputFormatter(mask: '###');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sumDouble = widget.sumDouble;
    transportDouble = widget.transportDouble;
    sumTotal = transportDouble + sumDouble;
  }

  Future<Null> getOrder() async {
    idRes = restaurant!.id!;
    print('idRes = $idRes');
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getCartWhereId.php?isAdd=true&idRes=$idRes';

    await Dio().get(url).then((value) {
      // print('value == $value');
      if (value.toString() != '') {
        var result = json.decode(value.data);

        print('result == $result');
        for (var map in result) {
          cart = Cart.fromJson(map);

          String transport = cart!.transport!;
          transportDouble = double.parse(transport);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Omise',
          style: MyFont().lookpeachWhite18(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
                colors: [
              Colors.blue,
              Color.fromARGB(255, 223, 158, 153),
            ])),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              behavior: HitTestBehavior.opaque,
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Text(
                            'Name',
                            style: MyFont().colorWhite(),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Surname',
                            style: MyFont().colorWhite(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 180,
                          child: TextFormField(
                            style: MyFont().colorWhite(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'กรุณาป้อนชื่อ';
                              } else {
                                name = value.trim();
                                return null;
                              }
                            },
                            onChanged: (value) {
                              name = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Name',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 180,
                          child: TextFormField(
                            style: MyFont().colorWhite(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'กรุณาป้อนนามสกุล';
                              } else {
                                surname = value.trim();
                                return null;
                              }
                            },
                            onChanged: (value) {
                              surname = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Surname',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      margin: EdgeInsets.only(right: 250, bottom: 15),
                      child: Text(
                        'Card Number:',
                        style: MyFont().colorWhite(),
                      ),
                    ),
                    Container(
                      width: 370.0,
                      child: TextFormField(
                        style: MyFont().colorWhite(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'กรุณาป้อนหมายเลขบ้ตรเครดิต';
                          } else {
                            if (cardNumber!.length != 16) {
                              return 'กรุณาป้อนหมายเลขบ้ตรเครดิตให้ครบจำนวน';
                            } else {
                              return null;
                            }
                          }
                        },
                        inputFormatters: [cardNumberMask],
                        onChanged: (value) {
                          cardNumber = cardNumberMask.getUnmaskedText();
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Card Number',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          width: 180,
                          child: TextFormField(
                            style: MyFont().colorWhite(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'กรุณาป้อนวันหมดอายุบัตรเครดิต';
                              } else {
                                String expiryDateString =
                                    expiryDateMask.getUnmaskedText();
                                expiryDateMonth =
                                    expiryDateString.substring(0, 2);
                                expiryDateYear =
                                    expiryDateString.substring(2, 6);

                                int expiryDateMonthInt =
                                    int.parse(expiryDateMonth!);

                                if (expiryDateMonthInt > 12) {
                                  return 'กรุณาป้อนวันหมดอายุให้ถูกต้อง';
                                } else {
                                  return null;
                                }
                              }
                            },
                            inputFormatters: [expiryDateMask],
                            onChanged: (value) {
                              String expiryDateString =
                                  expiryDateMask.getUnmaskedText();
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Expiry Date',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 120,
                          margin: EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            style: MyFont().colorWhite(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'รหัสรักษาความปลอดภัย';
                              } else {
                                return null;
                              }
                            },
                            inputFormatters: [cvcMask],
                            onChanged: (value) {
                              cvc = cvcMask.getUnmaskedText();
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Security Code.',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 370.0,
                      child: TextFormField(
                        style: MyFont().colorWhite(),
                        readOnly: true,
                        initialValue: sumTotal.toString(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Input Amount';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          amount = value.trim();
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Amount',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 400.0),
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
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            getTokenOmise().then((value) async {
                              String url =
                                  '${MyHost().domain}/Project_Flutter/FoodDelivery/deleteCart.php?isAdd=true';
                              await Dio().get(url).then((value) {
                                if (value.toString() == 'true') {
                                  Fluttertoast.showToast(
                                      msg: 'ชำระเงินเรียบร้อย');
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } else {
                                  dialog(context, 'เกิดข้อผิดพลาด');
                                }
                              });
                            });
                          }
                        },
                        child: const Center(
                          child: Text(
                            'ชำระเงิน',
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
          ),
        ),
      ),
    );
  }

  Future<void> getTokenOmise() async {
    String publicKey = 'pkey_test_5sprfeve3t27ohnin9e';
    String secretKey = 'skey_test_5sprfewklkw14qvhcb4';

    print(
        'name = $name,  surname = $surname,publicKey = $publicKey, cardNumber = $cardNumber, expiryDateMonth = $expiryDateMonth, expiryDateYear = $expiryDateYear, cvc = $cvc');

    OmiseFlutter omiseFlutter = OmiseFlutter(publicKey);
    await omiseFlutter.token
        .create('$name $surname', cardNumber!, expiryDateMonth!,
            expiryDateYear!, cvc!)
        .then((value) async {
      String token = value.id.toString();
      String urlAPI = 'https://api.omise.co/charges';
      String basicAuth = 'Basic ' + base64Encode(utf8.encode(secretKey + ":"));

      Map<String, String> map = {};
      map['authorization'] = basicAuth;
      map['Cache-Control'] = 'no-cache';
      map['Content-Type'] = 'application/x-www-form-urlencoded';

      total = sumTotal + transportDouble;
      totalString = total.toString();
      String zero = '0';

      totalString = '$amount$zero';
      print('totalString == $totalString');

      Map<String, dynamic> data = {};
      data['amount'] = amount;
      data['currency'] = 'thb';
      data['card'] = token;

      Uri uri = Uri.parse(urlAPI);

      http.Response response = await http.post(
        uri,
        headers: map,
        body: data,
      );

      var resultCharge = json.decode(response.body);
      // print('resultCharage = $resultCharge');
      print('status ของการตัดบัตร === ${resultCharge['status']}');

      print('token = $token');
    }).catchError((value) {
      // String title = value.code;
      // String message = value.message;
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: const ListTile(
            title: Text('title'),
            subtitle: Text('message'),
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ตกลง',
                    style: MyFont().lookpeach(),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
