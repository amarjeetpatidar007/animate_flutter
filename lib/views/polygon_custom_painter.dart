import 'package:assignment/views/chained_animation.dart';
import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin;

class PolygonPainter extends CustomPainter {
  final int side;

  PolygonPainter({required this.side});

  @override
  void paint(Canvas canvas, Size size) {
    // Define Brush Style and Properties
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    final center = Offset(size.width / 2, size.height / 2);
    final angle = (pi * 2) / side;
    final angles = List.generate(side, (index) => index * angle);
    final radius = size.width / 2;
    final path = Path();

    /* 
    Formula - To get the value of X and Y on Circumference
    x = center.x + radius * cos(angle) 
    y = center.y + radius * sin(angle)
    */

    //Move the Brush to first Angle Coordinate (0,0)
    path.moveTo(
      center.dx + radius * cos(0),
      center.dy + radius * sin(0),
    );

    for (final angle in angles) {
      path.lineTo(
          center.dx + radius * cos(angle), center.dy + radius * sin(angle));
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is PolygonPainter && oldDelegate.side != side;
}

class PolygonAnimation extends StatefulWidget {
  const PolygonAnimation({super.key});

  @override
  State<PolygonAnimation> createState() => _PolygonAnimationState();
}

class _PolygonAnimationState extends State<PolygonAnimation>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<int> animation;

  //Size Animation
  late AnimationController radiusController;
  late Animation<double> radiusAnimation;

  //Rotation Animation
  late AnimationController rotationController;
  late Animation<double> rotationAnimation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    animation = IntTween(begin: 3, end: 10).animate(controller);

    radiusController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    radiusAnimation = Tween(begin: 30.0, end: 400.0)
        .chain(CurveTween(curve: Curves.bounceInOut))
        .animate(radiusController);

    rotationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    rotationAnimation = Tween(begin: 0.0, end: pi * 2)
        .chain(CurveTween(curve: Curves.easeInOutCirc))
        .animate(rotationController);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    radiusController.dispose();
    rotationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.repeat(reverse: true);
    radiusController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          controller,
          radiusController,
        ]),
        builder: (BuildContext context, Widget? child) {
          return Transform(
            transform: Matrix4.identity()
              ..rotateX(rotationController.value)
              ..rotateY(rotationController.value)
              ..rotateZ(rotationController.value),
            child: Center(
              child: CustomPaint(
                painter: PolygonPainter(side: animation.value),
                child: SizedBox(
                  height: radiusAnimation.value,
                  width: radiusAnimation.value,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
