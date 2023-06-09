import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:boliye_g/constant/color.dart';
import 'package:boliye_g/constant/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:record/record.dart';
import 'package:vibration/vibration.dart';

import '../constant/sizer.dart';
import '../services/firebase_storage.dart';

class NeonButton extends StatefulWidget {
  const NeonButton({
    Key? key,
    required this.msgToken,
    required this.revMsgToken,
    required this.myToken,
    required this.isPrivate,
  }) : super(key: key);
  final String msgToken;
  final String revMsgToken;
  final String myToken;
  final bool isPrivate;
  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with TickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  late AnimationController _buttonController;
  late Animation _buttonAnimation;
  bool isPlaying = false;
  bool isPause = false;
  String? path = '';
  int audioDuration = 0;
  Timer? _timer;

  @override
  void initState() {
    _buttonController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _buttonController.repeat(reverse: true);
    _buttonAnimation = Tween(begin: 0.0, end: 1.0).animate(_buttonController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();

    _buttonController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => audioDuration++);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () {
              setState(() {
                startAudioChat.value = false;
              });
            },
            icon: const Icon(
              Icons.keyboard,
              color: Colors.white,
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () {
              _timer?.cancel();
              path = '';
              audioDuration = 0;
            },
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white,
            ),
          ),
        ),
        GestureDetector(
          onLongPress: () async {
            setState(() {
              audioColor = Colors.green;
            });
            final record = Record();
            try {
              if (await record.hasPermission()) {
                Vibration.vibrate(duration: 200);
                await record.start();
                audioDuration = 0;
                _startTimer();
              }
            } catch (e) {
              if (kDebugMode) {
                print(e.toString());
              }
            }
          },
          onLongPressEnd: (LongPressEndDetails details) async {
            final record = Record();
            setState(() {
              audioColor = Colors.red;
            });
            try {
              if (await record.isRecording()) {
                _timer?.cancel();
                path = await record.stop();
              }
            } catch (e) {
              if (kDebugMode) {
                print(e.toString());
              }
            }
          },
          child: Container(
            height: 90,
            width: 90,
            margin: EdgeInsets.only(bottom: displayHeight(context) * 0.02),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: audioColor),
              color: AppColors.scaffoldColor,
              boxShadow: [
                BoxShadow(
                  color: audioColor,
                  blurRadius: _buttonAnimation.value * 5,
                  spreadRadius: (audioColor == Colors.green)
                      ? _buttonAnimation.value * radius
                      : _buttonAnimation.value * 5,
                ),
              ],
            ),
            child: (audioDuration == 0)
                ? Material(
                    color: Colors.transparent,
                    child: Icon(
                      Icons.mic_outlined,
                      color: audioColor,
                      size: displayWidth(context) * 0.1,
                    ),
                  )
                : _buildTimer(),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: IconButton(
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              _playAudio();
            },
          ),
        ),
        Material(
          color: Colors.transparent,
          child: IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () async {
              int now = DateTime.now().millisecondsSinceEpoch;
              if (path!.isNotEmpty) {
                firebaseVoiceMessage.sendAudio(
                  path: path!,
                  msgTokenAudio: widget.msgToken,
                  reverseTokenAudio: widget.revMsgToken,
                  typeAudio: Integers.audioType,
                  timeStamp: now.toString(),
                  myToken: widget.myToken,
                  isPrivate: widget.isPrivate,
                );
                path = '';
                audioDuration = 0;
              }
            },
            icon: const Icon(
              Icons.send_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(audioDuration ~/ 60);
    final String seconds = _formatNumber(audioDuration % 60);

    return Center(
        child: Text(
      '$minutes:$seconds',
      style:
          TextStyle(color: audioColor, fontSize: displayWidth(context) * 0.07),
    ));
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void _playAudio() async {
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
      (path!.isNotEmpty)
          ? {
              await audioPlayer.play(path!, isLocal: true),
              setState(() {
                isPlaying = true;
              })
            }
          : Fluttertoast.showToast(msg: Strings.noAudio);
    }
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }
}
