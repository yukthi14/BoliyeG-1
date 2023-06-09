abstract class ChatState {}

class SplashState extends ChatState {
  SplashState();
}

class IntroPage extends ChatState {
  IntroPage();
}

class HomeState extends ChatState {
  String name;
  HomeState({required this.name});
}
