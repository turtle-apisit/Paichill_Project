import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:favorite_button/favorite_button.dart';

import 'package:flutter_test_paichill/views/accountpage_ui.dart';
import 'package:flutter_test_paichill/views/coffeepage_ui.dart';
import 'package:flutter_test_paichill/views/detailshop_ui.dart';
import 'package:flutter_test_paichill/views/promotionpage_ui.dart';
import 'package:flutter_test_paichill/views/rootpage_ui.dart';
import 'package:location/location.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageUI extends StatefulWidget {
  const HomePageUI({Key? key}) : super(key: key);

  @override
  State<HomePageUI> createState() => _HomePageUIState();
}

class _HomePageUIState extends State<HomePageUI> {
  TextEditingController txSearch = TextEditingController();
  bool favorite = false;
  late double useLat;
  late double useLng;
  String showDistance = '';
  bool overlay = true;
  String userMail = '';
  String userName = '';
  List reccom = [4];
  List hittop = [4];

  @override
  void initState() {
    super.initState();
    testfunccaltop3value();
    saveNameToSP();
    checkAndGetAndShowDataSp();
  }

  testfunccaltop3value() {
    List<Map<String, dynamic>> data = [
      {"id": 74, "name": "name 1", "type": "defender", "value": 90},
      {"id": 7422, "name": "name 2", "type": "defender", "value": 100},
      {"id": 2213, "name": "Max", "type": "defender", "value": 30},
      {"id": 3333, "name": "John", "type": "defender", "value": 150},
      {"id": 8793, "name": "Alex", "type": "defender", "value": 50},
      {"id": 8793, "name": "aaaa", "type": "defender", "value": 60},
      {"id": 8793, "name": "bbbb", "type": "defender", "value": 190},
      {"id": 8793, "name": "ccc", "type": "defender", "value": 80},
    ];

// sort the data based on
    if (data != null && data.isNotEmpty) {
      data.sort((a, b) => a['value'].compareTo(b['value']));
    }
// you can simply do this
    for (int i = data.length - 3; i < data.length; i++) {
      print(data[i]["name"]);
    }
    print('----------------------------');

    // truncate the max value from the bottom part
    List<Map<String, dynamic>> data1 =
        data.sublist(data.length - 3, data.length);

// show the data whom hold the max value
    data1.reversed.forEach((e) {
      print(e["name"]);
    });
  }

  saveNameToSP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    ////savetosp
    var collection = FirebaseFirestore.instance.collection('user_account');
    var querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      var value = data['email']; // <-- Retrieving the value.
      if (value == sp.getString('email')) {
        sp.setString('name', data['name']);
      }
    }
  }

  checkAndGetAndShowDataSp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //ตรวจสอบkey SharedPreferences
    if (sp.containsKey('userLat') == true) {
      setState(() {
        useLat = sp.getDouble('userLat')!;
      });
    }
    if (sp.containsKey('userLng') == true) {
      setState(() {
        useLng = sp.getDouble('userLng')!;
      });
    }
    if (sp.containsKey('email') == true) {
      setState(() {
        userMail = sp.getString('email')!;
      });
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("shop_account").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Center(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 110,
                    ),
                    child: Column(
                      children: [
                        //hittop3 ร้านที่มีคะแนนมากสุด3อันดับแรก
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 305.0,
                            top: 25.0,
                          ),
                          child: Text(
                            'Hit Top 3',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          height: 220.0,
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot shopData =
                                  snapshot.data!.docs[index];
                              double distance = calculateDistance(
                                  useLat,
                                  useLng,
                                  double.parse(shopData['shoplocation']['lat']),
                                  double.parse(
                                      shopData['shoplocation']['lng']));
                              showDistance = distance.toStringAsFixed(3);
                              List count = shopData['favorite'];
                              for (var i = 0; count.length > i; i++) {
                                if (count[i] == userMail) {
                                  favorite = true;
                                } else if (count[i] != userMail) {
                                  favorite = false;
                                }
                              }
                              return double.parse(
                                              shopData['detailshop']['score']) >
                                          3 &&
                                      double.parse(showDistance) < 5
                                  ? Card(
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.black,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          print(shopData.reference.id);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailShopUI(
                                                docId: shopData.reference.id,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Stack(
                                              alignment: Alignment.bottomLeft,
                                              children: [
                                                Ink.image(
                                                  height: 150.0,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  image: NetworkImage(
                                                    shopData['imagehead'],
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: 300,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 130.0,
                                                    height: 23.0,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Text(
                                                      shopData['detailshop']
                                                          ['name'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 60.0,
                                                  ),
                                                  Container(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Text(
                                                      '${showDistance} Km.',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 300,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 105.0,
                                                    height: 23.0,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Text(
                                                      shopData['detailshop']
                                                          ['district'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 70.0,
                                                  ),
                                                  Container(
                                                      width: 50.0,
                                                      height: 25.0,
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: favorite == true
                                                          ? Icon(
                                                              Icons.favorite,
                                                              color: Colors.red,
                                                              size: 22,
                                                            )
                                                          : Icon(
                                                              Icons.favorite,
                                                              color:
                                                                  Colors.grey,
                                                              size: 22,
                                                            )),
                                                  Container(
                                                    width: 50.0,
                                                    height: 25.0,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.orange,
                                                          size: 23.0,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 3.0,
                                                          ),
                                                          child: Text(
                                                            shopData[
                                                                    'detailshop']
                                                                ['score'],
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14.0,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox();
                            },
                          ),
                        ),
                        //promotion
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 295.0,
                            top: 20.0,
                          ),
                          child: Text(
                            'Promotion',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          height: 200.0,
                          child: ListView(
                            // This next line does the trick.
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Card(
                                clipBehavior: Clip.antiAlias,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.black,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PromotionPageUI(
                                          disCount: '5',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 20.0,
                                                ),
                                                child: Ink.image(
                                                  height: 100.0,
                                                  width: 150.0,
                                                  image: AssetImage(
                                                    'assets/images/pro1.png',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 20.0,
                                                ),
                                                child: Container(
                                                  width: 150.0,
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Text(
                                                    'Discount 5 ฿',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                clipBehavior: Clip.antiAlias,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.black,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PromotionPageUI(
                                          disCount: '10',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 20.0,
                                                ),
                                                child: Ink.image(
                                                  height: 100.0,
                                                  width: 150.0,
                                                  image: AssetImage(
                                                    'assets/images/pro2.png',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 20.0,
                                                ),
                                                child: Container(
                                                  width: 150.0,
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Text(
                                                    'Discount 10 ฿',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                clipBehavior: Clip.antiAlias,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.black,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PromotionPageUI(
                                          disCount: '15',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 20.0,
                                                ),
                                                child: Ink.image(
                                                  height: 100.0,
                                                  width: 150.0,
                                                  image: AssetImage(
                                                    'assets/images/pro3.png',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 20.0,
                                                ),
                                                child: Container(
                                                  width: 150.0,
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Text(
                                                    'Discount 15 ฿',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Reccommend ร้านที่อยู่ใกล้น้อยกว่า1กิโล
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 270.0,
                            top: 20.0,
                          ),
                          child: Text(
                            'Reccommend',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          height: 220.0,
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final DocumentSnapshot shopData =
                                  snapshot.data!.docs[index];
                              double distance = calculateDistance(
                                  useLat,
                                  useLng,
                                  double.parse(shopData['shoplocation']['lat']),
                                  double.parse(
                                      shopData['shoplocation']['lng']));
                              showDistance = distance.toStringAsFixed(3);
                              print(distance);
                              List count = shopData['favorite'];
                              for (var i = 0; count.length > i; i++) {
                                if (count[i] == userMail) {
                                  favorite = true;
                                } else if (count[i] != userMail) {
                                  favorite = false;
                                }
                              }

                              return double.parse(showDistance) < 1
                                  ? Card(
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.black,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailShopUI(
                                                docId: shopData.reference.id,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Stack(
                                              alignment: Alignment.bottomLeft,
                                              children: [
                                                Ink.image(
                                                  height: 150.0,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  image: NetworkImage(
                                                    shopData['imagehead'],
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: 300,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 130.0,
                                                    height: 23.0,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Text(
                                                      shopData['detailshop']
                                                          ['name'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 60.0,
                                                  ),
                                                  Container(
                                                    width: 100.0,
                                                    height: 25.0,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Text(
                                                      '${showDistance} Km.',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 300,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 105.0,
                                                    height: 23.0,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Text(
                                                      shopData['detailshop']
                                                          ['district'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 70.0,
                                                  ),
                                                  Container(
                                                      width: 50.0,
                                                      height: 25.0,
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: favorite == true
                                                          ? Icon(
                                                              Icons.favorite,
                                                              color: Colors.red,
                                                              size: 22,
                                                            )
                                                          : Icon(
                                                              Icons.favorite,
                                                              color:
                                                                  Colors.grey,
                                                              size: 22,
                                                            )),
                                                  Container(
                                                    width: 50.0,
                                                    height: 25.0,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.orange,
                                                          size: 23.0,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 3.0,
                                                          ),
                                                          child: Text(
                                                            shopData[
                                                                    'detailshop']
                                                                ['score'],
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14.0,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Text('');
                            },
                          ),
                        ),
                        //--------
                        SizedBox(
                          width: 40.0,
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 70.0,
                      ),
                      child: SizedBox(
                        height: 120.0,
                        width: MediaQuery.of(context).size.width - 90,
                        child: SearchField(
                          controller: txSearch,
                          suggestions: snapshot.data!.docs
                              .map(
                                (e) => SearchFieldListItem(
                                  e['detailshop']['name'],
                                  item: e,
                                ),
                              )
                              .toList(),
                          suggestionState: Suggestion.expand,
                          textInputAction: TextInputAction.next,
                          hasOverlay: true,
                          searchStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.8),
                          ),
                          searchInputDecoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                            contentPadding: EdgeInsets.all(8),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Colors.black87,
                              ),
                              borderRadius: BorderRadius.circular(
                                6.0,
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.search),
                            ),
                          ),
                          maxSuggestionsInViewPort: 4,
                          itemHeight: 40,
                          onSubmit: (shopName) async {
                            var collection = FirebaseFirestore.instance
                                .collection('shop_account');
                            var querySnapshot = await collection.get();
                            for (var doc in querySnapshot.docs) {
                              Map<String, dynamic> data = doc.data();
                              var value = data['detailshop']
                                  ['name']; // <-- Retrieving the value.
                              if (value == shopName) {
                                String shopId = doc.id.toString();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailShopUI(
                                      docId: shopId,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
