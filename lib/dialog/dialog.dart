import 'package:flutter/material.dart';
import 'package:fooddelivery_project/style/font.dart';

Future<void> dialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(
        message,
        style: MyFont().lookpeach18(),
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'ตกลง',
                  style: TextStyle(
                    fontFamily: 'lookpeach',
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
