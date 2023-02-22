import 'package:assignment/views/3d_cube_animation.dart';
import 'package:assignment/views/chained_animation.dart';
import 'package:assignment/views/rotate_animate.dart';
import 'package:flutter/material.dart';

TextStyle _textStyle = const TextStyle(fontWeight: FontWeight.bold);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animations'),
        // backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      // backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const RotateAnimate(),
                  Text(
                    'Rotate Z Axis ',
                    style: _textStyle,
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
                width: 10,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const ChainedAnimation(),
                  Text(
                    'Chained ',
                    style: _textStyle,
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
                width: 10,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const CubeAnimate(),
                  Text(
                    '3D Cube ',
                    style: _textStyle,
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
