import 'package:boliye_g/firebase/firebase_mass.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'screens/homepage.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.getInitialMessage();
    var status = await Permission.notification.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.notification,
      ].request();
      print(statuses);
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseMassage ob = FirebaseMassage();
    ob.setToken();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
