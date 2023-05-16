import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMassage {
  final ref = FirebaseDatabase.instance.ref();
  getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') == null) {
      try {
        await FirebaseMessaging.instance.getToken().then((tokenValue) async {
          if (tokenValue.toString().isEmpty) {
            if (kDebugMode) {
              print("Error in generate token");
            }
          } else {
            prefs.setString("token", tokenValue!);
            await ref
                .child('users')
                .child(tokenValue)
                .set({'userName': 'vishwajeet'});
          }
        });
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }
}
