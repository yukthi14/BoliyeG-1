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

  setProfileImage({
    required String path,
    required String myToken,
  }) async {
    File file = File(path);
    String imgUrl = '';
    try {
      Reference imgRef = references.child(Strings.profileImg);
      await imgRef.child(myToken).putFile(file).whenComplete(() async {
        var imageReference = imgRef.child(myToken);
        imgUrl = await imageReference.getDownloadURL();
        firebaseMassage.setProfileImage(imgLink: imgUrl, deviceToken: myToken);
      });
    } catch (e) {
      print(e);
    }
  }

  sendImage({
    required String path,
    required String msgTokenImage,
    required bool isPrivate,
    required String reverseTokenImage,
    required String timeStamp,
    required String myToken,
  }) async {
    File file = File(path);
    String recUrl = '';
    try {
      Reference referenceDirVos = references.child(Strings.image);
      await referenceDirVos
          .child(myToken)
          .child(timeStamp)
          .putFile(file)
          .whenComplete(() async {
        var voiceRec = referenceDirVos.child(myToken).child(timeStamp);
        recUrl = await voiceRec.getDownloadURL();
        if (isPrivate) {
          firebaseMassage.sendPrivateMessage(
              msg: recUrl,
              msgToken: msgTokenImage,
              reverseToken: reverseTokenImage,
              myToken: myToken,
              type: 2);
        } else {
          firebaseMassage.sendMessage(
            timeStamp: timeStamp,
            msg: recUrl,
            msgToken: msgTokenImage,
            reverseToken: reverseTokenImage,
            type: 2,
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
