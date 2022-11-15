import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test_paichill/services/google_services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../services/other.dart';

class RegisterPageUI extends StatefulWidget {
  const RegisterPageUI({Key? key}) : super(key: key);

  @override
  State<RegisterPageUI> createState() => _RegisterPageUIState();
}

class _RegisterPageUIState extends State<RegisterPageUI> {
  TextEditingController txName = TextEditingController();
  int rdSex = 0;
  DateTime birthDate = DateTime.now();
  // DateTime birthDate = DateTime.parse('2002-11-25');
  TextEditingController txEmail = TextEditingController();
  TextEditingController txPassword = TextEditingController();
  TextEditingController txConfirm = TextEditingController();
  File? imageUser;
  String fileName = '', path = '';
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  String formatDate = '0000-00-00';

  //open camera
  openCamera() async {
    XFile? picImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (picImage != null) {
      setState(() {
        imageUser = File(picImage.path);
      });
    } else {
      return;
    }
    //setpath to save SharedPreferences
    Directory imgDir = await getApplicationDocumentsDirectory();
    String imgPath = imgDir.path;
    var imgName = basename(picImage.path);
    File localImg = await File(picImage.path).copy('$imgPath/$imgName');
    path = localImg.path;
    fileName = picImage.name.substring(60, 75);
    print(path);
    print(fileName);
  }

  //open gallery & save to SharedPreferences
  openGallery() async {
    XFile? picImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picImage != null) {
      setState(() {
        imageUser = File(picImage.path);
      });
      //setpath to save SharedPreferences
      Directory imgDir = await getApplicationDocumentsDirectory();
      String imgPath = imgDir.path;
      var imgName = basename(picImage.path);
      File localImg = await File(picImage.path).copy('$imgPath/$imgName');
      path = localImg.path;
      fileName = picImage.name.substring(60, 75);
      print(path);
      print(fileName);
    } else {
      return;
    }
  }

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
                      SizedBox(
                        height: 220,
                        width: 220,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            imageUser == null
                                ? Container(
                                    width:
                                        MediaQuery.of(context).size.width * 5.0,
                                    height:
                                        MediaQuery.of(context).size.width * 5.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.blueGrey,
                                        width: 5.0,
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/default_photo.png'),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    height:
                                        MediaQuery.of(context).size.width * 0.5,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.blueGrey,
                                        width: 5.0,
                                      ),
                                      image: DecorationImage(
                                          image: FileImage(
                                            imageUser!,
                                          ),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                            Positioned(
                              bottom: 0,
                              right: -15,
                              child: RawMaterialButton(
                                onPressed: () {
                                  Alert(
                                      context: context,
                                      title: "เลือกรูป",
                                      desc: "Camera หรือ Gallery",
                                      image: Image.asset(
                                        "assets/images/default_photo.png",
                                        width: 120,
                                      ),
                                      buttons: [
                                        DialogButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            openCamera();
                                          },
                                          child: Text(
                                            "Camera",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          color:
                                              Color.fromARGB(255, 34, 184, 96),
                                          radius: BorderRadius.circular(5.0),
                                        ),
                                        DialogButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            openGallery();
                                          },
                                          child: Text(
                                            "Gallery",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          color:
                                              Color.fromARGB(255, 209, 26, 72),
                                          radius: BorderRadius.circular(5.0),
                                        ),
                                      ]).show();
                                },
                                elevation: 2.0,
                                fillColor: Colors.black54,
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white60,
                                ),
                                padding: EdgeInsets.all(6.0),
                                shape: CircleBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 50.0,
                          right: 50.0,
                          top: 25.0,
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
                                    formatDate = DateFormat('yyyy-MM-dd')
                                        .format(birthDate);
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
                      Padding(
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
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 65.0,
                          right: 60.0,
                          top: 50.0,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    var getUrlPic;
                                    String setUrlPic = '';
                                    if (fileName != '') {
                                      getUrlPic = await GoogleServices()
                                          .uploadFirebaseStorage(
                                              path, fileName);
                                      setUrlPic = getUrlPic;
                                    }
                                    if (txName.text.length == 0) {
                                      OtherServices().showWarningDialog(
                                          context, 'กรุณาป้อนชื่อ');
                                    } else if (txEmail.text.length == 0) {
                                      OtherServices().showWarningDialog(
                                          context, 'กรุณาป้อนEmail');
                                    } else if (txPassword.text.length < 6) {
                                      OtherServices().showWarningDialog(context,
                                          'กรุณาป้อนPasswordมากกว่า6ตัว');
                                    } else if (txConfirm.text.length == 0) {
                                      OtherServices().showWarningDialog(
                                          context, 'กรุณาป้อนConfirm Password');
                                    } else if (txPassword.text !=
                                        txConfirm.text) {
                                      OtherServices().showWarningDialog(context,
                                          'กรุณาป้อน Password และ Confirm Password ให้ตรงกัน');
                                    } else {
                                      try {
                                        CollectionReference addUserAccount =
                                            FirebaseFirestore.instance
                                                .collection("user_account");
                                        await addUserAccount.add({
                                          'birthdate': formatDate,
                                          'email': txEmail.text.trim(),
                                          'name': txName.text,
                                          'sex': rdSex.toString(),
                                          'image':
                                              setUrlPic == '' ? '' : setUrlPic,
                                        });
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                          email: txEmail.text.trim(),
                                          password: txPassword.text.trim(),
                                        );

                                        await OtherServices()
                                            .saveDataToSP(txName.text, rdSex,
                                                formatDate, txEmail.text.trim())
                                            .then((value) =>
                                                Navigator.pop(context));
                                      } on FirebaseAuthException catch (e) {
                                        OtherServices().showWarningDialog(
                                            context, 'ระบบขัดข้องแจ้งAdmin');
                                        print(e);
                                      }
                                    }
                                  },
                                  child: Text(
                                    'SignUp',
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
                                width: 25.0,
                              ),
                              SizedBox(
                                width: 120,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () {
                                    txName.text = "";
                                    txEmail.text = "";
                                    txPassword.text = "";
                                    txConfirm.text = "";
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
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
                    ],
                  ),
                ),
              ),
            );
          }
          return Scaffold();
        });
  }
}
