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
              ? displayWidth(context) * 0.82
              : displayWidth(context) * 0,
          right: !isSender ? displayWidth(context) * 0.82 : 0),
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
    double w = size.width * 1;
    double h = size.height * 1;
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

class Envelope extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width * 1;
    double h = size.height * 1;
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
