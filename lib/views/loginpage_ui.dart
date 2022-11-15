import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test_paichill/services/google_services.dart';
import 'package:flutter_test_paichill/views/registerpage_ui.dart';
import 'package:flutter_test_paichill/views/resetpassword_ui.dart';
import 'package:flutter_test_paichill/views/rootpage_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/other.dart';

class LoginPageUI extends StatefulWidget {
  const LoginPageUI({Key? key}) : super(key: key);

  @override
  State<LoginPageUI> createState() => _LoginPageUIState();
}

class _LoginPageUIState extends State<LoginPageUI> {
  TextEditingController txEmail = TextEditingController();
  TextEditingController txPassword = TextEditingController();
  String userId = '';
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  String loginType = '';
  @override
  void initState() {
    super.initState();
  }

  Future saveLoginTypeToSP(String loginType, String txmail) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var collection = FirebaseFirestore.instance.collection('user_account');
    var querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      var mail = data['email']; // <-- Retrieving the value.
      if (mail == txmail) {
        String docId = doc.id;
        sp.setString('userId', docId);
        sp.setString('loginType', loginType);
        sp.setString('email', mail);
        sp.setString('birthdate', data['birthdate']);
        sp.setString('image', data['image']);
        sp.setString('name', data['name']);
        sp.setString('sex', data['sex']);
      }
    }
  }
  /* getDataCheckUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var collection = FirebaseFirestore.instance.collection('user_account');
    var querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data();
      var value = data['email']; // <-- Retrieving the value.
      if (value == sp.getString('email')) {
        String docId = doc.id.toString();
        sp.setString('userId', docId);
        setState(() {
          userId = docId;
        });
        print(userId);
      }
    }
  } */

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text(
                "{$snapshot.error}",
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Center(
                child: Column(children: [
                  SizedBox(
                    height: 85,
                  ),
                  Image.asset(
                    'assets/images/pro4.png',
                    width: 300,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 50.0,
                      right: 50.0,
                      top: .0,
                    ),
                    child: SizedBox(
                      height: 65.0,
                      child: TextField(
                        controller: txEmail,
                        decoration: InputDecoration(
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
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Colors.black87,
                            ),
                            borderRadius: BorderRadius.circular(
                              6.0,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black45,
                          ),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 50.0,
                      right: 50.0,
                    ),
                    child: SizedBox(
                      height: 65.0,
                      child: TextField(
                        controller: txPassword,
                        obscureText: true,
                        decoration: InputDecoration(
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
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Colors.black87,
                            ),
                            borderRadius: BorderRadius.circular(
                              6.0,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            color: Colors.black45,
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResetPasswordUI(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 10.0,
                    thickness: 1,
                    indent: 25,
                    endIndent: 25,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 77.0,
                      right: 77.0,
                      top: 30,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 115,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (txEmail.text.length == 0) {
                                  OtherServices().showWarningDialog(
                                      context, 'กรุณาป้อน Email');
                                } else if (txPassword.text.length == 0) {
                                  OtherServices().showWarningDialog(
                                      context, 'กรุณาป้อน Password');
                                } else {
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: txEmail.text.trim(),
                                            password: txPassword.text.trim());

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RootPageUI(),
                                      ),
                                    );
                                    saveLoginTypeToSP(
                                        'default', txEmail.text.trim());
                                  } on FirebaseException catch (e) {
                                    OtherServices().showWarningDialog(
                                        context, 'เกิดข้อผิดพลาดติดต่อadmin');
                                  }
                                }
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 10.0,
                                primary: Colors.blueAccent[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 28.0,
                          ),
                          SizedBox(
                            width: 115,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPageUI(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 10.0,
                                primary: Colors.redAccent[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 50.0,
                      right: 50.0,
                      top: 20.0,
                    ),
                    child: SizedBox(
                      width: 260,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await GoogleServices().facebookSignIn();
                          saveLoginTypeToSP('facebook', '');
                        },
                        icon: Icon(
                          FontAwesomeIcons.facebookF,
                        ),
                        label: Text(
                          'Facebook',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                5.0,
                              ),
                            ),
                            primary: Color(0xFF1E5A99)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 50.0,
                      right: 50.0,
                      top: 10,
                    ),
                    child: SizedBox(
                      width: 260,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await GoogleServices().googleSignIn();
                          saveLoginTypeToSP('gmail', '');
                        },
                        icon: Icon(
                          FontAwesomeIcons.google,
                        ),
                        label: Text(
                          'Gmail',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                5.0,
                              ),
                            ),
                            primary: Color(0xFFFF3200)),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          );
        }
        return Scaffold();
      },
    );
  }
}
