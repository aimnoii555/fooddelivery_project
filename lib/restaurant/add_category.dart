import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/dialog/dialog.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  String? categoryName;
  String? _chooseValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เพิ่มประเภทสินค้า',
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
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 245, 227, 227),
                      borderRadius: BorderRadius.circular(15)),
                  margin: EdgeInsets.all(20),
                  child: DropdownButton(
                    borderRadius: BorderRadius.circular(8),
                    value: _chooseValue,
                    style: MyFont().lookpeach(),
                    underline: SizedBox(),
                    alignment: Alignment.center,
                    items: [
                      'อาหารเอเชีย',
                      'อาหารไทย',
                      'ของหวาน',
                      'เนื้อสัตว์',
                      'ตามสั่ง',
                      'อาหารอีสาน',
                      'ชาไข่มุข',
                      'อาหารญี่ปุ่น',
                      'เครื่องดื่ม',
                      'ก๋วยเตี๋ยว',
                      'ชาและกาแฟ',
                      'ไก่',
                      'อาหารตะวันตก',
                      'ส้มตำ',
                      'ยำ',
                      'อาหารทอด',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [Text(value), Divider()],
                          ),
                        ),
                      );
                    }).toList(),
                    hint: Container(
                      margin: EdgeInsets.only(left: 40, right: 40),
                      child: Text('เลือกประเภทอาหาร'),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _chooseValue = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 620),
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
                onPressed: () async {
                  if (_chooseValue == null) {
                    dialog(context, 'กรุณาเลือกประเภทอาหาร');
                  } else {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    String? idRes = preferences.getString('id');
                    String url =
                        '${MyHost().domain}/Project_Flutter/FoodDelivery/addCategory.php?isAdd=true&idRes=$idRes&categoryName=$_chooseValue';

                    await Dio().get(url).then((value) {
                      Navigator.pop(context);
                      dialog(context, 'เพิ่มประเภทอาหารเรียบร้อย');
                    });
                  }
                },
                child: const Center(
                  child: Text(
                    'เพิ่ม',
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
    );
  }
}
