import 'package:boliye_g/bloc/bloc_event.dart';
import 'package:boliye_g/bloc/bloc_state.dart';
import 'package:boliye_g/services/firebase_mass.dart';
import 'package:boliye_g/services/local_db.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/strings.dart';

class ChatBlocks extends Bloc<ChatEvent, ChatState> {
  ChatBlocks() : super(SplashState()) {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    final FirebaseMassage firebaseMassage = FirebaseMassage();
    on<InitialEvent>((event, emit) async {
      try {
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        if (preferences.getString(Strings.token) == null) {
          emit(IntroPage());
        } else {
          var map = await databaseHelper.getPhoto(0);
          String? userName = preferences.getString(Strings.userName);
          emit(HomeState(name: userName!, image: map[0]['photoName']));
        }
      } catch (error) {
        if (kDebugMode) {
          print(error.toString());
        }
      }
    });
    on<UpLoadImage>((event, emit) async {
      if (event.isPrivate) {
        firebaseMassage.sendPrivateMessage(
            msg: event.file,
            msgToken: event.msgTokenImage,
            reverseToken: event.reverseTokenImage,
            myToken: event.myToken,
            type: 2);
      } else {
        firebaseMassage.sendMessage(
          msg: event.file,
          msgToken: event.msgTokenImage,
          reverseToken: event.reverseTokenImage,
          type: 2,
          deviceToken: event.myToken,
        );
      }
    });
    on<SetUserEvent>((event, emit) async {
      try {
        databaseHelper.insertUserDetails({
          DatabaseHelper.dbId: 0,
          DatabaseHelper.dbUserName: event.name,
          DatabaseHelper.dbUserImageFilePath: event.image
        });
        await firebaseMassage.getToken(
            userName: event.name, image: event.image);
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    });
    on<EditProfileImage>((event, emit) async {
      try {
        databaseHelper.updateUserImage(
            0, {DatabaseHelper.dbUserImageFilePath: event.image});
        firebaseMassage.setProfileImage(
            imgLink: event.image, deviceToken: event.myToken);
      } catch (e) {
        print(e.toString());
      }
    });
  }
}
