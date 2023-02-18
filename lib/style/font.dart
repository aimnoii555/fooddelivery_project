import 'package:flutter/material.dart';

class MyFont {
  TextStyle colorWhite() {
    return const TextStyle(
      color: Colors.white,
    );
  }

  TextStyle lookpeach() {
    return const TextStyle(
        fontFamily: 'lookpeach', color: Color.fromARGB(255, 82, 75, 75));
  }

  TextStyle lookpeach18() {
    return const TextStyle(
        fontFamily: 'lookpeach',
        fontSize: 18.0,
        color: Color.fromARGB(255, 82, 75, 75));
  }

  TextStyle lookpeach20() {
    return const TextStyle(
        fontFamily: 'lookpeach',
        fontSize: 20.0,
        color: Color.fromARGB(255, 82, 75, 75));
  }

  TextStyle lookpeach25() {
    return const TextStyle(
        fontFamily: 'lookpeach',
        fontSize: 25.0,
        color: Color.fromARGB(255, 82, 75, 75));
  }

  TextStyle fontWeight18() {
    return const TextStyle(
        fontFamily: 'lookpeach',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 82, 75, 75));
  }

  //------------White-------------
  TextStyle lookpeachWhite() {
    return const TextStyle(fontFamily: 'lookpeach', color: Colors.white);
  }

  TextStyle lookpeachWhite18() {
    return const TextStyle(
        fontFamily: 'lookpeach', fontSize: 18.0, color: Colors.white);
  }

  TextStyle lookpeachWhite20() {
    return TextStyle(
        fontFamily: 'lookpeach', fontSize: 20.0, color: Colors.white);
  }

  TextStyle lookpeachWhite25() {
    return const TextStyle(
        fontFamily: 'lookpeach', fontSize: 25.0, color: Colors.white);
  }

  TextStyle fontWeightWhite18() {
    return const TextStyle(
        fontFamily: 'lookpeach',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white);
  }
}
