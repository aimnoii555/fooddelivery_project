import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/model/cart_model.dart';
import 'package:fooddelivery_project/model/food_model.dart';
import 'package:fooddelivery_project/model/user_model.dart';
import 'package:fooddelivery_project/utility/my_ipaddress.dart';
import 'package:fooddelivery_project/utility/normal_dialog.dart';
import 'package:fooddelivery_project/utility/sqlite_helper.dart';
import 'package:fooddelivery_project/utility/toast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  UserModel? userModel;
  List<CartModel> cartModels = [];
  List<FoodModel> foodModels = [];
  double total = 0.0;
  double transportDouble = 0.0;
  bool status = true;

  @override
  void initState() {
    super.initState();
    getCart();
  }

  Future<Null> getCart() async {
    var object = await SQLiteHelper().readAllCart();
    print('object length = ${object.length}');
    if (object.length != 0) {
      for (var resultTotal in object) {
        String sumString = resultTotal.sum!;
        String transport = resultTotal.transport!;
        transportDouble = double.parse(transport);
        print('transportDouble = $transportDouble');
        double sumInt = double.parse(sumString);
        setState(() {
          status = false;
          cartModels = object;
          total = total + sumInt;

          print('total = $total');
        });
      }
    } else {
      setState(() {
        status = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้าสินค้า'),
      ),
      body: status
          ? Center(
              child: Text('ไม่สินค้าในตะกร้า'),
            )
          : content(),
    );
  }

  Widget content() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            NameFromChef(),
            showTable(),
            showCart(),
            Divider(),
            btnClearAllCart(),
            showTotal(),
            btncomfirmOrder()
          ],
        ),
      ),
    );
  }

  Widget btnClearAllCart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RaisedButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            color: Colors.red,
            onPressed: () {
              confirmDeleteAllCart();
            },
            icon: Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
            label: Text(
              'ลบสินค้าในตะกร้าทั้งหมด',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'peach',
              ),
            )),
      ],
    );
  }

  Widget btncomfirmOrder() {
    return Container(
      margin: EdgeInsets.only(top: 320.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: Colors.green,
                onPressed: () {
                  order();
                },
                icon: Icon(
                  Icons.fastfood,
                  color: Colors.white,
                ),
                label: Text(
                  'ตรวจสอบการชำระเงินและที่อยู่',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'peach',
                    fontSize: 16.0,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Future<Null> order() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idUser = preferences.getString('id').toString();
    String nameUser = preferences.getString('Name').toString();

    DateTime dateTime = DateTime.now();
    // print(dateTime.toString());
    String orderString = DateFormat('dd-MM-yyyy HH:mm').format(dateTime);

    String idChef = cartModels[0].idChef!;
    String nameChef = cartModels[0].nameChef!;
    String distance = cartModels[0].distance!;
    String transport = cartModels[0].transport!;

    List<String> idFoods = [];
    List<String> nameFoods = [];
    List<String> prices = [];
    List<String> amounts = [];
    List<String> sums = [];

    for (var model in cartModels) {
      idFoods.add(model.idFood!);
      nameFoods.add(model.nameFood!);
      prices.add(model.price!);
      amounts.add(model.amount!);
      sums.add(model.sum!);
    }

    String idFood = idFoods.toString();
    String nameFood = nameFoods.toString();
    String price = prices.toString();
    String amount = amounts.toString();

    String sum = sums.toString();

    print(
        'idFood = $idFood, idUser = $idUser, NameUser = $nameUser, nameFoods = $nameFood, price = $price, amount= $amount, sum = $sum');

    String url =
        '${MyIpAddress().domain}/FoodDelivery/addOrder.php?isAdd=true&dateTime=$orderString&idUser=$idUser&NameUser=$nameUser&idChef=$idChef&NameChef=$nameChef&Distance=$distance&Transport=$transport&idFood=$idFood&NameFood=$nameFood&Price=$price&Amount=$amount&Sum=$sum&idRider=none&Status=UserOrder';

    await Dio().get(url).then(
      (value) {
        if (value.toString() == 'true') {
          clearAllCart();
          notificationToChef(idChef);
        } else {
          normalDialog(context, 'เกิดข้อผิดพลาด!!');
        }
      },
    );
  }

  Future<Null> notificationToChef(String idChef) async {
    String urlFindToken =
        '${MyIpAddress().domain}/FoodDelivery/getUserWhereId.php?isAdd=true&id=$idChef';

    await Dio().get(urlFindToken).then((value) {
      var result = json.decode(value.data);
      for (var item in result) {
        UserModel userModel = UserModel.fromJson(item);
        String tokenChef = userModel.token!;
        print('tokenChef = $tokenChef');

        String title = 'FoodDelivery';
        String body = 'มีรายการอาหารจากลูกค้า';
        String urlSendToken =
            '${MyIpAddress().domain}/FoodDelivery/apiNotification.php?isAdd=true&token=$tokenChef&title=$body&body=เนื้อหา ข้อความ';

        sendNotificationToChef(urlSendToken);
      }
    });
  }

  Future<Null> sendNotificationToChef(String urlSendToken) async {
    await Dio().get(urlSendToken).then((value) {
      normalDialog(context, 'ส่งข้อความไปยังร้านค้าเรียบร้อยแล้ว');
    });
  }

  Future<Null> clearAllCart() async {
    normalToast('Add Order Successfully');
    await SQLiteHelper().deleteAllCart().then((value) {
      getCart();
    });
  }

  Future<Null> confirmDeleteAllCart() async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text(
                'ยืนยันการลบสินค้าในตะกร้าทังหมด!!',
                style: TextStyle(
                  fontFamily: 'peach',
                ),
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton.icon(
                      color: Colors.green,
                      onPressed: () async {
                        Navigator.pop(context);
                        await SQLiteHelper().deleteAllCart().then(
                          (value) {
                            getCart();
                          },
                        );
                      },
                      icon: Icon(
                        Icons.check,
                      ),
                      label: Text(
                        'ตกลง',
                        style:
                            TextStyle(fontFamily: 'peach', color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    RaisedButton.icon(
                      color: Colors.red,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.clear),
                      label: Text(
                        'ยกเลิก',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'peach',
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                  ],
                ),
              ],
            ));
  }

  Widget NameFromChef() {
    return Text(
      'รายการสั้งซื้อจากร้านคุณ ${cartModels[0].nameChef}',
      style: TextStyle(
        fontFamily: 'peach',
        fontSize: 20.0,
      ),
    );
  }

  Widget showTable() {
    return Container(
      decoration: BoxDecoration(color: Colors.yellow),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                'ชื่ออาหาร',
                style: TextStyle(
                  fontFamily: 'peach',
                  fontSize: 18.0,
                ),
              )),
          Expanded(
              flex: 2,
              child: Text(
                'ราคา',
                style: TextStyle(fontFamily: 'peach', fontSize: 18.0),
              )),
          Expanded(
              flex: 3,
              child: Text(
                'จำนวน',
                style: TextStyle(fontFamily: 'peach', fontSize: 18.0),
              )),
          Expanded(
            flex: 3,
            child: Text(
              'รวม',
              style: TextStyle(fontFamily: 'peach', fontSize: 18.0),
            ),
          ),
          Expanded(
              flex: 2,
              child: Text(
                'ลบ',
                style: TextStyle(
                  fontFamily: 'peach',
                  fontSize: 18.0,
                ),
              ))
        ],
      ),
    );
  }

  Widget showCart() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: cartModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            Divider(),
            Container(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      cartModels[index].nameFood!,
                      style: TextStyle(
                          fontFamily: 'peach',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      cartModels[index].price!,
                      style: TextStyle(fontFamily: 'peach', fontSize: 16.0),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      cartModels[index].amount!,
                      style: TextStyle(fontFamily: 'peach', fontSize: 16.0),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      cartModels[index].sum!,
                      style: TextStyle(fontFamily: 'peach', fontSize: 16.0),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        int id = cartModels[index].id!;
                        print('You Click Delete id = $id');
                        await SQLiteHelper().deleteFoodCart(id).then((value) {
                          print('Successfully delete $id');
                          getCart();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget showTotal() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'ระยะทาง ${cartModels[0].distance} กิโลเมตร',
                  style: TextStyle(fontFamily: 'peach', fontSize: 16.0),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'ค่าส่ง ${cartModels[0].transport} บาท',
                  style: TextStyle(fontFamily: 'peach', fontSize: 16.0),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Text(
                    'รวม  ',
                    style: TextStyle(
                        fontFamily: 'peach',
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${total + transportDouble} บาท',
                    style: TextStyle(
                      fontFamily: 'peach',
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
