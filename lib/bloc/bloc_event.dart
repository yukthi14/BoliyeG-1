abstract class ChatEvent {}

class InitialEvent extends ChatEvent {
  InitialEvent();
}

class SetUserEvent extends ChatEvent {
  String name;
  SetUserEvent({required this.name});
}

class EditProfile extends ChatEvent {
  String myToken;
  String name;
  String image;
  EditProfile({required this.image, required this.name, required this.myToken});
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
