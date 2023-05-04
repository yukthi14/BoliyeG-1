import 'package:boliye_g/constant/sizer.dart';
import 'package:flutter/material.dart';

class PrivateEnvelope extends StatelessWidget {
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
  const PrivateEnvelope({
    Key? key,
    required this.msg,
    required this.coverColor,
    required this.topCoverColor,
    required this.isSender,
    required this.textColor,
    required this.fountSize,
    required this.envelopeSize,
    required this.sent,
    required this.delivered,
    required this.seen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }
    print(isSender);

    return Padding(
      padding: EdgeInsets.only(
          left: isSender
              ? displayWidth(context) * 0.85
              : displayWidth(context) * 0.015,
          top: displayHeight(context) * 0.01),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.9,
            child: ClipPath(
              clipper: Envelope(),
              child: Container(
                alignment: isSender ? Alignment.topRight : Alignment.topLeft,
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
    );
  }
}

class EnvelopeCover extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(50, 0);
    path.lineTo(25, 12.5);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Envelope extends CustomClipper<Path> {
  // final Alignment alignment;
  // const Envelope({required this.alignment});

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, 30);
    path.lineTo(50, 30);
    path.lineTo(50, 0);
    path.lineTo(25, 12.5);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
