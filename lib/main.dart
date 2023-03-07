import 'package:assignment/views/home.dart';
import 'package:assignment/views/polygon_custom_painter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PolygonAnimation());
  }
}
