import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:boliye_g/constant/color.dart';
import 'package:boliye_g/constant/sizer.dart';
import 'package:boliye_g/dataBase/firebase_mass.dart';
import 'package:boliye_g/dataBase/is_internet_connected.dart';
import 'package:boliye_g/encryption/encrypt_decrypt.dart';
import 'package:boliye_g/neonButton/neonButtons.dart';
import 'package:boliye_g/screens/private_chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bubbles/bubble_special_three.dart';
import '../constant/strings.dart';
import '../key_board_visibility/visiblity.dart';
import '../message_bar/message_bar.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen(
      {Key? key,
      this.onSend,
      required this.msgToken,
      required this.revMsgToken,
      required this.myToken})
      : super(key: key);
  final String msgToken;
  final String myToken;
  final String revMsgToken;
  final void Function(String)? onSend;

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen>
    with WidgetsBindingObserver {
  ValueNotifier<bool> cameraChange = ValueNotifier(false);
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;
  bool isKeyboardVisible = false;
  late ScrollController listScrollController = ScrollController();
  final ref = FirebaseDatabase.instance.ref('message');
  late KeyBoard _keyBoard;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    online = false;
    super.dispose();
  }

  @override
  void initState() {
    Network().checkConnection();
    _keyBoard = KeyBoard(context);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      setState(() {
        isKeyboardVisible = keyboardHeight > 0;
      });
      if (isKeyboardVisible) {
        _scrollList();
      }
    });
  }

  Offset dragGesturePosition = const Offset(0.0, 0.0);

  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      onPanUpdate: (DragUpdateDetails details) => setState(
        () {
          dragGesturePosition = details.localPosition;
        },
      ),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (showEmoji) {
              setState(() {
                showEmoji = !showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: AppBar(
              backgroundColor: AppColors.appBarColor,
              iconTheme: const IconThemeData(color: Colors.black),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: displayWidth(context) * 0.10,
                    height: displayHeight(context) * 0.10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(Strings.avatarImage)),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    Strings.userName,
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.05,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              duration: const Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              type: PageTransitionType.rotate,
                              child: PrivateChat(
                                msgToken: widget.msgToken,
                                revMsgToken: widget.revMsgToken,
                                myToken: deviceToken,
                              )));
                      setState(() {
                        if (privateKey = true) {
                          _showMyDialog();
                        }
                      });
                    },
                    icon: Icon(
                      Icons.lock_outline_rounded,
                      size: displayWidth(context) * 0.07,
                    )),
              ],
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.backgroundColor,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(children: [
                Container(
                  height: displayHeight(context) * 0.2,
                  width: displayWidth(context) * 0.2,
                  margin: EdgeInsets.only(
                      top: displayHeight(context) * 0.39,
                      left: displayWidth(context) * 0.4),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      scale: 1,
                      image: AssetImage('assets/Ellipse8.png'),
                    ),
                  ),
                ),
                Container(
                  height: displayHeight(context) * 0.3,
                  width: displayWidth(context) * 0.5,
                  margin: EdgeInsets.only(
                    top: displayHeight(context) * 0.25,
                    left: displayWidth(context) * 0.25,
                  ),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      scale: 3,
                      image: AssetImage('assets/backGround.png'),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<DatabaseEvent>(
                        stream: ref.onValue,
                        builder: (context, snapshot) {
                          var msg = [];
                          var msgTime = [];
                          var allChats = snapshot.data?.snapshot.children;
                          allChats?.forEach(
                            (element) {
                              if (element.key == widget.msgToken ||
                                  element.key == widget.revMsgToken) {
                                var childrenArray = element.children.toList();
                                childrenArray.sort(
                                  (b, a) {
                                    String key1 = a.key.toString();
                                    String key2 = b.key.toString();
                                    return key1.compareTo(key2);
                                  },
                                );

                                for (var element in childrenArray) {
                                  msgTime.add(element.key);
                                  msg.add(element.value);
                                }
                              }
                            },
                          );
                          return ListView.builder(
                            itemCount: msg.length + 1,
                            controller: listScrollController,
                            reverse: true,
                            padding: const EdgeInsets.only(bottom: 1),
                            itemBuilder: (context, index) {
                              if (index == msg.length) {
                                return SizedBox(
                                  height: displayHeight(context) * 0.04,
                                );
                              }

                              return Column(
                                crossAxisAlignment: (widget.myToken ==
                                        msg[index][Strings.isSender])
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                mainAxisAlignment: (widget.myToken ==
                                        msg[index][Strings.isSender])
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  BubbleSpecialThree(
                                    text: msg[index][Strings.msg],
                                    color: AppColors.bubbleSpecialThreeColor,
                                    tail: true,
                                    isSender: (widget.myToken ==
                                        msg[index][Strings.isSender]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0,
                                        right: 10,
                                        left: 13,
                                        bottom: 15),
                                    child: Text(
                                      DateFormat('jm').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(msgTime[index]))),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              displayWidth(context) * 0.03),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: startAudioChat,
                      builder: (context, value, _) {
                        return value
                            ? const NeonButton()
                            : MessageBar(
                                messageBarColor: Colors.black,
                                sendButtonColor: Colors.white,
                                onSend: (_) {
                                  FirebaseMassage().sendMassage(
                                    msg: _,
                                    msgToken: widget.msgToken,
                                    reverseToken: widget.revMsgToken,
                                    type: 0,
                                  );
                                  _scrollList();
                                },
                              );
                      },
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  _scrollList() {
    final position = listScrollController.position.maxScrollExtent;
    listScrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Widget _chatInput() {
  //   return Padding(
  //     padding: EdgeInsets.only(top: displayHeight(context) * 0.82),
  //     child:
  //   );
  // }

  Widget _image() {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 20.0,
        minWidth: 20.0,
      ),
      child: CachedNetworkImage(
        imageUrl: 'https://i.ibb.co/JCyT1kT/Asset-1.png',
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  void _changeSeek(double value) {
    setState(() {
      audioPlayer.seek(Duration(seconds: value.toInt()));
    });
  }

  void _playAudio() async {
    const url =
        'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3';
    if (isPause) {
      await audioPlayer.resume();
      setState(() {
        isPlaying = true;
        isPause = false;
      });
    } else if (isPlaying) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
        isPause = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      await audioPlayer.play(url);
      setState(() {
        isPlaying = true;
      });
    }

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
        isLoading = false;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        isPlaying = false;
        duration = const Duration();
        position = const Duration();
      });
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff8585a2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Text(
                  Strings.setSecretCode,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Icon(Icons.clear),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: controller,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.black,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xff626294),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.setString(Strings.secretCodeKey,
                    MessageEncryption().encryptText(controller.text).base64);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
