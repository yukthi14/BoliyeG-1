import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:boliye_g/bubbles/bubble_normal_audio.dart';
import 'package:boliye_g/constant/color.dart';
import 'package:boliye_g/constant/sizer.dart';
import 'package:boliye_g/screens/private_chat_screen.dart';
import 'package:boliye_g/services/firebase_mass.dart';
import 'package:boliye_g/services/is_internet_connected.dart';
import 'package:boliye_g/utils/neonButtons.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bubbles/bubble_normal_image.dart';
import '../bubbles/bubble_special_three.dart';
import '../constant/strings.dart';
import '../services/visiblity.dart';
import '../utils/alert_dialog_box.dart';
import '../utils/message_bar.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen(
      {Key? key,
      this.onSend,
      required this.msgToken,
      required this.revMsgToken,
      required this.myToken,
      required this.name,
      required this.image})
      : super(key: key);
  final String msgToken;
  final String myToken;
  final String revMsgToken;
  final String name;
  final String image;
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
  String audioUrl = '';
  late ScrollController listScrollController = ScrollController();
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
      if (isKeyboardVisible && isOpenAlertDialogBox) {
        _scrollList();
      }
    });
  }

  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: MemoryImage(base64Decode(widget.image))),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: displayWidth(context) * 0.05,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      if (prefs.getBool(Strings.submittedSecretCodeKey) ==
                          null) {
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: const Duration(milliseconds: 300),
                            alignment: Alignment.center,
                            type: PageTransitionType.rotate,
                            child: AlertDialogBox(
                              title: Strings.setSecretCode,
                              buttonString: Strings.submitButton,
                              suggestionString: Strings.changePwd,
                              myToken: deviceToken.value,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: const Duration(milliseconds: 300),
                            alignment: Alignment.center,
                            type: PageTransitionType.rotate,
                            child: PrivateChat(
                              msgToken: widget.msgToken,
                              revMsgToken: widget.revMsgToken,
                              myToken: widget.myToken,
                            ),
                          ),
                        );
                      }
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
                Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<DatabaseEvent>(
                        stream:
                            FirebaseDatabase.instance.ref(Strings.msg).onValue,
                        builder: (context, snapshot) {
                          List<dynamic> msg = [];
                          List<dynamic> msgTime = [];
                          Iterable<DataSnapshot>? allChats =
                              snapshot.data?.snapshot.children;
                          allChats?.forEach(
                            (element) {
                              if (element.key == widget.msgToken ||
                                  element.key == widget.revMsgToken) {
                                List<DataSnapshot> childrenArray =
                                    element.children.toList();
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
                          if (msgTime.isNotEmpty) {
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
                                if (msg[index][Strings.contentType] ==
                                    Integers.textType) {
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
                                        color:
                                            AppColors.bubbleSpecialThreeColor,
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
                                          DateFormat('jm').format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  int.parse(msgTime[index]))),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  displayWidth(context) * 0.03),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (msg[index][Strings.contentType] ==
                                    Integers.audioType) {
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
                                      AudioBar(
                                        color: const Color(0xFFE8E8EE),
                                        tail: true,
                                        isSender: (widget.myToken ==
                                            msg[index][Strings.isSender]),
                                        audioUrl: msg[index][Strings.msg],
                                        myToken: widget.myToken,
                                        normalAudio: true,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0,
                                            right: 10,
                                            left: 13,
                                            bottom: 15),
                                        child: Text(
                                          DateFormat('jm').format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  int.parse(msgTime[index]))),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  displayWidth(context) * 0.03),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (msg[index][Strings.contentType] ==
                                    Integers.textType) {
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
                                        color:
                                            AppColors.bubbleSpecialThreeColor,
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
                                          DateFormat('jm').format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  int.parse(msgTime[index]))),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  displayWidth(context) * 0.03),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (msg[index][Strings.contentType] ==
                                    Integers.imgType) {
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
                                      BubbleNormalImage(
                                        id: index.toString(),
                                        imgLink: msg[index][Strings.msg],
                                        isSender: (widget.myToken ==
                                            msg[index][Strings.isSender]),
                                        tail: true,
                                        myToken: widget.myToken,
                                        isPrivate: false,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0,
                                            right: 10,
                                            left: 13,
                                            bottom: 15),
                                        child: Text(
                                          DateFormat('jm').format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  int.parse(msgTime[index]))),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  displayWidth(context) * 0.03),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            );
                          } else {
                            return Stack(children: [
                              Container(
                                height: displayHeight(context) * 0.2,
                                width: displayWidth(context) * 0.2,
                                margin: EdgeInsets.only(
                                    top: displayHeight(context) * 0.39,
                                    left: displayWidth(context) * 0.16),
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
                                  left: displayWidth(context) * 0.01,
                                ),
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    scale: 3,
                                    image: AssetImage('assets/backGround.png'),
                                  ),
                                ),
                              ),
                            ]);
                          }
                        },
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: startAudioChat,
                      builder: (context, value, _) {
                        return value
                            ? NeonButton(
                                msgToken: widget.msgToken,
                                revMsgToken: widget.revMsgToken,
                                myToken: widget.myToken,
                                isPrivate: false,
                              )
                            : MessageBar(
                                messageBarColor: Colors.black,
                                sendButtonColor: Colors.white,
                                onSend: (_) {
                                  FirebaseMassage().sendMessage(
                                    msg: _,
                                    msgToken: widget.msgToken,
                                    reverseToken: widget.revMsgToken,
                                    type: 0,
                                    deviceToken: widget.myToken,
                                  );
                                  // _scrollList();
                                },
                                myToken: widget.myToken,
                                isPrivate: false,
                                msgTokenImage: widget.msgToken,
                                revMsgTokenImage: widget.revMsgToken,
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
}
