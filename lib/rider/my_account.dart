import 'package:flutter/material.dart';
import 'package:fooddelivery_project/rider/add_money.dart';
import 'package:fooddelivery_project/style/font.dart';

class MyAccountRider extends StatefulWidget {
  const MyAccountRider({Key? key}) : super(key: key);

  @override
  State<MyAccountRider> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccountRider> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: Card(
                    color: Color.fromARGB(255, 3, 102, 183),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 250),
                          child: Text(
                            'บัญชีของคุณ',
                            style: MyFont().lookpeachWhite(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                '100 ฿',
                                style: MyFont().lookpeachWhite20(),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 50),
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return SimpleDialog(
                                      title: Text(
                                        'ถอนเงิน',
                                        style: MyFont().lookpeach(),
                                      ),
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              height: 60,
                                              width: 180,
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'จำนวนเงินที่ต้องถอน',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 100,
                                              child: ElevatedButton(
                                                child: Text('ถอน'),
                                                onPressed: () {},
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }));
                            },
                            child: Text('ถอนเงิน'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.width * 0.98,
            margin: EdgeInsets.only(top: 250),
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  height: MediaQuery.of(context).size.width * 0.25,
                  child: Card(
                    color: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                            'เงินเข้า',
                            style: MyFont().lookpeach(),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(right: 15),
                            child: const Text(
                              '2000.00',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontFamily: 'lookpeach'),
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: 80,
                  height: 60,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddMoney()));
                      },
                      child: const Icon(
                        Icons.add,
                        size: 26,
                      )),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
