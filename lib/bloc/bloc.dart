import 'package:boliye_g/bloc/bloc_event.dart';
import 'package:boliye_g/bloc/bloc_state.dart';
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
        (preferences.getString(Strings.token) == null)
            ? emit(IntroPage())
            : emit(HomeState());
      } catch (error) {
        if (kDebugMode) {
          print(error.toString());
        }
      }
    });
  }
}
