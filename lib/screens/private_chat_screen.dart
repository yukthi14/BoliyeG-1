import 'package:audioplayers/audioplayers.dart';
import 'package:boliye_g/constant/sizer.dart';
import 'package:boliye_g/encryption/encrypt_decrypt.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../bubbles/bubble_special_three.dart';
import '../constant/strings.dart';
import '../customPainter/private_envelope.dart';
import '../dataBase/firebase_mass.dart';
import '../dialogBox/alert_dialog_box.dart';
import '../message_bar/message_bar.dart';

class PrivateChat extends StatefulWidget {
  const PrivateChat({
    Key? key,
    required this.msgToken,
    required this.revMsgToken,
    required this.myToken,
  }) : super(key: key);
  final String msgToken;
  final String revMsgToken;
  final String myToken;

  @override
  _PrivateChatState createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat>
    with TickerProviderStateMixin {
  ValueNotifier<bool> cameraChange = ValueNotifier(false);
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;
  ScrollController listScrollController = ScrollController();

  final ref = FirebaseDatabase.instance.ref(Strings.privateMsg);
  @override
  void dispose() {
    online = false;
    openEnvelope = false;
    opening = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(children: [
        Image.asset(
          Strings.backGroundImage,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fitHeight,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: displayWidth(context) * 0.10,
                  height: displayHeight(context) * 0.10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image:
                        DecorationImage(image: AssetImage(Strings.avatarImage)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  Strings.userName,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.05,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      openEnvelope = false;
                      opening = false;
                    });
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.lock_open_rounded,
                    size: displayWidth(context) * 0.07,
                  )),
            ],
          ),
          body: Stack(
            children: [
              SizedBox(
                  height: (MediaQuery.of(context).viewInsets.bottom == 0.0)
                      ? displayHeight(context) * 0.831
                      : displayHeight(context) * 0.54,
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
                        reverse: true,
                        itemCount: msg.length + 1,
                        controller: listScrollController,
                        itemBuilder: (context, index) {
                          if (index == msg.length) {
                            return SizedBox(
                              height: displayHeight(context) * 0.04,
                            );
                          }

                          return Column(
                            crossAxisAlignment:
                                (widget.myToken == msg[index][Strings.isSender])
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            mainAxisAlignment:
                                (widget.myToken == msg[index][Strings.isSender])
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          alignment: Alignment.center,
                                          type: PageTransitionType.rotate,
                                          child: const AlertDialogBox(
                                            title: Strings.secretCode,
                                            buttonString: Strings.openEnvelope,
                                            suggestionString: Strings.changePwd,
                                          )));
                                },
                                child: AnimatedContainer(
                                  margin: EdgeInsets.only(
                                    top: animate
                                        ? displayHeight(context) * 0.69
                                        : 0,
                                  ),
                                  duration: const Duration(milliseconds: 300),
                                  child: PrivateEnvelope(
                                    msg: MessageEncryption()
                                        .decryptText(msg[index][Strings.msg]),
                                    coverColor: Colors.red,
                                    topCoverColor: Colors.white,
                                    isSender: (widget.myToken ==
                                        msg[index][Strings.isSender]),
                                    textColor: Colors.black,
                                    fountSize: 15,
                                    envelopeSize: displaySize(context),
                                    sent: false,
                                    delivered: false,
                                    seen: false,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
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
                                          color: Colors.white,
                                          fontSize:
                                              displayWidth(context) * 0.03),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )),
              MessageBar(
                messageBarColor: Colors.black,
                sendButtonColor: Colors.white,
                onSend: (_) {
                  FirebaseMassage().sendPrivateMessage(
                    msg: MessageEncryption().encryptText(_).base64,
                    msgToken: widget.msgToken,
                    reverseToken: widget.revMsgToken,
                    type: 0,
                  );
                  setState(() {
                    animate = true;
                  });
                  Future.delayed(const Duration(milliseconds: 300))
                      .then((value) {
                    setState(() {
                      animate = false;
                    });
                  });
                  setState(() {
                    final position =
                        listScrollController.position.maxScrollExtent;
                    listScrollController.animateTo(position,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear);
                  });
                },
              ),
            ],
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ]),
    );
  }

  Widget _texing() {
    return const BubbleSpecialThree(
      text: "bubble special three with tail",
      color: Color(0xFFE8E8EE),
      tail: true,
      isSender: false,
    );
  }

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
