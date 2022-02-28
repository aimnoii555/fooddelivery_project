import 'package:flutter/material.dart';
import 'package:fooddelivery_project/utility/exit_process.dart';
import 'package:fooddelivery_project/utility/my_style.dart';

class MainRider extends StatefulWidget {
  const MainRider({Key? key}) : super(key: key);

  @override
  _MainRiderState createState() => _MainRiderState();
}

class _MainRiderState extends State<MainRider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Rider'),
        actions: [
          IconButton(
            onPressed: () {
              exit_process(context);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          showHead(),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      currentAccountPicture: MyStyle().showLogo(),
      decoration: MyStyle().myBoxDecoration('udru.jpg'),
      accountName: Text(
        'Name Rider',
        style: TextStyle(
          fontFamily: 'peach',
          fontSize: 20.0,
          color: Colors.pink,
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: Text(
        'Login Name',
        style: TextStyle(
          fontFamily: 'peach',
          fontSize: 18.0,
          color: Colors.pink,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
