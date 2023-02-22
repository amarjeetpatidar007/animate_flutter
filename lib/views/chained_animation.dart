import 'package:flutter/material.dart';
import 'dart:math' show pi;

enum CircleSide { part1, part2 }

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

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

class _ChainedAnimationState extends State<ChainedAnimation>
    with TickerProviderStateMixin {
  late AnimationController _CounterClockAnimationcontroller;
  late Animation<double> _CounterClockanimation;

  //Flip Animation
  late AnimationController _flipAnimationController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();

    _CounterClockAnimationcontroller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _CounterClockanimation = Tween(begin: 0.0, end: -(pi / 2.0)).animate(
        CurvedAnimation(
            parent: _CounterClockAnimationcontroller, curve: Curves.bounceOut));

    //Flip Animation

    _flipAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(CurvedAnimation(
        parent: _flipAnimationController, curve: Curves.bounceOut));

    //Status Listener
    _CounterClockAnimationcontroller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
                begin: _flipAnimation.value, end: _flipAnimation.value + pi)
            .animate(CurvedAnimation(
                parent: _flipAnimationController, curve: Curves.bounceOut));

        _flipAnimationController
          ..reset()
          ..forward();
      }
    });

    _flipAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _CounterClockanimation = Tween<double>(
                begin: _CounterClockanimation.value,
                end: _CounterClockanimation.value + -(pi / 2))
            .animate(CurvedAnimation(
                parent: _CounterClockAnimationcontroller,
                curve: Curves.bounceOut));
        _CounterClockAnimationcontroller
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _CounterClockAnimationcontroller.dispose();
    _flipAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Reset when build is called and start the animation
    _CounterClockAnimationcontroller
      ..reset()
      ..forward.delayed(const Duration(seconds: 1));

    return AnimatedBuilder(
      animation: _CounterClockAnimationcontroller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..rotateZ(_CounterClockanimation.value),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _flipAnimationController,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.centerRight,
                    transform: Matrix4.identity()
                      ..rotateY(_flipAnimation.value),
                    child: ClipPath(
                      clipper: SemiCircleClipper(side: CircleSide.part1),
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.identity()
                      ..rotateY(_flipAnimation.value),
                    child: ClipPath(
                      clipper: SemiCircleClipper(side: CircleSide.part2),
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.orange,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
