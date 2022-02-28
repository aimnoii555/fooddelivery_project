//page ใช้ร่วมกัน

import 'package:flutter/material.dart';

class MyStyle {
  BoxDecoration myBoxDecoration(String namePic) {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/$namePic'),
        fit: BoxFit.cover,
      ),
    );
  }

  TextStyle fonts() {
    return TextStyle(fontFamily: 'peach');
  }

  //method showLogo
  Container showLogo() {
    return Container(
      width: 120,
      child: Image.asset("images/delivery.png"),
    );
  }

  Widget titleCenter(String string) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            string,
            style: TextStyle(
              fontFamily: 'peach',
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Icon(
          Icons.details,
          color: Colors.red,
          size: 80.0,
        )
      ],
    );
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  MyStyle();
}
