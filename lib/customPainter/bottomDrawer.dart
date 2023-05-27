import 'package:flutter/cupertino.dart';

class BottomDrawer extends CustomClipper<Path> {
  final Alignment alignment;

  BottomDrawer({required this.alignment});
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    final startPoint = alignment.alongSize(size);
    path0.moveTo(size.width * 0.2716375, size.height * 0.9941289);
    path0.quadraticBezierTo(size.width * 0.2716375, size.height * 1.0362551,
        size.width * 0.2716375, size.height * 0.9941289);
    path0.quadraticBezierTo(size.width * 0.3255250, size.height * 0.9185597,
        size.width * 0.4201375, size.height * 0.9129767);
    path0.quadraticBezierTo(size.width * 0.4452625, size.height * 0.9959396,
        size.width * 0.4966500, size.height * 0.9941289);
    path0.quadraticBezierTo(size.width * 0.5488625, size.height * 0.9944719,
        size.width * 0.5699250, size.height * 0.9144307);
    path0.quadraticBezierTo(size.width * 0.6647500, size.height * 0.9144307,
        size.width * 0.7214000, size.height * 0.9955007);
    path0.quadraticBezierTo(size.width * 0.7214000, size.height * 1.0373800,
        size.width * 0.7229000, size.height * 0.9955007);
    path0.lineTo(size.width * 0.2716375, size.height * 0.9941289);
    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
