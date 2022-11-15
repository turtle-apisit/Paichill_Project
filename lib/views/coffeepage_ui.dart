import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detailshop_ui.dart';

class CoffeePageUI extends StatefulWidget {
  const CoffeePageUI({Key? key}) : super(key: key);

  @override
  State<CoffeePageUI> createState() => _CoffeePageUIState();
}

class _CoffeePageUIState extends State<CoffeePageUI> {
  String userName = '';
  String userMail = '';
  bool favorite = false;
  late double useLat;
  late double useLng;
  String showDistance = '';

  @override
  void initState() {
    checkAndGetAndShowDataSp();
    super.initState();
  }

  checkAndGetAndShowDataSp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    userMail = sp.getString('email')!;
    userName = sp.getString('name')!;
    //ตรวจสอบkey SharedPreferences
    if (sp.containsKey('userLat') == true) {
      useLat = sp.getDouble('userLat')!;
    }
    if (sp.containsKey('userLng') == true) {
      useLng = sp.getDouble('userLng')!;
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
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("shop_account").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot shopData = snapshot.data!.docs[index];
              double distance = calculateDistance(
                  useLat,
                  useLng,
                  double.parse(shopData['shoplocation']['lat']),
                  double.parse(shopData['shoplocation']['lng']));
              showDistance = distance.toStringAsFixed(3);
              List count = shopData['favorite'];
              for (var i = 0; count.length > i; i++) {
                if (count[i] == userMail) {
                  favorite = true;
                } else if (count[i] != userMail) {
                  favorite = false;
                }
              }
              return distance < 5
                  ? Container(
                      height: 220.0,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: InkWell(
                          onTap: () {
                            print(shopData.reference.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailShopUI(
                                  docId: shopData.reference.id,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  Ink.image(
                                    height: 150.0,
                                    width: MediaQuery.of(context).size.width,
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
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        shopData['detailshop']['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
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
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        '${showDistance} Km.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
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
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        shopData['detailshop']['district'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70.0,
                                    ),
                                    Container(
                                        width: 50.0,
                                        height: 25.0,
                                        alignment: Alignment.bottomCenter,
                                        child: favorite == true
                                            ? Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                                size: 22,
                                              )
                                            : Icon(
                                                Icons.favorite,
                                                color: Colors.grey,
                                                size: 22,
                                              )),
                                    Container(
                                      width: 50.0,
                                      height: 25.0,
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 23.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 3.0,
                                            ),
                                            child: Text(
                                              shopData['detailshop']['score'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
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
                      ),
                    )
                  : SizedBox(
                      height: 0.1,
                    );
            },
          );
        },
      ),
    );
  }
}
