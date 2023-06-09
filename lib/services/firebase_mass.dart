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
  getToken({required String userName}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get(Strings.token) == null) {
      try {
        await FirebaseMessaging.instance.getToken().then((tokenValue) async {
          if (tokenValue.toString().isEmpty) {
            Fluttertoast.showToast(
              msg: Strings.errorMsg,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else {
            prefs.setString(Strings.token, tokenValue!);
            prefs.setString(Strings.userName, userName);
            await ref
                .child(Strings.user)
                .child(tokenValue)
                .set({Strings.userName: userName}).whenComplete(() =>
                    deviceToken.value = prefs.get(Strings.token).toString());
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
    deviceToken.value = prefs.get(Strings.token).toString();
  }

  sendMessage({
    required String msg,
    required String msgToken,
    String timeStamp = '',
    required String reverseToken,
    required int type,
    required String deviceToken,
  }) async {
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
          Strings.isSender: deviceToken,
        });
      } else if (msgList.contains(reverseToken)) {
        ref
            .child(Strings.msg)
            .child(reverseToken)
            .child((timeStamp == '') ? now.toString() : timeStamp)
            .set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: deviceToken
        });
      } else {
        ref
            .child(Strings.msg)
            .child(reverseToken)
            .child((timeStamp == '') ? now.toString() : timeStamp)
            .set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: deviceToken
        });
      }
    });
  }

  setPrivatePassword({required String pwd, required String deviceToken}) async {
    await ref
        .child(Strings.user)
        .child(deviceToken)
        .update({Strings.secretCodeKey: pwd}).whenComplete(
      () => Fluttertoast.showToast(
        msg: Strings.pwdToast,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      ),
    );
  }

  getPrivatePassword({required String deviceToken}) async {
    try {
      var userData = await ref.child(Strings.user).child(deviceToken).get();
      String password = userData.children
          .firstWhere((element) => element.key == Strings.secretCodeKey)
          .value
          .toString();
      return password;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  sendPrivateMessage(
      {required String msg,
      required String msgToken,
      required String reverseToken,
      String timeStamp = '',
      required String myToken,
      required int type}) async {
    List msgList = [];
    await ref.child(Strings.privateMsg).get().then((value) async {
      for (var element in value.children) {
        msgList.add(element.key);
      }
      if (msgList.contains(msgToken)) {
        ref
            .child(Strings.privateMsg)
            .child(msgToken)
            .child((timeStamp == '') ? now.toString() : timeStamp)
            .set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: myToken,
        });
      } else if (msgList.contains(reverseToken)) {
        ref
            .child(Strings.privateMsg)
            .child(reverseToken)
            .child((timeStamp == '') ? now.toString() : timeStamp)
            .set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: myToken,
        });
      } else {
        ref
            .child(Strings.privateMsg)
            .child(reverseToken)
            .child((timeStamp == '') ? now.toString() : timeStamp)
            .set({
          Strings.msg: msg,
          Strings.contentType: type,
          Strings.isSender: myToken,
        });
      }
    });
  }
}

final FirebaseMassage firebaseMassage = FirebaseMassage();
