import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test_paichill/views/accountpage_ui.dart';
import 'package:flutter_test_paichill/views/homepage_ui.dart';
import 'package:flutter_test_paichill/views/rootpage_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../services/other.dart';

class EditProfileUI extends StatefulWidget {
  const EditProfileUI({Key? key}) : super(key: key);

  @override
  State<EditProfileUI> createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  TextEditingController txName = TextEditingController();
  int rdSex = 0;
  DateTime birthDate = DateTime.now();
  TextEditingController txEmail = TextEditingController();
  TextEditingController txPassword = TextEditingController();
  TextEditingController txConfirm = TextEditingController();
  File? imageUser;
  String formatDate = '0000-00-00';
  String userId = '';

  checkAndGetAndShowDataSp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //ตรวจสอบkey SharedPreferences
    if (sp.containsKey('name') == true) {
      setState(() {
        txName.text = sp.getString('name')!;
      });
    }
    if (sp.containsKey('sex') == true) {
      setState(() {
        rdSex = int.parse(sp.getString('sex')!);
      });
    }
    if (sp.containsKey('birthdate') == true) {
      setState(() {
        var x = sp.getString('birthdate');
        birthDate = DateTime.parse(x!);
        formatDate = DateFormat('yyyy-MM-dd').format(birthDate);
      });
      if (sp.containsKey('userId') == true) {
        var user = sp.getString('userId');
        userId = user!;
      }
    }
  }

  @override
  void initState() {
    checkAndGetAndShowDataSp();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 320,
                  top: 50.0,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 50.0,
                  right: 50.0,
                  top: 100.0,
                ),
                child: SizedBox(
                  height: 65.0,
                  child: TextField(
                    controller: txName,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 236, 233, 233),
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          6.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          6.0,
                        ),
                      ),
                      hintText: 'Name',
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
                  left: 26.0,
                  right: 43.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      value: 0,
                      groupValue: rdSex,
                      onChanged: (val) {
                        setState(() {
                          rdSex = 0;
                        });
                      },
                    ),
                    Text(
                      'Male',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Radio(
                      value: 1,
                      groupValue: rdSex,
                      onChanged: (val) {
                        setState(() {
                          rdSex = 1;
                        });
                      },
                    ),
                    Text(
                      'FeMale',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Radio(
                      value: 2,
                      groupValue: rdSex,
                      onChanged: (val) {
                        setState(() {
                          rdSex = 2;
                        });
                      },
                    ),
                    Text(
                      'LGBT',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 100.0,
                  right: 100.0,
                ),
                child: Row(
                  children: [
                    Text(
                      formatDate,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    SizedBox(
                      width: 100.0,
                      height: 30.0,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: birthDate,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (newDate == null) {
                            return;
                          } else {
                            setState(() => birthDate = newDate);
                            formatDate =
                                DateFormat('yyyy-MM-dd').format(birthDate);
                          }
                        },
                        icon: Icon(
                          Icons.calendar_month_sharp,
                          size: 18.0,
                        ),
                        label: Text(
                          'Select',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /* Padding(
                padding: const EdgeInsets.only(
                  left: 50.0,
                  right: 50.0,
                  top: 20.0,
                ),
                child: SizedBox(
                  height: 65.0,
                  child: TextField(
                    controller: txEmail,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 236, 233, 233),
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          6.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          6.0,
                        ),
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
                      filled: true,
                      fillColor: Color.fromARGB(255, 236, 233, 233),
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          6.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          6.0,
                        ),
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
              Padding(
                padding: const EdgeInsets.only(
                  left: 50.0,
                  right: 50.0,
                ),
                child: SizedBox(
                  height: 65.0,
                  child: TextField(
                    controller: txConfirm,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 236, 233, 233),
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          6.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          6.0,
                        ),
                      ),
                      hintText: 'Confirm Pass',
                      hintStyle: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
              ),
               */
              Padding(
                padding: const EdgeInsets.only(
                  left: 65.0,
                  right: 60.0,
                  top: 50.0,
                ),
                child: SizedBox(
                  width: 150,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (txName.text.length == 0) {
                        OtherServices()
                            .showWarningDialog(context, 'กรุณาป้อน ชื่อ');
                      } else {
                        DocumentReference addFeedback = FirebaseFirestore
                            .instance
                            .collection("user_account")
                            .doc(userId);
                        String datenow =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                        try {
                          await addFeedback.update({
                            "name": txName.text,
                            "birthdate": formatDate,
                            'sex': rdSex.toString(),
                          });
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          sp.setString('birthdate', formatDate);
                          sp.setString('name', txName.text);
                          sp.setString('sex', rdSex.toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RootPageUI(),
                            ),
                          );
                        } on FirebaseException catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 10.0,
                      primary: Color.fromARGB(255, 87, 222, 125),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
