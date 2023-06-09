import 'package:boliye_g/bloc/bloc_event.dart';
import 'package:boliye_g/bloc/bloc_state.dart';
import 'package:boliye_g/services/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/strings.dart';

class ChatBlocks extends Bloc<ChatEvent, ChatState> {
  ChatBlocks() : super(SplashState()) {
    on<InitialEvent>((event, emit) async {
      try {
        final SharedPreferences preferences =
            await SharedPreferences.getInstance();
        if (preferences.getString(Strings.token) == null) {
          emit(IntroPage());
        } else {
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
  }
}
