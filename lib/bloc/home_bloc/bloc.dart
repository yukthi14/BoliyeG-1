import 'package:boliye_g/bloc/home_bloc/home_event.dart';
import 'package:boliye_g/bloc/home_bloc/home_state.dart';
import 'package:boliye_g/services/is_internet_connected.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constant/strings.dart';
import '../../services/local_db.dart';

class HomeScreenBloc extends Bloc<HomeEvent, HomeState> {
  HomeScreenBloc() : super(HomeUserState()) {
    final Network network = Network();
    final DatabaseHelper databaseHelper = DatabaseHelper();
    on<HomeProfileEvent>((event, emit) async {
      usersStreaming.add(await databaseHelper.queryRecord());
      if (await network.checkConnection()) {
        emit(HomeUserState());
      } else {
        var value = await databaseHelper.queryRecord();
        print(value);
        emit(HomeUserWithNoInternetState());
      }
    });
  }
}
