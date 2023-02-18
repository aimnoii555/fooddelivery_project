import 'dart:math';

class Cal {
  // คำนวณระยะทาง
  double calShipping(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));
    return distance;
  }

  // คำนวณค่าจัดส่ง
  int? calculateTransport(double distance) {
    int disPrice;
    if (distance <= 3) {
      //3
      disPrice = 3 + (distance).round();
    } else if (distance <= 5) {
      // 10
      disPrice = 10 + (distance).round();
    } else if (distance <= 7) {
      // 20
      disPrice = 20 + (distance).round();
    } else {
      // 30
      disPrice = 30 + (distance).round();
    }
    return disPrice;
  }

  List<String> subString(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> list = result.split(',');
    int index = 0;
    for (var item in list) {
      list[index] = item.trim();
      index++;
    }
    return list;
  }

  Cal();
}
