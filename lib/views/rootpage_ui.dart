import 'dart:math';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'accountpage_ui.dart';
import 'coffeepage_ui.dart';
import 'homepage_ui.dart';

class RootPageUI extends StatefulWidget {
  String name = '';
  String sex = '';
  String birthdate = '';
  String email = '';
  String password = '';
  String image = '';
  List favorite = [];
  String promotion = '';

  RootPageUI({Key? key}) : super(key: key);

  @override
  State<RootPageUI> createState() => _RootPageUIState();
}

class _RootPageUIState extends State<RootPageUI> {
  String user = '';
  @override
  void initState() {
    super.initState();
  }

  /* //getlocationuser
  double userLat = 0.0, userLng = 0.0, distance = 0.0;
  String showDistance = '';
  double shopLat = 13.707491037300096, shopLng = 100.35616450859982;

  @override
  void initState() {
    super.initState();
    findLatLng();
    distance = calculateDistance(userLat, userLng, shopLat, shopLng);
    showDistance = distance.toStringAsFixed(1);
    print(showDistance);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<Null> findLatLng() async {
    LocationData? locationData = await findLocationData();
    userLat = locationData!.latitude!;
    userLng = locationData.longitude!;

    print(userLat);
    print(userLng);
    print('aaaaaa');
  }

  Future<LocationData?> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  } */

  List page = [
    HomePageUI(),
    CoffeePageUI(),
    AccountPageUI(),
  ];
  int selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: selectIndex,
        onItemSelected: (index) {
          setState(() => selectIndex = index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home),
            activeColor: Colors.lightBlue,
            inactiveColor: Colors.black54,
          ),
          BottomNavyBarItem(
            title: Text('Coffee'),
            icon: Icon(Icons.coffee),
            activeColor: Colors.lightBlue,
            inactiveColor: Colors.black54,
          ),
          BottomNavyBarItem(
            title: Text('Account'),
            icon: Icon(Icons.settings),
            activeColor: Colors.lightBlue,
            inactiveColor: Colors.black54,
          ),
        ],
      ),
      body: page.elementAt(selectIndex),
    );
  }
}
