import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test_paichill/services/google_services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TestUpload extends StatefulWidget {
  const TestUpload({Key? key}) : super(key: key);

  @override
  State<TestUpload> createState() => _TestUploadState();
}

class _TestUploadState extends State<TestUpload> {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpg']);

                if (result == null) {
                  print('file not found');
                }

                final path = result?.files.single.path;
                final fileName = result?.files.single.name;
                print(path);
                print(fileName);

                GoogleServices().uploadFirebaseStorage(path!, fileName!);
              },
              child: Text('upload'),
            ),
          ),
        ],
      ),
    );
  }
}
