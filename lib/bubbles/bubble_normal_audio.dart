import 'package:audioplayers/audioplayers.dart';
import 'package:boliye_g/constant/color.dart';
import 'package:boliye_g/constant/strings.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../utils/alert_dialog_box.dart';

const double BUBBLE_RADIUS_AUDIO = 16;

class AudioBar extends StatefulWidget {
  const AudioBar({
    Key? key,
    this.bubbleRadius = BUBBLE_RADIUS_AUDIO,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 12,
    ),
    required this.audioUrl,
    required this.myToken,
    required this.normalAudio,
  }) : super(key: key);
  final double bubbleRadius;
  final bool isSender;
  final bool normalAudio;
  final Color color;
  final bool tail;
  final bool sent;
  final bool delivered;
  final String audioUrl;
  final bool seen;
  final TextStyle textStyle;
  final String myToken;
  @override
  State<AudioBar> createState() => _AudioBarState();
}

class _AudioBarState extends State<AudioBar> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;
  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (widget.sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (widget.delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (widget.seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Row(
      children: <Widget>[
        widget.isSender
            ? const Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : Container(),
        Container(
          color: Colors.transparent,
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .8, maxHeight: 70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.bubbleRadius),
                  topRight: Radius.circular(widget.bubbleRadius),
                  bottomLeft: Radius.circular(widget.tail
                      ? widget.isSender
                          ? widget.bubbleRadius
                          : 0
                      : BUBBLE_RADIUS_AUDIO),
                  bottomRight: Radius.circular(widget.tail
                      ? widget.isSender
                          ? 0
                          : widget.bubbleRadius
                      : BUBBLE_RADIUS_AUDIO),
                ),
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      RawMaterialButton(
                        onPressed: _playAudio,
                        elevation: 1.0,
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        shape: const CircleBorder(),
                        child: (!openEnvelope || widget.normalAudio)
                            ? !isPlaying
                                ? const Icon(
                                    Icons.play_arrow,
                                    size: 30.0,
                                  )
                                : isLoading
                                    ? const CircularProgressIndicator()
                                    : isPause
                                        ? const Icon(
                                            Icons.play_arrow,
                                            size: 30.0,
                                          )
                                        : const Icon(
                                            Icons.pause,
                                            size: 30.0,
                                          )
                            : const Icon(
                                Icons.lock,
                                size: 30.0,
                              ),
                      ),
                      Expanded(
                        child: Slider(
                          min: 0.0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
                          activeColor: Colors.deepPurpleAccent,
                          inactiveColor: AppColors.scaffoldColor,
                          thumbColor: Colors.black,
                          onChanged: _changeSeek,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 8,
                    right: 25,
                    child: Text(
                      audioTimer(duration.inSeconds.toDouble(),
                          position.inSeconds.toDouble()),
                      style: widget.textStyle,
                    ),
                  ),
                  stateIcon != null && stateTick
                      ? Positioned(
                          bottom: 4,
                          right: 6,
                          child: stateIcon,
                        )
                      : const SizedBox(
                          width: 1,
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _changeSeek(double value) {
    setState(() {
      audioPlayer.seek(Duration(seconds: value.toInt()));
    });
  }

  void _playAudio() async {
    if (!openEnvelope || widget.normalAudio) {
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
        await audioPlayer.play(widget.audioUrl);
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
    } else {
      Navigator.push(
        context,
        PageTransition(
          duration: const Duration(
            milliseconds: 300,
          ),
          alignment: Alignment.center,
          type: PageTransitionType.rotate,
          child: AlertDialogBox(
            title: Strings.secretCode,
            buttonString: Strings.openEnvelope,
            suggestionString: Strings.changePwd,
            myToken: widget.myToken,
          ),
        ),
      );
    }
  }

  String audioTimer(double duration, double position) {
    return '${(duration ~/ 60).toInt()}:${(duration % 60).toInt().toString().padLeft(2, '0')}/${position ~/ 60}:${(position % 60).toInt().toString().padLeft(2, '0')}';
  }
}
