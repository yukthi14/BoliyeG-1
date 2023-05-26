import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:boliye_g/constant/color.dart';
import 'package:boliye_g/constant/sizer.dart';
import 'package:boliye_g/customPainter/shadowPaint.dart';
import 'package:boliye_g/dataBase/firebase_mass.dart';
import 'package:boliye_g/dataBase/is_internet_connected.dart';
import 'package:boliye_g/screens/private_chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

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
  ScrollController listScrollController = ScrollController();
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

  Offset dragGesturePosition = Offset(0.0, 0.0);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

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
                              child: const PrivateChat()));
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
                  height: displayHeight(context) * 0.3,
                  width: displayWidth(context) * 0.5,
                  margin: EdgeInsets.only(
                      top: displayHeight(context) * 0.25,
                      left: displayWidth(context) * 0.25),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      scale: 2,
                      image: AssetImage('assets/backGround.png'),
                    ),
                  ),
                ),
                // Container(
                //   height: displayHeight(context) * 0.05,
                //   width: displayWidth(context) * 0.2,
                //   margin: EdgeInsets.only(
                //       top: displayHeight(context) * 0.25,
                //       left: displayWidth(context) * 0.3),
                //   decoration: const BoxDecoration(
                //       color: Colors.black54,
                //       borderRadius: BorderRadius.horizontal(
                //           left: Radius.elliptical(300.0, 300.0),
                //           right: Radius.elliptical(300.0, 300.0))),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                      top: displayHeight(context) * 0.5,
                      left: displayWidth(context) * 0.26),
                  child: Opacity(
                    opacity: 0.9,
                    child: ClipPath(
                      clipper: BackGroundShadow(),
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 32.0,
                              spreadRadius: 100,
                              offset: Offset(0, 50),
                            )
                          ],
                        ),
                      ),
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
                                  (a, b) {
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
                    MessageBar(
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
}
