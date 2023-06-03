import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    deviceToken = prefs.get(Strings.token).toString();
  }

  sendMessage({
    required String msg,
    required String msgToken,
    String timeStamp = '',
    required String reverseToken,
    required int type,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List msgList = [];
    await ref.child(Strings.msg).get().then((value) async {
      for (var element in value.children) {
        msgList.add(element.key);
      }
      if (msgList.contains(msgToken)) {
        ref
            .child(Strings.msg)
            .child(msgToken)
            .child((timeStamp == '') ? now.toString() : timeStamp)
            .set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: prefs.get(Strings.token)
        });
      } else if (msgList.contains(reverseToken)) {
        ref
            .child(Strings.msg)
            .child(reverseToken)
            .child((timeStamp == '') ? now.toString() : timeStamp)
            .set({
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

  setPrivatePassword({required String pwd}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await ref
        .child(Strings.user)
        .child(prefs.get(Strings.token).toString())
        .update({Strings.secretCodeKey: pwd});
    Fluttertoast.showToast(
      msg: Strings.pwdToast,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<String> getPrivatePassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = await ref
        .child(Strings.user)
        .child(prefs.get(Strings.token).toString())
        .get();
    String password = userData.children
        .firstWhere((element) => element.key == Strings.secretCodeKey)
        .value
        .toString();
    return password;
  }

  sendPrivateMessage(
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
        ref
            .child(Strings.privateMsg)
            .child(msgToken)
            .child(now.toString())
            .set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: prefs.get(Strings.token)
        });
      } else if (msgList.contains(reverseToken)) {
        ref
            .child(Strings.privateMsg)
            .child(reverseToken)
            .child(now.toString())
            .set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: prefs.get(Strings.token)
        });
      } else {
        ref
            .child(Strings.privateMsg)
            .child(reverseToken)
            .child(now.toString())
            .set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: prefs.get(Strings.token)
        });
      }
    });
  }
}

final FirebaseMassage firebaseMassage = FirebaseMassage();
