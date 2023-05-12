import 'package:boliye_g/bubbles/bubble_special_three.dart';
import 'package:boliye_g/constant/sizer.dart';
import 'package:flutter/material.dart';

import '../constant/strings.dart';

class PrivateEnvelope extends StatefulWidget {
  final String msg;
  final Color coverColor;
  final Color topCoverColor;
  final bool sent;
  final bool delivered;
  final bool isSender;
  final Color textColor;
  final double fountSize;
  final Size envelopeSize;
  final bool seen;
  const PrivateEnvelope(
      {Key? key,
      required this.msg,
      required this.coverColor,
      required this.topCoverColor,
      required this.sent,
      required this.delivered,
      required this.isSender,
      required this.textColor,
      required this.fountSize,
      required this.envelopeSize,
      required this.seen})
      : super(key: key);

  @override
  State<PrivateEnvelope> createState() => _PrivateEnvelopeState();
}

class _PrivateEnvelopeState extends State<PrivateEnvelope>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.forward();
    _animation = Tween(begin: -0.75, end: 0.2).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    print(widget.isSender);

    if (openEnvelope) {
      return Padding(
        padding: EdgeInsets.only(
            top: displayHeight(context) * 0.015,
            left: widget.isSender
                ? displayWidth(context) * 0.82
                : displayWidth(context) * 0,
            right: !widget.isSender ? displayWidth(context) * 0.82 : 0),
        child: RotationTransition(
          alignment: Alignment.center,
          turns: _animation,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.9,
                child: ClipPath(
                  clipper: Envelope(),
                  child: Container(
                    alignment: widget.isSender
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    color: Colors.red,
                    height: 50,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.9,
                child: ClipPath(
                  clipper: EnvelopeCover(),
                  child: Container(
                    color: Colors.blue,
                    height: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Stack(children: [
        Padding(
          padding: EdgeInsets.only(
              top: displayHeight(context) * 0.015,
              left: widget.isSender
                  ? displayWidth(context) * 0.82
                  : displayWidth(context) * 0,
              right: !widget.isSender ? displayWidth(context) * 0.82 : 0),
          child: Stack(
            children: [
              Opacity(
                opacity: opening ? 0.5 : 0.9,
                child: ClipPath(
                  clipper: OpenEnvelope(),
                  child: Container(
                    alignment: widget.isSender
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    color: Colors.red,
                    height: 50,
                  ),
                ),
              ),
              Opacity(
                opacity: opening ? 0.5 : 0.9,
                child: ClipPath(
                  clipper: OpenEnvelopeCover(),
                  child: Container(
                    color: Colors.blue,
                    height: 50,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.2,
                child: ClipPath(
                  clipper: OpenEnvelopeBorder(),
                  child: Container(
                    color: Colors.black87,
                    height: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: displayWidth(context) * 0.1),
          child: BubbleSpecialThree(
            text: widget.msg,
            isSender: widget.isSender,
          ),
        )
      ]);
    }
  }
}

class EnvelopeCover extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path1 = Path();
    path1.moveTo(size.width * 0.2853659, size.height * 0.4101509);
    path1.cubicTo(
        size.width * 0.6195122,
        size.height * 0.4101509,
        size.width * 0.7836341,
        size.height * 0.4124280,
        size.width * 0.8950163,
        size.height * 0.4124280);
    path1.quadraticBezierTo(size.width * 0.9643252, size.height * 0.4261454,
        size.width * 0.8946016, size.height * 0.5061728);
    path1.lineTo(size.width * 0.6898049, size.height * 0.6869273);
    path1.quadraticBezierTo(size.width * 0.6110081, size.height * 0.7594513,
        size.width * 0.5277398, size.height * 0.6882853);
    path1.quadraticBezierTo(size.width * 0.4820081, size.height * 0.6605075,
        size.width * 0.2837398, size.height * 0.5061728);
    path1.quadraticBezierTo(size.width * 0.2119919, size.height * 0.4272977,
        size.width * 0.2853659, size.height * 0.4101509);
    path1.close();

    return path1;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class OpenEnvelope extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(size.width * 0.1773906, size.height * 0.5788606);
    path0.quadraticBezierTo(size.width * 0.1783088, size.height * 0.4944558,
        size.width * 0.2219611, size.height * 0.4964018);
    path0.lineTo(size.width * 0.8463315, size.height * 0.4931034);
    path0.quadraticBezierTo(size.width * 0.8912675, size.height * 0.4972923,
        size.width * 0.8917934, size.height * 0.5755622);
    path0.cubicTo(
        size.width * 0.8917934,
        size.height * 0.6580210,
        size.width * 0.8904652,
        size.height * 0.8254453,
        size.width * 0.8904652,
        size.height * 0.9079040);
    path0.quadraticBezierTo(size.width * 0.8901621, size.height * 0.9936941,
        size.width * 0.8472318, size.height * 0.9878561);
    path0.lineTo(size.width * 0.2219611, size.height * 0.9862069);
    path0.quadraticBezierTo(size.width * 0.1770073, size.height * 0.9920450,
        size.width * 0.1782820, size.height * 0.9037481);
    path0.cubicTo(
        size.width * 0.1780592,
        size.height * 0.8225262,
        size.width * 0.1780592,
        size.height * 0.8225262,
        size.width * 0.1773906,
        size.height * 0.5788606);
    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class OpenEnvelopeCover extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path1 = Path();
    path1.moveTo(size.width * 0.2219611, size.height * 0.4964018);
    path1.quadraticBezierTo(size.width * 0.1379546, size.height * 0.4604828,
        size.width * 0.2219611, size.height * 0.4109415);
    path1.cubicTo(
        size.width * 0.3039441,
        size.height * 0.3586297,
        size.width * 0.4123217,
        size.height * 0.2867751,
        size.width * 0.4902399,
        size.height * 0.2469640);
    path1.quadraticBezierTo(size.width * 0.5353363, size.height * 0.2068396,
        size.width * 0.5771613, size.height * 0.2466837);
    path1.quadraticBezierTo(size.width * 0.7560673, size.height * 0.3548696,
        size.width * 0.8473031, size.height * 0.4109910);
    path1.quadraticBezierTo(size.width * 0.9326646, size.height * 0.4659910,
        size.width * 0.8459482, size.height * 0.4931034);
    path1.lineTo(size.width * 0.2219611, size.height * 0.4964018);
    path1.close();

    return path1;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class OpenEnvelopeBorder extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path1 = Path();
    path1.moveTo(size.width * 0.2219611, size.height * 0.4964018);
    path1.quadraticBezierTo(size.width * 0.1636986, size.height * 0.4955772,
        size.width * 0.2219611, size.height * 0.5788606);
    path1.cubicTo(
        size.width * 0.2890397,
        size.height * 0.6192654,
        size.width * 0.4231969,
        size.height * 0.7000749,
        size.width * 0.4902756,
        size.height * 0.7404797);
    path1.quadraticBezierTo(size.width * 0.5340170, size.height * 0.7880914,
        size.width * 0.5785252, size.height * 0.7404797);
    path1.quadraticBezierTo(size.width * 0.7790924, size.height * 0.6155547,
        size.width * 0.8459482, size.height * 0.5739130);
    path1.quadraticBezierTo(size.width * 0.9028558, size.height * 0.4960555,
        size.width * 0.8459482, size.height * 0.4931034);
    path1.lineTo(size.width * 0.2219611, size.height * 0.4964018);
    path1.close();

    return path1;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Envelope extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(size.width * 0.2436016, size.height * 0.4801097);
    path0.cubicTo(
        size.width * 0.2442114,
        size.height * 0.7897805,
        size.width * 0.2442114,
        size.height * 0.7897805,
        size.width * 0.2444146,
        size.height * 0.8930041);
    path0.quadraticBezierTo(size.width * 0.2442114, size.height * 0.9622771,
        size.width * 0.2842520, size.height * 0.9574760);
    path0.lineTo(size.width * 0.8942114, size.height * 0.9597668);
    path0.quadraticBezierTo(size.width * 0.9345366, size.height * 0.9629630,
        size.width * 0.9335203, size.height * 0.8916324);
    path0.quadraticBezierTo(size.width * 0.9333171, size.height * 0.7884088,
        size.width * 0.9341463, size.height * 0.4787380);
    path0.quadraticBezierTo(size.width * 0.9343415, size.height * 0.4141564,
        size.width * 0.8928780, size.height * 0.4124417);
    path0.quadraticBezierTo(size.width * 0.7810894, size.height * 0.4124417,
        size.width * 0.2842520, size.height * 0.4101509);
    path0.quadraticBezierTo(size.width * 0.2425854, size.height * 0.4122085,
        size.width * 0.2436016, size.height * 0.4801097);
    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
