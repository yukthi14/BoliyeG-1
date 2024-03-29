abstract class ChatEvent {}

class InitialEvent extends ChatEvent {
  InitialEvent();
}

class SplashEvent extends ChatEvent {
  SplashEvent();
}

class SetUserEvent extends ChatEvent {
  String name;
  String image;
  SetUserEvent({required this.name, required this.image});
}

class UpdateUsersEvent extends ChatEvent {
  UpdateUsersEvent();
}

class EditProfileImage extends ChatEvent {
  String myToken;
  String image;
  EditProfileImage({required this.image, required this.myToken});
}

class UpLoadImage extends ChatEvent {
  String file;
  bool isPrivate;
  String reverseTokenImage;
  String timeStamp;
  String myToken;
  String msgTokenImage;
  UpLoadImage({
    required this.file,
    required this.msgTokenImage,
    required this.isPrivate,
    required this.reverseTokenImage,
    required this.timeStamp,
    required this.myToken,
  });
}
