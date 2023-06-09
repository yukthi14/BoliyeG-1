import 'dart:async';

import 'package:flutter/cupertino.dart';

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
  static const String errorMsg = 'Something went wrong';
  static const String searchBar = 'Search by name';
  static const String secretCode = 'Secret Code';
  static const String secretCodeKey = 'secretCode';
  static const String submittedSecretCodeKey = 'submittedSecretCode';
  static const String setSecretCode = 'Set Secret Code';
  static const String submitButton = 'Submit';
  static const String openEnvelope = 'Open';
  static const String pwdToast = 'Password Saved';
  static const String pwdSuggestion = 'Password should be of four digit';
  static const String invalidPwdToast = 'Invalid';
  static const String changePwd = 'Forgot Password';
  static const String textField = 'Type Something ...';
  static const String error = 'Error in generate token';
  static const String noAudio = 'Please Record Audio';
  static const String middleOfMessageToken = '@boliyegUser';
  static const String voice = 'VoiceRecording';
  static const String image = 'images';
  static const String logoMsg = 'Powered By ';
  static const String nextTextButton = 'Next';
  static const String profileName = 'Enter Your Name';
  static const String profileUserName = '@UserName';
  static const String profileMsgError = 'Please Enter UserName';
  static const String selectOption = 'Select Option';
  static const String cameraText = 'Camera';
  static const String galleryText = 'Gallery';
  static const String errorInternetMsg = 'No Internet Connection';
  static const String sadImg = 'assets/sad_img.gif';
  static const String shadow = 'assets/Ellipse8.png';
  static const String profileImg = 'profileImg';
}

class Integers {
  static const int audioType = 1;
  static const int textType = 0;
  static const int imgType = 2;
  static const int videoType = 3;
}

StreamController<bool> streamController = StreamController<bool>();

bool showEmoji = false;
bool openEnvelope = true;
bool opening = false;
bool showCheckIcon = false;
bool online = false;
bool isOpenAlertDialogBox = true;

bool animate = false;

ValueNotifier<bool> startAudioChat = ValueNotifier(false);
ValueNotifier<bool> startPrivateAudioChat = ValueNotifier(false);
ValueNotifier<bool> shoeEmoji = ValueNotifier(false);
int radius = 20;

ValueNotifier<String> deviceToken = ValueNotifier('');
