import 'package:flutter/material.dart';
import 'package:fooddelivery_project/api/host.dart';
import 'package:fooddelivery_project/cal/calculateDistance.dart';
import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class DataRestaurant extends StatefulWidget {
  final Restaurant restaurant;
  const DataRestaurant({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<DataRestaurant> createState() => _DataRestaurantState();
}

class _DataRestaurantState extends State<DataRestaurant> {
  Restaurant? restaurant;
  double? lat1, lng1, lat2, lng2, distance;
  String distanceString = '';
  int? transport = 0;
  CameraPosition? position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restaurant = widget.restaurant;

    getDistance();
  }

  Future<Null> getDistance() async {
    LocationData? locationData = await getLocation();

    if (this.mounted)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        //ตำแหน่งของ Customer
        lat1 = locationData!.latitude!;
        lng1 = locationData.longitude!;
        // ตำแหน่งของ Resturant
        lat2 = double.parse(restaurant!.lat!);
        lng2 = double.parse(restaurant!.lng!);
        print('lat2 = $lat2, lng2 = $lng2');
        distance = Cal().calShipping(lat1!, lng1!, lat2!, lng2!);
        var myFormat = NumberFormat('#0.0#', 'en_US');
        distanceString = myFormat.format(distance);

        print('transport = $transport');
        print('distance = $distance');
      });
  }

  Future<LocationData?> getLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [
            Colors.blue,
            Color.fromARGB(255, 223, 158, 153),
          ])),
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Text(
            'รูปภาพหน้าร้าน',
            style: MyFont().lookpeachWhite20(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(55, 50, 55, 0),
            width: 250.0,
            height: 250.0,
            child: Image.network(
              '${MyHost().domain}/${restaurant!.image!}',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ชื่อร้าน ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              Text(
                '${restaurant!.restaurantName!}',
                style: MyFont().lookpeachWhite18(),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 30.0),
            child: Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  color: Colors.white,
                  size: 25.0,
                ),
                Text(
                  '  $transport บาท',
                  style: MyFont().lookpeachWhite(),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30.0),
            child: Row(
              children: [
                const Icon(
                  Icons.directions_bike,
                  color: Colors.white,
                  size: 25.0,
                ),
                Text(
                  '  $distanceString กิโลเมตร',
                  style: MyFont().lookpeachWhite(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15.0),
          Container(
            margin: EdgeInsets.only(left: 30.0),
            child: Row(
              children: [
                const Icon(
                  Icons.phone,
                  color: Colors.white,
                  size: 25.0,
                ),
                Text(
                  '  ${restaurant!.phone!}',
                  style: MyFont().lookpeachWhite(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15.0),
          Container(
            margin: EdgeInsets.only(left: 30.0),
            child: Row(
              children: [
                const Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 25.0,
                ),
                Text(
                  '  ${restaurant!.address}',
                  style: MyFont().lookpeachWhite(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
