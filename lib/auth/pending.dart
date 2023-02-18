//หน้าแสดงรอการอนุมัติ
import 'package:flutter/material.dart';
import 'package:fooddelivery_project/style/font.dart';

class Pending extends StatefulWidget {
  const Pending({Key? key}) : super(key: key);

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รอการอนุมัติจากแอดมิน ',
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
              Colors.red,
            ])),
        child: Column(
          children: [
            SimpleDialog(
              title: Text(
                'รอดำเนินการ',
                style: MyFont().lookpeach18(),
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          print('object');
                        },
                        child: (Text(
                          'OK',
                          style: MyFont().lookpeach18(),
                        )),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
