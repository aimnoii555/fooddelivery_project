// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fooddelivery_project/api/host.dart';
// import 'package:fooddelivery_project/customer/cart.dart';
// import 'package:fooddelivery_project/customer/select_food.dart';
// import 'package:fooddelivery_project/dialog/dialog.dart';
// import 'package:fooddelivery_project/model/cart.dart';
// import 'package:fooddelivery_project/model/food.dart';
// import 'package:fooddelivery_project/model/sqlite_helper.dart';
// import 'package:fooddelivery_project/model/user.dart';
// import 'package:fooddelivery_project/style/font.dart';

// class FoodMenuCard extends StatefulWidget {
//   var foodName, foodPrice, amount, sum, image, menuFood, id;
//   FoodMenuCard({
//     Key? key,
//     required this.id,
//     required this.foodName,
//     required this.foodPrice,
//     required this.amount,
//     required this.sum,
//     required this.image,
//     required this.menuFood,
//   }) : super(key: key);

//   @override
//   State<FoodMenuCard> createState() => _FoodMenuCardState();
// }

// class _FoodMenuCardState extends State<FoodMenuCard> {
//   var qty = 1;
//   double sumCon = 0.0;

//   String? foodName, foodPrice, amount, sum, image, menuFood;
//   int? id;

//   double? sumDouble, foodPriceDouble;
//   double transportDouble = 0.0;
//   bool status = true;

//   int amountCon = 1;
//   List<Cart> carts = [];
//   Cart? cart;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     foodName = widget.foodName;
//     foodPrice = widget.foodPrice;
//     amount = widget.amount;
//     sum = widget.sum;
//     image = widget.image;
//     menuFood = widget.menuFood;
//     id = widget.id;

//     amountCon = int.parse(amount!);

//     foodPriceDouble = double.parse(foodPrice!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Row(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       amountCon++;

//                       sumDouble = amountCon * foodPriceDouble!;

//                       print('sumDouble == $sumDouble');
//                     });
//                   },
//                   icon: const Icon(Icons.add_circle),
//                   color: Colors.green,
//                 ),
//                 Text('$amountCon'),
//                 IconButton(
//                   onPressed: () async {
//                     if (amountCon > 1) {
//                       setState(() {
//                         amountCon--;
//                         sumDouble = amountCon * foodPriceDouble!;
//                       });
//                     } else {
//                       print('id = $id');

//                       showDialog(
//                         context: context,
//                         builder: (context) => SimpleDialog(
//                           title: Text(
//                             'ยันยันการลบรายการในตะกร้าหรือไม่',
//                             style: MyFont().lookpeach20(),
//                           ),
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                       primary: Colors.green),
//                                   onPressed: () async {
//                                     await SQLiteHelper()
//                                         .deleteFoodCart(id!)
//                                         .then((value) => {
//                                               print('delete Successfully'),
//                                             });
//                                     Navigator.pop(context);
//                                   },
//                                   child: Text(
//                                     'ยืนยัน',
//                                     style: MyFont().lookpeach18(),
//                                   ),
//                                 ),
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                       primary: Colors.red),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   child: Text(
//                                     'ยกเลิก',
//                                     style: MyFont().lookpeach18(),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                   },
//                   icon: const Icon(
//                     Icons.remove_circle,
//                     color: Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             width: 80,
//             height: 80,
//             child: Image.network(
//               '${MyHost().domain}${image}',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.fromLTRB(50, 0, 0, 10),
//                     child: Text(
//                       'ชื่ออาหาร ${foodName}',
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Container(
//                     child: Text(
//                       'เมนู ${menuFood}',
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     child: Text(sumDouble == null
//                         ? sum.toString()
//                         : sumDouble.toString()),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
