import 'package:boliye_g/bloc/home_bloc/home_event.dart';
import 'package:boliye_g/bloc/home_bloc/home_state.dart';
import 'package:boliye_g/services/is_internet_connected.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenBloc extends Bloc<HomeEvent, HomeState> {
  HomeScreenBloc() : super(HomeUserState()) {
    final Network network = Network();
    on<HomeProfileEvent>((event, emit) async {
      if (await network.checkConnection()) {
        emit(HomeUserState());
      } else {
        emit(HomeUserWithNoInternetState());
      }
    });
  }
}
