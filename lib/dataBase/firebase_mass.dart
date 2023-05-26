import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/strings.dart';

class FirebaseMassage {
  final ref = FirebaseDatabase.instance.ref();
  int now = DateTime.now().millisecondsSinceEpoch;
  getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get(Strings.token) == null) {
      try {
        await FirebaseMessaging.instance.getToken().then((tokenValue) async {
          if (tokenValue.toString().isEmpty) {
            if (kDebugMode) {
              print(Strings.error);
            }
          } else {
            prefs.setString(Strings.token, tokenValue!);
            await ref
                .child(Strings.user)
                .child(tokenValue)
                .set({Strings.userName: 'vishwajeet'});
          }
        });
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }

  setToken() async {
    DataSnapshot userList = await ref.child(Strings.user).get();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceToken = prefs.get(Strings.token).toString();
  }

  sendMassage(
      {required String msg,
      required String msgToken,
      required String reverseToken,
      required int type}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List msgList = [];
    await ref.child(Strings.msg).get().then((value) async {
      for (var element in value.children) {
        msgList.add(element.key);
      }
      if (msgList.contains(msgToken)) {
        ref.child(Strings.msg).child(msgToken).child(now.toString()).set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: prefs.get(Strings.token)
        });
      } else if (msgList.contains(reverseToken)) {
        ref.child(Strings.msg).child(reverseToken).child(now.toString()).set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: prefs.get(Strings.token)
        });
      } else {
        ref.child(Strings.msg).child(reverseToken).child(now.toString()).set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: prefs.get(Strings.token)
        });
      }
    });
  }

  sendPrivateMassage(
      {required String msg,
      required String msgToken,
      required String reverseToken,
      required int type}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List msgList = [];
    await ref.child(Strings.privateMsg).get().then((value) async {
      for (var element in value.children) {
        msgList.add(element.key);
      }
      if (msgList.contains(msgToken)) {
        ref.child(Strings.msg).child(msgToken).child(now.toString()).set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: prefs.get(Strings.token)
        });
      } else if (msgList.contains(reverseToken)) {
        ref.child(Strings.msg).child(reverseToken).child(now.toString()).set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: prefs.get(Strings.token)
        });
      } else {
        ref.child(Strings.msg).child(reverseToken).child(now.toString()).set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: prefs.get(Strings.token)
        });
      }
    });
  }
}