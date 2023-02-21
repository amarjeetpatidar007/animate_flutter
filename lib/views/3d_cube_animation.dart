import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class CubeAnimate extends StatefulWidget {
  const CubeAnimate({super.key});

  @override
  State<CubeAnimate> createState() => _CubeAnimateState();
}

class _CubeAnimateState extends State<CubeAnimate>
    with TickerProviderStateMixin {
  late AnimationController xController;
  late AnimationController yController;
  late AnimationController zController;
  late Tween<double> animation;
  final contSize = 100.0;

  @override
  void initState() {
    super.initState();

    xController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    yController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));

    zController =
        AnimationController(vsync: this, duration: const Duration(seconds: 40));

    animation = Tween<double>(begin: 0, end: pi * 2);
  }

  @override
  void dispose() {
    xController.dispose();
    yController.dispose();
    zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    xController
      ..reset()
      ..repeat();

    yController
      ..reset()
      ..repeat();

    zController
      ..reset()
      ..repeat();

    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 200,
            width: double.infinity,
          ),
          AnimatedBuilder(
            animation:
                Listenable.merge([xController, yController, zController]),
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateX(animation.evaluate(xController))
                  ..rotateY(animation.evaluate(yController))
                  ..rotateZ(animation.evaluate(zController)),
                child: Stack(
                  children: [
                    //back side
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.translation(Vector3(0, 0, -contSize)),
                      child: Container(
                        height: contSize,
                        width: contSize,
                        color: Colors.red,
                      ),
                    ),
//                  Left side
                    Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()..rotateY(pi / 2),
                      child: Container(
                        height: contSize,
                        width: contSize,
                        color: Colors.orange,
                      ),
                    ),

                    //Right side
                    Transform(
                      alignment: Alignment.centerRight,
                      transform: Matrix4.identity()..rotateY(-pi / 2),
                      child: Container(
                        height: contSize,
                        width: contSize,
                        color: Colors.green,
                      ),
                    ),

                    //front side
                    Container(
                      height: contSize,
                      width: contSize,
                      color: Colors.lightBlue,
                    ),

                    //Bottom Side
                    Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.identity()..rotateX(pi / 2),
                      child: Container(
                        height: contSize,
                        width: contSize,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      )),
    );
  }
}
