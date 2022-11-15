import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test_paichill/services/other.dart';
import 'package:flutter_test_paichill/views/loginpage_ui.dart';
import 'package:flutter_test_paichill/views/promotionpage_ui.dart';
import 'package:flutter_test_paichill/views/resetpassword_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/google_services.dart';
import 'editprofile_ui.dart';
import 'favoritepage_ui.dart';

class AccountPageUI extends StatefulWidget {
  AccountPageUI({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountPageUI> createState() => _AccountPageUIState();
}

class _AccountPageUIState extends State<AccountPageUI> {
  String userId = '';
  TextEditingController txName = TextEditingController();
  TextEditingController txSex = TextEditingController();
  TextEditingController txMail = TextEditingController();
  TextEditingController txBirthDate = TextEditingController();
  File? imageUser;
  String showImageUser = '';
  String checkUserMail = '';
  String fileName = '', path = '';

//เปิดแกลอรี่
  Future selectImgFromGallery() async {
    final imageSelect =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageSelect == null) {
      return;
    }
    //กรณีเลือกรูป
    final imageSelectPath = File(imageSelect.path);
    setState(() {
      imageUser = imageSelectPath;
    });

    //setpath to save SharedPreferences
    Directory imgDir = await getApplicationDocumentsDirectory();
    String imgPath = imgDir.path;
    var imgName = basename(imageUser!.path);
    File localImg = await File(imageUser!.path).copy('$imgPath/$imgName');
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('image', localImg.path);
  }

  /* checkAndGetAndShowDataSp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //ตรวจสอบkey SharedPreferences
    if (sp.containsKey('image') == true) {
      setState(() {
        imageUser = File(sp.getString('image')!);
      });
    }
    if (sp.containsKey('name') == true) {
      setState(() {
        txName.text = sp.getString('name')!;
      });
    }
    if (sp.containsKey('sex') == true) {
      setState(() {
        int sex = int.parse(sp.getString('sex')!) ;
        switch (sex) {
          case 0:
            {
              txSex.text = 'Male';
            }
            break;
          case 1:
            {
              txSex.text = 'FeMale';
            }
            break;
          case 2:
            {
              txSex.text = 'LGBT';
            }
            break;
        }
      });
    }
    if (sp.containsKey('birthDate') == true) {
      setState(() {
        txBirthDate.text = sp.getString('birthDate')!;
      });
    }
    if (sp.containsKey('email') == true) {
      setState(() {
        txMail.text = sp.getString('email')!;
      });
    }
  }
 */
  //open camera
  openCamera() async {
    XFile? picImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (picImage != null) {
      setState(() {
        imageUser = File(picImage.path);
      });

      Directory imgDir = await getApplicationDocumentsDirectory();
      String imgPath = imgDir.path;
      var imgName = basename(picImage.path);
      File localImg = await File(picImage.path).copy('$imgPath/$imgName');
      path = localImg.path;
      fileName = picImage.name.substring(60, 75);
      var getUrlPic;
      String setUrlPic = '';
      getUrlPic = await GoogleServices().uploadFirebaseStorage(path, fileName);
      setUrlPic = getUrlPic;
      SharedPreferences sp = await SharedPreferences.getInstance();
      if (sp.containsKey('userId') == true) {
        setState(() {
          userId = sp.getString('userId')!;
          showImageUser = setUrlPic;
        });
      }
      DocumentReference editImagePro = await FirebaseFirestore.instance
          .collection("user_account")
          .doc(userId);
      try {
        await editImagePro.update({
          "image": setUrlPic,
        });
        sp.setString('image', setUrlPic);
      } on FirebaseException catch (e) {
        print(e);
      }
    } else {
      return;
    }
  }

  //open gallery & save to SharedPreferences
  openGallery() async {
    XFile? picImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picImage != null) {
      setState(() {
        imageUser = File(picImage.path);
      });
      Directory imgDir = await getApplicationDocumentsDirectory();
      String imgPath = imgDir.path;
      var imgName = basename(picImage.path);
      File localImg = await File(picImage.path).copy('$imgPath/$imgName');
      path = localImg.path;
      fileName = picImage.name.substring(60, 75);
      var getUrlPic;
      String setUrlPic = '';
      getUrlPic = await GoogleServices().uploadFirebaseStorage(path, fileName);
      setUrlPic = getUrlPic;
      SharedPreferences sp = await SharedPreferences.getInstance();
      if (sp.containsKey('userId') == true) {
        setState(() {
          userId = sp.getString('userId')!;
          showImageUser = setUrlPic;
        });
      }
      DocumentReference editImagePro = await FirebaseFirestore.instance
          .collection("user_account")
          .doc(userId);
      try {
        await editImagePro.update({
          "image": setUrlPic,
        });
        sp.setString('image', setUrlPic);
      } on FirebaseException catch (e) {
        print(e);
      }
    } else {
      return;
    }
  }

  @override
  void initState() {
    checkAndGetAndShowDataSp();
    //getDataCheckUser();
    super.initState();
  }

  checkAndGetAndShowDataSp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      showImageUser = sp.getString('image')!;
      txMail.text = sp.getString('email')!;
      txName.text = sp.getString('name')!;
      switch (sp.getString('sex')) {
        case '0':
          txSex.text = 'Male';
          break;
        case '1':
          txSex.text = 'FeMale';
          break;
        case '2':
          txSex.text = 'LGBT';
          break;
        default:
      }

      txBirthDate.text = sp.getString('birthdate')!;
    });

    //ตรวจสอบkey SharedPreferences
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
  }
 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 233, 233),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 80.0,
              ),
              child: SizedBox(
                height: 220,
                width: 220,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    showImageUser == ''
                        ? Container(
                            width: MediaQuery.of(context).size.width * 5.0,
                            height: MediaQuery.of(context).size.width * 5.0,
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
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.blueGrey,
                                width: 5.0,
                              ),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    showImageUser,
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
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  color: Color.fromARGB(255, 34, 184, 96),
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
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  color: Color.fromARGB(255, 209, 26, 72),
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
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 35,
                  child: TextField(
                    controller: txName,
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      prefixIcon: Icon(Icons.people),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 160,
                  height: 35,
                  child: TextField(
                    controller: txBirthDate,
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      prefixIcon: Icon(Icons.cake),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 35,
                  child: TextField(
                    controller: txMail,
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 120,
                  height: 35,
                  child: TextField(
                    controller: txSex,
                    readOnly: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                      ),
                      prefixIcon: SizedBox(
                        width: 15,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 5,
                              left: 3,
                              child: Icon(
                                Icons.female,
                              ),
                            ),
                            Positioned(
                              left: 10,
                              child: Icon(
                                Icons.male,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              color: Color.fromARGB(255, 181, 177, 177),
              height: 55.0,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileUI(),
                    ),
                  );
                },
                title: Text(
                  'Edit Profile',
                ),
                leading: Icon(
                  Icons.settings,
                  color: Colors.white60,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ),
            Container(
              color: Color.fromARGB(255, 236, 233, 233),
              height: 55.0,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoritePageUI(),
                    ),
                  );
                },
                title: Text(
                  'My Favorite',
                ),
                leading: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ),
            Container(
              color: Color.fromARGB(255, 181, 177, 177),
              height: 55.0,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordUI(),
                    ),
                  );
                },
                title: Text(
                  'Reset Password',
                ),
                leading: Icon(
                  Icons.key_outlined,
                  color: Colors.white60,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ),
            Container(
              color: Color.fromARGB(255, 234, 201, 201),
              height: 55.0,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPageUI(),
                    ),
                  );
                },
                title: Text(
                  'SignOut',
                ),
                leading: Text(
                  '',
                ),
                trailing: Icon(
                  Icons.exit_to_app,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } /* ); */
}

/*
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection("user_account")
          // .doc('H5sOkLyKbc5cpL5IdiQV')
          .doc(userId)
          .get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        Map<String, dynamic> userData =
            snapshot.data!.data() as Map<String, dynamic>;
        txBirthDate.text = userData['birthdate'];
        txMail.text = userData['email'];
        txName.text = userData['name'];
        switch (userData['sex']) {
          case '0':
            txSex.text = 'Male';
            break;
          case '1':
            txSex.text = 'Female';
            break;
          case '2':
            txSex.text = 'LGBT';
            break;
        }
        showImageUser = userData['image'];

        return Scaffold(
          backgroundColor: Color.fromARGB(255, 236, 233, 233),
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 80.0,
                  ),
                  child: SizedBox(
                    height: 220,
                    width: 220,
                    child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.expand,
                      children: [
                        showImageUser == ''
                            ? Container(
                                width: MediaQuery.of(context).size.width * 5.0,
                                height: MediaQuery.of(context).size.width * 5.0,
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
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blueGrey,
                                    width: 5.0,
                                  ),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        showImageUser,
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
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      color: Color.fromARGB(255, 34, 184, 96),
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
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      color: Color.fromARGB(255, 209, 26, 72),
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
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 35,
                      child: TextField(
                        controller: txName,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(
                              5.0,
                            ),
                          ),
                          prefixIcon: Icon(Icons.people),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 160,
                      height: 35,
                      child: TextField(
                        controller: txBirthDate,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(
                              5.0,
                            ),
                          ),
                          prefixIcon: Icon(Icons.cake),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 35,
                      child: TextField(
                        controller: txMail,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(
                              5.0,
                            ),
                          ),
                          prefixIcon: Icon(Icons.mail),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 120,
                      height: 35,
                      child: TextField(
                        controller: txSex,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.0,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(
                              5.0,
                            ),
                          ),
                          prefixIcon: SizedBox(
                            width: 15,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 5,
                                  left: 3,
                                  child: Icon(
                                    Icons.female,
                                  ),
                                ),
                                Positioned(
                                  left: 10,
                                  child: Icon(
                                    Icons.male,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  color: Color.fromARGB(255, 181, 177, 177),
                  height: 55.0,
                  child: ListTile(
                    onTap: () {
                      OtherServices().saveDataToSP(
                          txName.text,
                          int.parse(userData['sex']),
                          txBirthDate.text,
                          txMail.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileUI(),
                        ),
                      );
                    },
                    title: Text(
                      'Edit Profile',
                    ),
                    leading: Icon(
                      Icons.settings,
                      color: Colors.white60,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                    ),
                  ),
                ),
                Container(
                  color: Color.fromARGB(255, 236, 233, 233),
                  height: 55.0,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavoritePageUI(),
                        ),
                      );
                    },
                    title: Text(
                      'My Favorite',
                    ),
                    leading: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                    ),
                  ),
                ),
                Container(
                  color: Color.fromARGB(255, 181, 177, 177),
                  height: 55.0,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetPasswordUI(),
                        ),
                      );
                    },
                    title: Text(
                      'Reset Password',
                    ),
                    leading: Icon(
                      Icons.key_outlined,
                      color: Colors.white60,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                    ),
                  ),
                ),
                Container(
                  color: Color.fromARGB(255, 234, 201, 201),
                  height: 55.0,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPageUI(),
                        ),
                      );
                    },
                    title: Text(
                      'SignOut',
                    ),
                    leading: Text(
                      '',
                    ),
                    trailing: Icon(
                      Icons.exit_to_app,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

  }
*/

