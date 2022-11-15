import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../services/other.dart';

class ResetPasswordUI extends StatefulWidget {
  const ResetPasswordUI({Key? key}) : super(key: key);

  @override
  State<ResetPasswordUI> createState() => _ResetPasswordUIState();
}

class _ResetPasswordUIState extends State<ResetPasswordUI> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  TextEditingController txEmail = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Reset Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
      ),
      body: FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
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
                          left: 50.0,
                          right: 50.0,
                          top: 150,
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
                          left: 65.0,
                          right: 60.0,
                          top: 20.0,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 120,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () async {
                                //-------------------------
                                if (txEmail.text.length == 0) {
                                  OtherServices().showWarningDialog(
                                      context, 'กรุณาป้อนEmail');
                                } else {
                                  try {
                                    final auth = FirebaseAuth.instance;
                                    await auth
                                        .sendPasswordResetEmail(
                                            email: txEmail.text.trim())
                                        .then((value) =>
                                            Navigator.of(context).pop());
                                    print('success');
                                    /* Navigator.of(context).pop(); */
                                  } on FirebaseAuthException catch (e) {
                                    OtherServices().showWarningDialog(
                                        context, 'ระบบขัดข้องแจ้งAdmin');
                                    print(e);
                                  }
                                }
                              },
                              child: Text(
                                'Reset Pass',
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Scaffold();
        },
      ),
    );
  }
}
