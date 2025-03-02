import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:priject3/screens/account.dart';
import 'package:priject3/screens/details.dart';
import 'package:priject3/screens/forgetpass.dart';
import 'package:priject3/screens/homeScreen.dart';
import 'package:priject3/screens/personaldetails.dart';
import 'package:priject3/screens/signin.dart';
import 'package:priject3/screens/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Signin());
  }
}
