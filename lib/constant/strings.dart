import 'dart:async';

class Strings {
  static const String tittleName = 'BoliyeG';
  static const String avatarImage = 'assets/avatar.webp';
  static const String backGroundImage = 'assets/private_background.jpg';
  static const String token = 'token';
  static const String userName = 'userName';
  static const String user = 'users';
  static const String msg = 'message';
  static const String privateMsg = 'PrivateMessage';
  static const String profile = 'Profile';
  static const String aboutUs = 'About Us';
  static const String link = 'https://selfieera.com/#about';
  static const String setPassword = 'Set Password';
  static const String logOut = 'Log Out';
  static const String setting = 'Settings';
  static const String personalDetail = 'Personal Details';
  static const String timeStamp = 'TimeStamp';
  static const String content = 'content';
  static const String isSender = 'isSender';
  static const String contentType = 'type';
  static const String searchBar = 'Search by name';
  static const String secretCode = 'Secret Code';
  static const String textField = 'Type Something ...';
  static const String error = 'Error in generate token';
  static const String middleOfMessageToken = '@boliyegUser';
}

StreamController<bool> streamController = StreamController<bool>();

bool showEmoji = false;
bool drawer = false;
bool upperDrawer = false;
List listName = [];
List listUserKey = [];
bool privateKey = false;
bool openEnvelope = true;
bool opening = false;
bool showCheckIcon = false;
bool online = false;
bool magniFire = false;
bool animate = false;
String deviceToken = '';
