import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/strings.dart';

class FirebaseVoiceMessage {
  Reference references = FirebaseStorage.instance.ref();
  sendAudio(String path) async {
    File file = File(path);
    String recUrl = '';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Reference referenceDirVos = references.child(Strings.voice);
      print('heloooooooooooooooooooooooooooooooo');
      await referenceDirVos
          .child(prefs.get(Strings.token).toString())
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(file)
          .whenComplete(() async {
        print('gettingggggggggggggggggggggggggggggggg');
        recUrl = await referenceDirVos.getDownloadURL();
        print('get Hello;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;');
        print(recUrl);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}

final FirebaseVoiceMessage firebaseVoiceMessage = FirebaseVoiceMessage();
