abstract class HomeState {}

class InitialState extends HomeState {
  InitialState();
}

class HomeUserState extends HomeState {
  HomeUserState();
}

class HomeUserWithNoInternetState extends HomeState {
  HomeUserWithNoInternetState();
}

class Searching extends HomeState {
  Searching();
}
