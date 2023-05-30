import 'package:boliye_g/constant/color.dart';
import 'package:boliye_g/constant/strings.dart';
import 'package:flutter/material.dart';
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
          onLongPress: () {
            setState(() {
              audioColor = Colors.green;
            });
            Vibration.vibrate(duration: 200);
          },
          onLongPressEnd: (LongPressEndDetails details) {
            setState(() {
              audioColor = Colors.red;
            });
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
