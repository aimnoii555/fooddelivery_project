import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/cal/calculateDistance.dart';
import 'package:fooddelivery_project/customer/cart.dart';
import 'package:fooddelivery_project/customer/cart_provider.dart';
import 'package:fooddelivery_project/customer/debouncer.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';

import 'package:fooddelivery_project/model/cart.dart';
import 'package:fooddelivery_project/model/category.dart';
import 'package:fooddelivery_project/model/food.dart';
import 'package:fooddelivery_project/model/sqlite_helper.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectFood extends StatefulWidget {
  final Restaurant restaurant;
  final String idCategory;
  final Category category;
  const SelectFood(
      {Key? key,
      required this.restaurant,
      required this.idCategory,
      required this.category})
      : super(key: key);

  @override
  State<SelectFood> createState() => _SelectFoodState();
}

class _SelectFoodState extends State<SelectFood> {
  Restaurant? restaurant;
  String idRestaurant = '';

  List<Cart> carts = [];
  List<Food> foods = [];
  Location location = Location();
  double? lat1, lng1, lat2, lng2;
  int amount = 1;
  Cart? cart;
  String? idResSQL;
  int length = 0;
  String? idFoodSQL, foodNameSQL, idCategory;
  Category? category;
  String? idCus;

  final Debouncer debouncer = Debouncer(milliseconds: 500);
  List<Food> filterFoods = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restaurant = widget.restaurant;
    idCategory = widget.idCategory;
    category = widget.category;
    getLocation();
    getFood();
    getCart();
  }

  Future<Null> getCart() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idCus = preferences.getString('id');
    var object = await DBHelper().getCartList(idCus!);

    for (var resultTotal in object) {
      setState(() {
        idFoodSQL = resultTotal.idFood!;
      });
    }
  }

  Future<Null> getLocation() async {
    location.onLocationChanged.listen((event) {
      lat1 = event.latitude!;
      lng1 = event.longitude!;
    });
  }

// ดึงรายการอาหารจาก id ของร้าานค้า
  Future<Null> getFood() async {
    if (foods.length != 0) {
      foods.clear();
      filterFoods.clear();
    }

    idRestaurant = restaurant!.id!;
    print('id = $idRestaurant');
    String url =
        '${MyHost().domain}/Project_Flutter/FoodDelivery/getFoodWhereCategory.php?isAdd=true&idCategory=$idCategory';

    Response response = await Dio().get(url);
    var result = json.decode(response.data);

    if (result == null) {
      dialog(context, 'ไม่มีรายการอาหารประเภท ${category!.categoryName}');
    }

    for (var map in result) {
      Food food = Food.fromJson(map);

      if (food.depleted != 'close') {
        setState(() {
          foods.add(food);
          filterFoods.add(food);
        });
      }
    }
  }

  Future<Null> orderCart(int index) async {
    String restaurantName = restaurant!.restaurantName!;
    String idFood = foods[index].id!;
    String foodName = foods[index].foodName!;
    String menuFood = foods[index].menuFood!;
    String price = foods[index].foodPrice!;
    String image = foods[index].image!;

    int priceCon = int.parse(price);

    double priceDouble = double.parse(price);
    double sum = priceDouble * amount;
    lat2 = double.parse(restaurant!.lat!);
    lng2 = double.parse(restaurant!.lng!);

    int sumCon = sum.toInt();

    double distance = Cal().calShipping(lat1!, lng1!, lat2!, lng2!);
    var myFormat = NumberFormat('#0.0#', 'en_US');
    String distanceString = myFormat.format(distance);

    int? transport = Cal().calculateTransport(distance);

    // print(
    //     'transport = $transport, distance = $distance, distanceString = $distanceString, sum = $sum');

    //----------------------------------------------------------------------------

    Map<String, dynamic> map = Map();
    map['restaurantName'] = restaurantName;
    map['idRes'] = idRestaurant;
    map['idFood'] = idFood;
    map['idCus'] = idCus;
    map['foodName'] = foodName;
    map['foodPrice'] = priceCon;
    map['amount'] = amount;
    map['sum'] = sumCon;
    map['distance'] = distanceString.toString();
    map['menuFood'] = menuFood;
    map['transport'] = transport.toString();
    map['image'] = image;
    print('map = ${map.toString()}');

    Cart cartModel = Cart.fromJson(map);

    var object = await DBHelper().getCartList(idCus!);

    if (object.length == 0) {
      await DBHelper().insert(cartModel).then((value) {
        Fluttertoast.showToast(
            msg: 'เพิ่ม ${cartModel.foodName} ลงในตะกร้านเรียบร้อยร้อย');
        print('success');
      });
    } else {
      String idResSQL = object[0].idRes!;

      if (idRestaurant == idResSQL) {
        if (idFoodSQL == idFood) {
          print('idFood == $idFood, idFoodSQL == $idFoodSQL');
          dialog(context, '${foodName} มีในตะกร้าอยู่แล้ว');
        } else {
          print('idFood2 == $idFood, idFoodSQL2 == $idFoodSQL');
          await DBHelper().insert(cartModel).then((value) {
            Fluttertoast.showToast(
                msg: 'เพิ่ม ${cartModel.foodName} ลงในตะกร้านเรียบร้อยร้อย');
          });
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            children: [
              ListTile(
                title: Text(
                  'มีรายการในตะกร้าซ้ำกับร้านอื่น',
                  style: MyFont().lookpeach20(),
                ),
                subtitle: const Text(
                    'คุณเลือกร้านอื่น หากดำเนินการต่อรายการในตะกร้าของคุณจะถูกลบ'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: () async {
                      await DBHelper().deleteAllCart().then((value) {
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      'ลบ',
                      style: MyFont().lookpeach18(),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ยกเลิก',
                      style: MyFont().lookpeach18(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return const Text(
                    '',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  );
                },
              ),
              position: const BadgePosition(start: 30, bottom: 30),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()));
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
          ],
          title: Text(
            'รายการอาหารร้าน ${restaurant!.restaurantName}',
            style: MyFont().lookpeachWhite18(),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2));
            getFood();
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
              child: Stack(
                children: [
                  foods.length == 0
                      ? showProgress()
                      : Container(
                          padding: EdgeInsets.only(top: 80.0),
                          child: ListView.builder(
                            itemCount: filterFoods.length,
                            itemBuilder: (context, index) {
                              return Card(
                                shadowColor: Colors.green,
                                color: Color.fromARGB(255, 134, 195, 245),
                                margin: const EdgeInsets.only(
                                    right: 10, top: 8, left: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    print('click index = $index');
                                    showDialog(
                                      context: context,
                                      builder: (context) => StatefulBuilder(
                                        builder: ((context, setState) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            title: Row(
                                              children: [
                                                Text(
                                                  '${foods[index].foodName}',
                                                  style: MyFont().lookpeach18(),
                                                ),
                                              ],
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 220.0,
                                                  height: 150.0,
                                                  child: Image.network(
                                                    '${MyHost().domain}/${filterFoods[index].image}',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        if (amount > 1) {
                                                          setState(() {
                                                            amount--;
                                                          });
                                                        }
                                                      },
                                                      icon: const Icon(
                                                          Icons.remove_circle),
                                                      iconSize: 36.0,
                                                      color: Colors.red,
                                                    ),
                                                    Text(
                                                      amount.toString(),
                                                      style: MyFont()
                                                          .lookpeach20(),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          amount++;
                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.add_circle),
                                                      iconSize: 36.0,
                                                      color: Colors.green,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      width: 100.0,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary: Colors.green,
                                                        ),
                                                        onPressed: () async {
                                                          orderCart(index)
                                                              .then((value) {
                                                            getCart();
                                                          });

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Icon(
                                                          Icons
                                                              .add_shopping_cart,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 100.0,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary:
                                                                    Colors.red),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            Icon(Icons.cancel),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 10.0),
                                            width: 100,
                                            height: 80,
                                            child: Image.network(
                                              '${MyHost().domain}/${filterFoods[index].image}',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 30),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '${filterFoods[index].foodName}',
                                                    style: MyFont()
                                                        .lookpeachWhite18(),
                                                  ),
                                                  Text(
                                                    'ราคา ${filterFoods[index].foodPrice} บาท',
                                                    style: MyFont()
                                                        .lookpeachWhite(),
                                                  ),
                                                  Text(
                                                    'รายละเอียด ${filterFoods[index].detail}',
                                                    style: MyFont()
                                                        .lookpeachWhite(),
                                                  ),
                                                  Text(
                                                    'เมนูอาหาร ${filterFoods[index].menuFood}',
                                                    style: MyFont()
                                                        .lookpeachWhite(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    width: 380,
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      style: MyFont().colorWhite(),
                      onChanged: (value) {
                        debouncer.run(() {
                          setState(() {
                            filterFoods = foods
                                .where((u) => (u.foodName!
                                    .toLowerCase()
                                    .contains(value.toLowerCase())))
                                .toList();
                          });
                        });
                      },
                      decoration: InputDecoration(
                        label: Text(
                          'ค้นหารอาหาร',
                          style: MyFont().lookpeachWhite(),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
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
              )),
        ));
  }
}
