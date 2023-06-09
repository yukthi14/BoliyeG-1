abstract class ChatEvent {}

class InitialEvent extends ChatEvent {
  InitialEvent();
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
