import 'package:boliye_g/constant/color.dart';
import 'package:boliye_g/constant/strings.dart';
import 'package:boliye_g/dataBase/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:vibration/vibration.dart';

import '../constant/sizer.dart';

class NeonButton extends StatefulWidget {
  const NeonButton({Key? key}) : super(key: key);

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with TickerProviderStateMixin {
  late AnimationController _buttonController;
  late Animation _buttonAnimation;
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
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
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
        GestureDetector(
          onLongPress: () async {
            setState(() {
              audioColor = Colors.green;
            });
            final record = Record();
            try {
              if (await record.hasPermission()) {
                await record.start();
              }
              Vibration.vibrate(duration: 200);
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
                String? path = await record.stop();
                if (path!.isNotEmpty) {
                  firebaseVoiceMessage.sendAudio(path);
                }
                // final playStation = AudioPlayer(playerId: 'playAudio');
                // playStation.play(path!, isLocal: true);
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
            child: Icon(
              Icons.mic_outlined,
              color: audioColor,
              size: displayWidth(context) * 0.1,
            ),
          ),
        ),
        IconButton(
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
      ],
    );
  }
}
