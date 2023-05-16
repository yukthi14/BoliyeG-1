import 'package:audioplayers/audioplayers.dart';
import 'package:boliye_g/constant/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../bubbles/bubble_special_three.dart';
import '../constant/strings.dart';
import '../envelope/private_envelope.dart';
import '../message_bar/message_bar.dart';

class PrivateChat extends StatefulWidget {
  const PrivateChat({Key? key}) : super(key: key);

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

  final _chats = [
    {"isSender": false, "type": 0, "msg": "Hello There", "animate": false},
  ];

  @override
  void dispose() {
    setState(() {
      online = false;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
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
                    : displayHeight(context) * 0.46,
                child: ListView.builder(
                  itemCount: _chats.length,
                  controller: listScrollController,
                  itemBuilder: (context, index) {
                    final chat = _chats.elementAt(index);
                    bool isSender = chat['isSender'] as bool;
                    bool animate = chat['animate'] as bool;
                    String msg = chat['msg'] as String;
                    return InkWell(
                      onTap: () {
                        _showMyDialog();
                      },
                      child: AnimatedContainer(
                        margin: EdgeInsets.only(
                          top: animate ? displayHeight(context) * 0.69 : 0,
                        ),
                        duration: const Duration(milliseconds: 300),
                        child: PrivateEnvelope(
                          msg: msg,
                          coverColor: Colors.redAccent,
                          topCoverColor: Colors.white,
                          isSender: isSender,
                          textColor: Colors.black,
                          fountSize: 15,
                          envelopeSize: displaySize(context),
                          sent: false,
                          delivered: false,
                          seen: false,
                        ),
                      ),
                    );
                  },
                ),
              ),
              MessageBar(
                messageBarColor: Colors.black,
                sendButtonColor: Colors.white,
                onSend: (_) {
                  _chats.add(
                      {"isSender": true, "type": 0, "msg": _, "animate": true});
                  Future.delayed(const Duration(milliseconds: 300))
                      .then((value) {
                    setState(() {
                      for (var i = 0; i < _chats.length; i++) {
                        if (_chats[i]["animate"] == true) {
                          _chats[i]["animate"] = false;
                        }
                      }
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
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              Strings.secretCode,
              style: TextStyle(color: Colors.black),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Disclose'),
              onPressed: () {
                setState(() {
                  openEnvelope = !openEnvelope;
                });
                Future.delayed(
                  const Duration(milliseconds: 300),
                ).then((value) {
                  setState(() {
                    opening = !opening;
                  });
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
