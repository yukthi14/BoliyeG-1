import 'package:audioplayers/audioplayers.dart';
import 'package:boliye_g/constant/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../bubbles/bubble_special_three.dart';
import '../constant/strings.dart';
import '../envelope/private_envelope.dart';
import '../message_bar/message_bar.dart';

class PrivateChat extends StatefulWidget {
  const PrivateChat({Key? key}) : super(key: key);

  @override
  _PrivateChatState createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  ValueNotifier<bool> cameraChange = ValueNotifier(false);
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;

  final _chats = [
    {"isSender": true, "type": 0, "msg": "Hello There"},
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
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
                  color: Colors.black,
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
            ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (context, index) {
                  final chat = _chats.elementAt(index);
                  bool isSender = chat['isSender'] as bool;
                  String msg = chat['msg'] as String;
                  return PrivateEnvelope(
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
                  );
                }),
            MessageBar(
              messageBarColor: Colors.black,
              sendButtonColor: Colors.white,
              onSend: (_) {
                _chats.add({
                  "isSender": true,
                  "type": 0,
                  "msg": _,
                });
                setState(() {});
              },
              actions: [
                InkWell(
                  child: const Icon(
                    Icons.emoji_emotions_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onTap: () {
                    EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        // Do something when emoji is tapped
                      },
                      config: const Config(
                          columns: 7,
                          emojiSizeMax: 32.0,
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                          bgColor: Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          categoryIcons: CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.04,
                      right: MediaQuery.of(context).size.width * 0.02),
                  child: InkWell(
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 24,
                    ),
                    onTap: () async {
                      ImagePicker image = ImagePicker();
                      try {
                        XFile? filePath =
                            await image.pickImage(source: ImageSource.camera);
                        print(filePath);
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(
                //       left: MediaQuery.of(context).size.width * 0.02,
                //       right: MediaQuery.of(context).size.width * 0.02),
                //   child: InkWell(
                //     child: const Icon(
                //       Icons.image,
                //       color: Colors.white,
                //       size: 24,
                //     ),
                //     onTap: () async {
                //       ImagePicker image = ImagePicker();
                //       try {
                //         XFile? filePath = await image.pickImage(
                //             source: ImageSource.gallery);
                //         print(filePath);
                //       } catch (e) {
                //         print(e);
                //       }
                //     },
                //   ),
                // ),
              ],
            ),
          ],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
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
