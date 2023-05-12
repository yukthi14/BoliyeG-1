import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:boliye_g/constant/sizer.dart';
import 'package:boliye_g/screens/private_chat_screen.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import '../bubbles/bubble_special_three.dart';
import '../constant/strings.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({Key? key}) : super(key: key);

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  ValueNotifier<bool> cameraChange = ValueNotifier(false);
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;
  ScrollController listScrollController = ScrollController();

  final _chats = [
    {"isSender": false, "type": 0, "msg": "Hello There"},
  ];

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

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
            backgroundColor: Colors.grey,
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
            body: Stack(
              children: [
                SizedBox(
                  height: (MediaQuery.of(context).viewInsets.bottom == 0.0)
                      ? displayHeight(context) * 0.831
                      : displayHeight(context) * 0.46,
                  child: ListView.builder(
                      itemCount: _chats.length,
                      controller: listScrollController,
                      padding: EdgeInsets.only(
                          bottom: displayHeight(context) * 0.05),
                      itemBuilder: (context, index) {
                        final chat = _chats.elementAt(index);
                        bool isSender = chat['isSender'] as bool;
                        String msg = chat['msg'] as String;
                        return BubbleSpecialThree(
                          text: msg,
                          color: const Color(0xFFE8E8EE),
                          tail: true,
                          isSender: isSender,
                        );
                      }),
                ),
                // MessageBar(
                //   messageBarColor: Colors.black,
                //   sendButtonColor: Colors.white,
                //   onSend: (_) {
                //     _chats.add({
                //       "isSender": true,
                //       "type": 0,
                //       "msg": _,
                //     });
                //     setState(() {
                //       final position =
                //           listScrollController.position.maxScrollExtent;
                //       listScrollController.animateTo(
                //         position,
                //         duration: const Duration(milliseconds: 300),
                //         curve: Curves.linear,
                //       );
                //     });
                //   },
                // ),
                SizedBox(
                  child: Column(
                    children: [
                      _chatInput(),
                      if (showEmoji)
                        SizedBox(
                          height: displayHeight(context) * 0.31,
                          child: EmojiPicker(
                            textEditingController: _textController,
                            config: Config(
                              bgColor: Colors.white,
                              columns: 9,
                              emojiSizeMax:
                                  20 * (Platform.isAndroid ? 1.30 : 1.0),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            // This trailing comma makes auto-formatting nicer for build methods.
          ),
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.only(top: displayHeight(context) * 0.82),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          showEmoji = !showEmoji;
                        });
                      },
                      icon: const Icon(Icons.emoji_emotions_rounded)),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (showEmoji) {
                          setState(() {
                            showEmoji = !showEmoji;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: Strings.textField,
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // IconButton(
                  //     onPressed: () async {
                  //       ImagePicker image = ImagePicker();
                  //       try {
                  //         XFile? filePath = await image.pickImage(
                  //             source: ImageSource.gallery);
                  //         if (kDebugMode) {
                  //           print(filePath);
                  //         }
                  //       } catch (e) {
                  //         if (kDebugMode) {
                  //           print(e);
                  //         }
                  //       }
                  //     },
                  //     icon: const Icon(Icons.photo)),
                  IconButton(
                      onPressed: () async {
                        ImagePicker image = ImagePicker();
                        try {
                          XFile? filePath =
                              await image.pickImage(source: ImageSource.camera);
                          if (kDebugMode) {
                            print(filePath);
                          }
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      },
                      icon: const Icon(Icons.camera_alt_rounded)),
                  SizedBox(
                    width: displayWidth(context) * 0.02,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              _chats.add({
                "isSender": true,
                "type": 0,
                "msg": '',
              });
              setState(() {
                final position = listScrollController.position.maxScrollExtent;
                listScrollController.animateTo(
                  position,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                );
              });
            },
            minWidth: 0,
            padding: EdgeInsets.only(
                top: displayHeight(context) * 0.01,
                right: displayWidth(context) * 0.02,
                left: displayWidth(context) * 0.03,
                bottom: displayHeight(context) * 0.01),
            shape: const CircleBorder(),
            color: Colors.white,
            child: Icon(
              Icons.send,
              size: displayWidth(context) * 0.07,
            ),
          )
        ],
      ),
    );
  }

// Widget _image() {
//   return Container(
//     constraints: const BoxConstraints(
//       minHeight: 20.0,
//       minWidth: 20.0,
//     ),
//     child: CachedNetworkImage(
//       imageUrl: 'https://i.ibb.co/JCyT1kT/Asset-1.png',
//       progressIndicatorBuilder: (context, url, downloadProgress) =>
//           CircularProgressIndicator(value: downloadProgress.progress),
//       errorWidget: (context, url, error) => const Icon(Icons.error),
//     ),
//   );
// }

// void _changeSeek(double value) {
//   setState(() {
//     audioPlayer.seek(Duration(seconds: value.toInt()));
//   });
// }

// void _playAudio() async {
//   const url =
//       'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3';
//   if (isPause) {
//     await audioPlayer.resume();
//     setState(() {
//       isPlaying = true;
//       isPause = false;
//     });
//   } else if (isPlaying) {
//     await audioPlayer.pause();
//     setState(() {
//       isPlaying = false;
//       isPause = true;
//     });
//   } else {
//     setState(() {
//       isLoading = true;
//     });
//     await audioPlayer.play(url);
//     setState(() {
//       isPlaying = true;
//     });
//   }
//
//   audioPlayer.onDurationChanged.listen((Duration d) {
//     setState(() {
//       duration = d;
//       isLoading = false;
//     });
//   });
//   audioPlayer.onAudioPositionChanged.listen((Duration p) {
//     setState(() {
//       position = p;
//     });
//   });
//   audioPlayer.onPlayerCompletion.listen((event) {
//     setState(() {
//       isPlaying = false;
//       duration = const Duration();
//       position = const Duration();
//     });
//   });
// }
}
