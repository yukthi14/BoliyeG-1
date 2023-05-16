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

  getUserList() async {
    DataSnapshot userList = await ref.child(Strings.user).get();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var element in userList.children) {
      if (element.key != prefs.get(Strings.token)) {
        listName.add(element.value);
        listUserKey.add(element.key);
      }
    }
  }

  createChat(String token) async {
    await ref.child(Strings.msg).get().then((value) async {
      for (var element in value.children) {
        if (element.key != token) {
          await ref
              .child(Strings.msg)
              .child(token)
              .set({Strings.timeStamp: now});
        }
      }
    });
  }

  sendMassage(String msg, String msgToken, int type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ref.child(Strings.msg).child(msgToken).child(Strings.content).set({
      Strings.msg: msg,
      Strings.timeStamp: now,
      Strings.contentType: type,
      Strings.isSender: prefs.get(Strings.token)
    });
  }

  Future<List> getChats(String chatToken) async {
    List contentMassage = [];
    try {
      await ref.child(Strings.msg).get().then((value) async {
        for (var element in value.children) {
          contentMassage.add(element.child(Strings.content).value);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return contentMassage;
  }
}
