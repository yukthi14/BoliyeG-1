import 'package:flutter/cupertino.dart';

class BackGroundShadow extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(size.width * 0.1837500, size.height * 0.2053691);
    path0.quadraticBezierTo(size.width * 0.2925000, size.height * 0.1610067,
        size.width * 0.4400000, size.height * 0.2000000);
    path0.quadraticBezierTo(size.width * 0.6115750, size.height * 0.3398121,
        size.width * 0.4350000, size.height * 0.4671141);
    path0.quadraticBezierTo(size.width * 0.3257375, size.height * 0.5209128,
        size.width * 0.1900000, size.height * 0.4671141);
    path0.quadraticBezierTo(size.width * 0.0152625, size.height * 0.3344295,
        size.width * 0.1837500, size.height * 0.2053691);
    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
