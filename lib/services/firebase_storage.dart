import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/strings.dart';
import 'firebase_mass.dart';

class FirebaseVoiceMessage {
  Reference references = FirebaseStorage.instance.ref();
  int now = DateTime.now().millisecondsSinceEpoch;

  sendAudio(
      {required String path,
      required String msgTokenAudio,
      required bool isPrivate,
      required String reverseTokenAudio,
      required String timeStamp,
      required String myToken,
      required int typeAudio}) async {
    File file = File(path);
    String recUrl = '';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Reference referenceDirVos = references.child(Strings.voice);
      await referenceDirVos
          .child(prefs.get(Strings.token).toString())
          .child(timeStamp)
          .putFile(file)
          .whenComplete(() async {
        var voiceRec = referenceDirVos
            .child(prefs.get(Strings.token).toString())
            .child(timeStamp);
        recUrl = await voiceRec.getDownloadURL();
        if (isPrivate) {
          firebaseMassage.sendPrivateMessage(
              msg: recUrl,
              msgToken: msgTokenAudio,
              reverseToken: reverseTokenAudio,
              myToken: myToken,
              type: typeAudio);
        } else {
          firebaseMassage.sendMessage(
            timeStamp: timeStamp,
            msg: recUrl,
            msgToken: msgTokenAudio,
            reverseToken: reverseTokenAudio,
            type: typeAudio,
            deviceToken: myToken,
          );
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}

final FirebaseVoiceMessage firebaseVoiceMessage = FirebaseVoiceMessage();
