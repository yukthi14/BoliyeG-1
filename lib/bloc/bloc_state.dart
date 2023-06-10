abstract class ChatState {}

class SplashState extends ChatState {
  SplashState();
}

class IntroPage extends ChatState {
  IntroPage();
}

class HomeState extends ChatState {
  String name;
  String image;
  HomeState({required this.name, required this.image});
}
