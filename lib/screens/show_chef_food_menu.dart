import 'package:flutter/material.dart';
import 'package:fooddelivery_project/model/user_model.dart';
import 'package:fooddelivery_project/screens/cart.dart';
import 'package:fooddelivery_project/utility/my_style.dart';
import 'package:fooddelivery_project/widget/about_chef.dart';
import 'package:fooddelivery_project/widget/show_menu_food.dart';

class ShowChefFoodMenu extends StatefulWidget {
  final UserModel
      userModel; //รับค่า index จาก show_chef_food_menu.dart from method createData
  const ShowChefFoodMenu({Key? key, required this.userModel}) : super(key: key);

  @override
  _ShowChefFoodMenuState createState() => _ShowChefFoodMenuState();
}

class _ShowChefFoodMenuState extends State<ShowChefFoodMenu> {
  UserModel? userModel;
  List<Widget> listWidgets = [];
  int indexPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    listWidgets.add(AboutChef(userModel: userModel!));
    listWidgets.add(ShowMenuFood(
      userModel: userModel!,
    ));
  }

  BottomNavigationBarItem aboutChef() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.fastfood),
      title: Text('รายละเอียด'),
    );
  }

  BottomNavigationBarItem showMenuFood() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_menu),
      title: Text('เมนูอาหาร'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => Cart());
                Navigator.push(context, route);
              },
              icon: Icon(Icons.shopping_cart))
        ],
        title: Text(
          'ร้านคุณ ${userModel!.nameChef!}',
          style: TextStyle(fontFamily: 'peach', fontSize: 14.0),
        ), //show title from method createData show_chef_food_menu.dart
      ),
      body: listWidgets.length == 0
          ? MyStyle().showProgress()
          : listWidgets[indexPage],
      bottomNavigationBar: showBottom(),
    );
  }

  BottomNavigationBar showBottom() => BottomNavigationBar(
        selectedItemColor: Colors.orange,
        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: <BottomNavigationBarItem>[
          aboutChef(),
          showMenuFood(),
        ],
      );
}
