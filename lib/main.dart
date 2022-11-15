import 'package:flutter/material.dart';
import 'package:flutter_test_paichill/views/loginpage_ui.dart';
import 'package:flutter_test_paichill/views/rootpage_ui.dart';
import 'package:flutter_test_paichill/views/testface.dart';
import 'package:flutter_test_paichill/views/testupload.dart';

main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPageUI(),
    ),
  );
}
