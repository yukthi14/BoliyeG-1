import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../date_chips/date_chip.dart';
import '../message_bar/message_bar.dart';

class ChattingScreen extends StatefulWidget {

  const ChattingScreen({Key? key}) : super(key: key);

  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  ValueNotifier<bool> cameraChange = ValueNotifier(false);
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position =  const Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // BubbleNormalImage(
                //   id: 'id001',
                //   image: _image(),
                //   color: Colors.purpleAccent,
                //   tail: true,
                //   delivered: true,
                // ),
                // BubbleNormalAudio(
                //   color: Color(0xFFE8E8EE),
                //   duration: duration.inSeconds.toDouble(),
                //   position: position.inSeconds.toDouble(),
                //   isPlaying: isPlaying,
                //   isLoading: isLoading,
                //   isPause: isPause,
                //   onSeekChanged: _changeSeek,
                //  // onPlayPauseButtonClick: _playAudio,
                //   sent: true,
                // ),
                // BubbleNormal(
                //   text: 'bubble normal with tail',
                //   isSender: false,
                //   color: Color(0xFF1B97F3),
                //   tail: true,
                //   textStyle: TextStyle(
                //     fontSize: 20,
                //     color: Colors.white,
                //   ),
                // ),
                // BubbleNormal(
                //   text: 'bubble normal with tail',
                //   isSender: true,
                //   color: Color(0xFFE8E8EE),
                //   tail: true,
                //   sent: true,
                // ),
                // DateChip(
                //   date: new DateTime(now.year, now.month, now.day - 2),
                // ),
                // BubbleNormal(
                //   text: 'bubble normal without tail',
                //   isSender: false,
                //   color: Color(0xFF1B97F3),
                //   tail: false,
                //   textStyle: TextStyle(
                //     fontSize: 20,
                //     color: Colors.white,
                //   ),
                // ),
                // BubbleNormal(
                //   text: 'bubble normal without tail',
                //   color: Color(0xFFE8E8EE),
                //   tail: false,
                //   sent: true,
                //   seen: true,
                //   delivered: true,
                // ),
                // BubbleSpecialOne(
                //   text: 'bubble special one with tail',
                //   isSender: false,
                //   color: Color(0xFF1B97F3),
                //   textStyle: TextStyle(
                //     fontSize: 20,
                //     color: Colors.white,
                //   ),
                // ),
                // DateChip(
                //   date: new DateTime(now.year, now.month, now.day - 1),
                // ),
                // BubbleSpecialOne(
                //   text: 'bubble special one with tail',
                //   color: Color(0xFFE8E8EE),
                //   seen: true,
                // ),
                // BubbleSpecialOne(
                //   text: 'bubble special one without tail',
                //   isSender: false,
                //   tail: false,
                //   color: Color(0xFF1B97F3),
                //   textStyle: TextStyle(
                //     fontSize: 20,
                //     color: Colors.black,
                //   ),
                // ),
                // BubbleSpecialOne(
                //   text: 'bubble special one without tail',
                //   tail: false,
                //   color: Color(0xFFE8E8EE),
                //   sent: true,
                // ),
                // BubbleSpecialTwo(
                //   text: 'bubble special tow with tail',
                //   isSender: false,
                //   color: Color(0xFF1B97F3),
                //   textStyle: TextStyle(
                //     fontSize: 20,
                //     color: Colors.black,
                //   ),
                // ),
                Center(
                  child: DateChip(
                    date: now,
                  ),
                ),
                // BubbleSpecialTwo(
                //   text: 'bubble special tow with tail',
                //   isSender: true,
                //   color: Color(0xFFE8E8EE),
                //   sent: true,
                // ),
                // BubbleSpecialTwo(
                //   text: 'bubble special tow without tail',
                //   isSender: false,
                //   tail: false,
                //   color: Color(0xFF1B97F3),
                //   textStyle: TextStyle(
                //     fontSize: 20,
                //     color: Colors.black,
                //   ),
                // ),
                // BubbleSpecialTwo(
                //   text: 'bubble special tow without tail',
                //   tail: false,
                //   color: Color(0xFFE8E8EE),
                //   delivered: true,
                // ),
                // BubbleSpecialThree(
                //   text: 'bubble special three without tail',
                //   color: Color(0xFF1B97F3),
                //   tail: false,
                //   textStyle: TextStyle(color: Colors.white, fontSize: 16),
                // ),
                // BubbleSpecialThree(
                //   text: 'bubble special three with tail',
                //   color: Color(0xFF1B97F3),
                //   tail: true,
                //   textStyle: TextStyle(color: Colors.white, fontSize: 16),
                // ),
                // BubbleSpecialThree(
                //   text: "bubble special three without tail",
                //   color: Color(0xFFE8E8EE),
                //   tail: false,
                //   isSender: false,
                // ),
                // BubbleSpecialThree(
                //   text: "bubble special three with tail",
                //   color: Color(0xFFE8E8EE),
                //   tail: true,
                //   isSender: false,
                // ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
          MessageBar(
            messageBarColor: Colors.black,
            sendButtonColor: Colors.white,
            onSend: (_) => print(_),
            actions: [
              InkWell(
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
                onTap: () {},
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.02,
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
                      await image.pickImage(
                          source:
                          ImageSource.camera);
                      print(filePath);
                    } catch (e) {
                      print(e);
                    }

                  },
                ),
              ),
            ],
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

// Widget _image() {
//   return Container(
//     constraints: BoxConstraints(
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
//     audioPlayer.seek(new Duration(seconds: value.toInt()));
//   });
// }

// void _playAudio() async {
//   final url =
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
//       duration = new Duration();
//       position = new Duration();
//     });
//   });
// }
}