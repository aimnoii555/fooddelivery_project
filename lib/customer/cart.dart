import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/customer/cart_provider.dart';
import 'package:fooddelivery_project/customer/checkOut.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/model/cart.dart';
import 'package:fooddelivery_project/model/sqlite_helper.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  double transportDouble = 0.0;

  Cart? cart;
  List<Cart> carts = [];
  bool status = true;
  double total = 0.0;
  String? restaurantName;

  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().getData();
    getCart();
  }

  Future<Null> getCart() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idCus = preferences.getString('id');
    var object = await DBHelper().getCartList(idCus!);
    print('object length = ${object.length}');
    if (object.length == 0) {
      dialog(context, 'ไม่มีรายการในตะกร้า');
    }
    if (object.length != 0) {
      for (var resultTotal in object) {
        print('id = ${resultTotal.idRes}');
        restaurantName = resultTotal.restaurantName;
        int sumString = resultTotal.sum!;
        String transport = resultTotal.transport!;
        transportDouble = double.parse(transport);
        print('transportDouble = $transportDouble');
        double sumInt = double.parse(sumString.toString());
        setState(() {
          status = false;
          carts = object;
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
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ตะกร้าสินค้า',
            style: MyFont().lookpeachWhite18(),
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
          child: Column(
            children: [
              Expanded(
                child: Consumer<CartProvider>(
                  builder: (BuildContext context, provider, widget) {
                    if (provider.cart.isEmpty) {
                      return const Center(
                          child: Text(
                        'ไม่มีสินค้าในตะกร้า',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white,
                            fontFamily: 'lookpeach'),
                      ));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: provider.cart.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Color.fromARGB(255, 71, 165, 241),
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ValueListenableBuilder<int>(
                                      valueListenable: _counter,
                                      builder: (context, val, child) {
                                        return Column(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                int quantity = provider
                                                    .cart[index].amount!;
                                                int price = provider
                                                    .cart[index].foodPrice!;
                                                quantity++;
                                                int newPrice = quantity * price;
                                                cart.addQuantity(
                                                    provider.cart[index].id!);
                                                dbHelper!
                                                    .updateAmount(
                                                  Cart(),
                                                )
                                                    .then((value) {
                                                  setState(() {
                                                    cart.addTotalPrice(
                                                        double.parse(provider
                                                            .cart[index]
                                                            .foodPrice
                                                            .toString()));
                                                  });
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.add_circle,
                                                size: 28,
                                              ),
                                              color: const Color.fromARGB(
                                                  255, 2, 252, 10),
                                            ),
                                            Text(
                                              '${provider.cart[index].amount}',
                                              style: MyFont().colorWhite(),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  cart.deleteQuantity(
                                                      provider.cart[index].id!);
                                                  cart.removeTotalPrice(
                                                    double.parse(
                                                      provider
                                                          .cart[index].foodPrice
                                                          .toString(),
                                                    ),
                                                  );
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.remove_circle,
                                                size: 28,
                                              ),
                                              color: Colors.red,
                                            ),
                                          ],
                                        );
                                      }),
                                  Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.network(
                                        '${MyHost().domain}${provider.cart[index].image}'),
                                  ),
                                  SizedBox(
                                    width: 130,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Column(
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                  text:
                                                      '${provider.cart[index].foodName!}\n ',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  )),
                                            ),
                                            RichText(
                                              maxLines: 1,
                                              text: TextSpan(
                                                  text: 'ราคา: ' r"฿ ",
                                                  style:
                                                      MyFont().lookpeachWhite(),
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            '${provider.cart[index].foodPrice!}\n',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        dbHelper!.deleteCartItem(
                                            provider.cart[index].id!);
                                        provider.removeItem(
                                            provider.cart[index].id!);
                                        provider.removeCounter();
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red.shade800,
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Consumer<CartProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  final ValueNotifier<int?> totalPrice = ValueNotifier(null);
                  for (var element in value.cart) {
                    totalPrice.value = (element.foodPrice! * element.amount!) +
                        (totalPrice.value ?? 0);
                  }
                  return Column(
                    children: [
                      ValueListenableBuilder<int?>(
                          valueListenable: totalPrice,
                          builder: (context, val, child) {
                            return Column(
                              children: [
                                ReusableWidget(
                                    title: 'รวม',
                                    value:
                                        (val?.toStringAsFixed(2) ?? '฿ 0.00')),
                                Container(
                                  height: 40,
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
                                      if (val == null) {
                                        dialog(context,
                                            'ยังไม่มีรายการ ไม่สามารถชำระเงินได้');
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => CheckOut(
                                                      sumDouble: val.toDouble(),
                                                      restaurantName:
                                                          restaurantName!,
                                                    )));
                                      }
                                    },
                                    child: const Center(
                                      child: Text(
                                        'ตรวจสอบการชำระเงิน',
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
                                SizedBox(height: 10),
                              ],
                            );
                          }),
                    ],
                  );
                },
              ),
            ],
          ),
        ));
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({Key? key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 20, right: 20, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: MyFont().lookpeachWhite18(),
          ),
          Text(
            value.toString(),
            style: MyFont().lookpeachWhite18(),
          ),
        ],
      ),
    );
  }
}
