import 'package:assignment/views/chained_animation.dart';
import 'package:assignment/views/rotate_animate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ChainedAnimation());
  }
}
