import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/customer/cart.dart';
import 'package:fooddelivery_project/customer/cart_provider.dart';
import 'package:fooddelivery_project/customer/data_restaurant.dart';
import 'package:fooddelivery_project/customer/select_food.dart';
import 'package:fooddelivery_project/customer/show_category.dart';
import 'package:fooddelivery_project/model/cart.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:provider/provider.dart';

class AboutRestaurant extends StatefulWidget {
  final Restaurant restaurant;
  AboutRestaurant({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<AboutRestaurant> createState() => _AboutRestaurantState();
}

class _AboutRestaurantState extends State<AboutRestaurant> {
  Restaurant? restaurant;
  List<Widget> listWidget = [];
  int indexPage = 0;
  List<Cart> carts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restaurant = widget.restaurant;
    listWidget.add(DataRestaurant(
      restaurant: restaurant!,
    ));
    listWidget.add(ShowCategory(
      restaurant: restaurant!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ร้าน ${restaurant!.restaurantName!}'),
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
      ),
      body: listWidget.length == 0 ? showProgress() : listWidget[indexPage],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 249, 248, 246),
        backgroundColor: Color.fromARGB(255, 223, 158, 153),
        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info,
            ),
            label: 'ข้อมูลร้านอาหาร',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.restaurant_menu,
            ),
            label: 'รายการอาหาร',
          ),
        ],
      ),
    );
  }
}
