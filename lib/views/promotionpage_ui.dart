// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PromotionPageUI extends StatefulWidget {
  String disCount = '';
  PromotionPageUI({
    Key? key,
    required this.disCount,
  }) : super(key: key);

  @override
  State<PromotionPageUI> createState() => _PromotionPageUIState();
}

class _PromotionPageUIState extends State<PromotionPageUI> {
  String code = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Discount ${widget.disCount} ฿',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("code_promotion")
            .doc('code${widget.disCount}')
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          Map<String, dynamic> codeData =
              snapshot.data!.data() as Map<String, dynamic>;
          return Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 100,
                  ),
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width - 80,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.redAccent,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'QR Code For You ',
                            style: TextStyle(
                              fontSize: 27,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 3,
                            ),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //qrcode
                codeData['count'] != 0
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 50,
                        ),
                        child: QrImage(
                          data: codeData['code'],
                          backgroundColor: Colors.white,
                          size: 270,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                          top: 60,
                        ),
                        child: Container(
                          height: 330,
                          width: MediaQuery.of(context).size.width - 80,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/emoji.png',
                                  height: 90,
                                ),
                                SizedBox(
                                  height: 35.0,
                                ),
                                Text(
                                  'ขออภัย \n\nวันนี้ส่วนลดหมดแล้ว',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
