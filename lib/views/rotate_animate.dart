import 'package:flutter/material.dart';
import 'dart:math' show pi;

class RotateAnimate extends StatefulWidget {
  const RotateAnimate({super.key});

  @override
  State<RotateAnimate> createState() => _RotateAnimateState();
}

class _RotateAnimateState extends State<RotateAnimate>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;


  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0.0, end: pi * 2).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateZ(_animation.value),
              child: const Text('Animations'));
        },
      )),
    );
  }
}
