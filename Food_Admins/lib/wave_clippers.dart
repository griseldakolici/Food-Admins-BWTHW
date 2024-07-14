import 'package:flutter/material.dart';

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 12);
    var firstControlPoint = Offset(size.width / 100, size.height / 1.5); 
    var firstEndPoint = Offset(size.width / 1.5, size.height / 2 - 40); 
    var secondControlPoint = Offset(size.width - (size.width / 20), size.height / 20); 
    var secondEndPoint = Offset(size.width, size.height / 2 - 20); 

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height);

    var firstControlPoint = Offset(size.width - (size.width / 15.25), size.height / 1.75); 
    var firstEndPoint = Offset(size.width / 1.5, size.height / 1.5); 
    var secondControlPoint = Offset(size.width / 3, size.height / 5.5 +2.5); 
    var secondEndPoint = Offset(0, size.height / 4); 

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(0, size.height / 4.25);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
