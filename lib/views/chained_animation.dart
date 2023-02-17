import 'package:flutter/material.dart';

enum CircleSide { part1, part2 }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    // Path Creation
    final path = Path();
    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.part1:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.part2:
        // Default Path is (0,0) so no need to Move the path as part2 Container.
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }
    // Draw Arc :  radius of arc is half the height and width of the Container
    path.arcToPoint(offset,
        radius: Radius.elliptical(size.width / 2, size.height / 2),
        clockwise: clockwise);
    // Close Path : Line from where our Pencil is left after drawing arc to Start point.
    path.close();
    return path;
  }
}

class SemiCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  SemiCircleClipper({required this.side});
  @override
  Path getClip(Size size) => side.toPath(size);

  // Notifies Parent Widget when changes happen
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class ChainedAnimation extends StatefulWidget {
  const ChainedAnimation({super.key});

  @override
  State<ChainedAnimation> createState() => _ChainedAnimationState();
}

class _ChainedAnimationState extends State<ChainedAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipPath(
          clipper: SemiCircleClipper(side: CircleSide.part1),
          child: Container(
            width: 100,
            height: 100,
            color: Colors.red,
          ),
        ),
        ClipPath(
          clipper: SemiCircleClipper(side: CircleSide.part2),
          child: Container(
            width: 100,
            height: 100,
            color: Colors.pink,
          ),
        ),
      ],
    ));
  }
}
