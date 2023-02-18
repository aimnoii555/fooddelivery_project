import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';

import 'package:fooddelivery_project/model/user.dart';
import 'package:fooddelivery_project/rider/networking.dart';
import 'package:fooddelivery_project/style/font.dart';
import 'package:fooddelivery_project/style/progress.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapRestaurant extends StatefulWidget {
  final Restaurant restaurant;
  final double latRider, lngRider, latRes, lngRes;
  const MapRestaurant({
    Key? key,
    required this.restaurant,
    required this.latRider,
    required this.lngRider,
    required this.latRes,
    required this.lngRes,
  }) : super(key: key);

  @override
  State<MapRestaurant> createState() => _MapRestaurantState();
}

class _MapRestaurantState extends State<MapRestaurant> {
  late GoogleMapController _googleMapController;
  final List<LatLng> polyPoints = [];
  final Set<Polyline> polyLines = {};
  List<Marker> markers = <Marker>[];
  Restaurant? restaurant;
  double? latRider, lngRider, latRes, lngRes, distance;

  final GlobalKey globalKey = GlobalKey();

  var data;
  LatLng? start;
  LatLng? end;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restaurant = widget.restaurant;
    latRider = widget.latRider;
    lngRider = widget.lngRider;
    latRes = widget.latRes;
    lngRes = widget.lngRes;
    getLaLng();
    getJsonData();
  }

  Future<Null> getLaLng() async {
    start = LatLng(latRider!, lngRider!);
    end = LatLng(latRes!, lngRes!);
  }

  void getJsonData() async {
    NetworkHelper networkHelper = NetworkHelper(
      startLng: start!.longitude,
      startLat: start!.latitude,
      endLat: end!.latitude,
      endLng: end!.longitude,
    );

    try {
      data = await networkHelper.getData();

      LineString ls =
          LineString(data['features'][0]['geometry']['coordinates']);

      for (int i = 0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      if (polyPoints.length == ls.lineString.length) {
        setPolyLines();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แผ่นที่ของร้านอาหาร',
          style: MyFont().lookpeach(),
        ),
      ),
      body: end == null
          ? showProgress()
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(end!.latitude, end!.longitude),
                zoom: 16,
              ),
              markers: Set<Marker>.of(markers),
              polylines: polyLines,
            ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    setMarkers();
  }

  setMarkers() async {
    markers.add(
      Marker(
        markerId: MarkerId('start'),
        position: start!,
        infoWindow: InfoWindow(
          title: 'Home',
        ),
        icon: await MarkerIcon.downloadResizePictureCircle(
            'https://previews.123rf.com/images/puruan/puruan1702/puruan170201752/71631813-motorcycle-icon-in-color-sport-speed-race.jpg',
            size: 150,
            addBorder: true,
            borderColor: Colors.white,
            borderSize: 15),
      ),
    );
    markers.add(
      Marker(
          markerId: MarkerId('end'),
          position: end!,
          infoWindow: InfoWindow(
            title: 'End',
          )),
    );
    setState(() {});
  }

  setPolyLines() {
    Polyline polyline = Polyline(
        polylineId: PolylineId('polyLine'),
        color: Colors.lightBlue,
        points: polyPoints);
    polyLines.add(polyline);
    setState(() {});
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
