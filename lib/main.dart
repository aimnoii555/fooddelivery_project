import 'package:flutter/material.dart';
import 'package:fooddelivery_project/customer/cart_provider.dart';
import 'package:fooddelivery_project/main_page.dart';
import 'package:fooddelivery_project/style/color.dart';
import 'package:fooddelivery_project/style/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MainPage(),
        );
      }),
    );
  }
}
