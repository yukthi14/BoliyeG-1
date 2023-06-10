import 'package:boliye_g/bloc/bloc_event.dart';
import 'package:boliye_g/bloc/bloc_state.dart';
import 'package:boliye_g/services/firebase_mass.dart';
import 'package:boliye_g/services/firebase_storage.dart';
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
          print(map);
          String? userName = preferences.getString(Strings.userName);
          emit(HomeState(name: userName!));
        }
      } catch (error) {
        if (kDebugMode) {
          print(error.toString());
        }
      }
    });
    on<UpLoadImage>((event, emit) async {
      firebaseVoiceMessage.sendImage(
        path: event.file,
        msgTokenImage: event.msgTokenImage,
        isPrivate: event.isPrivate,
        reverseTokenImage: event.reverseTokenImage,
        timeStamp: event.timeStamp,
        myToken: event.myToken,
      );
    });
    on<SetUserEvent>((event, emit) {
      firebaseMassage.getToken(userName: event.name);
      emit(HomeState(name: event.name));
    });
    on<EditProfile>((event, emit) {
      if (event.name == '' && event.image.isNotEmpty) {
        try {
          databaseHelper.updateUserImage(
              0, {DatabaseHelper.dbUserImageFilePath: event.image});
          firebaseMassage.setProfileImage(
              imgLink: event.image, deviceToken: event.myToken);
        } catch (e) {
          print(e.toString());
        }
        emit(HomeState(name: event.name));
      } else if (event.image == '' && event.name.isNotEmpty) {}
    });
  }
}
