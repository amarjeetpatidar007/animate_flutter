import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircleCustomClip extends CustomClipper<Path> {
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.width / 2), radius: size.width / 2);
    path.addOval(rect);
    return path;
  }
}

/* Generate Random Number 
0xFFFFFFFF :
FF = 255
 A R G B = [0 - 255] : 8 bit each
 Alpha is Visibility

 */

Color randomColor() => Color(
      0xFF000000 + math.Random().nextInt(0x00FFFFFF),
    );

class TweenAnimationView extends StatefulWidget {
  const TweenAnimationView({super.key});

  @override
  State<TweenAnimationView> createState() => _TweenAnimationViewState();
}

class _TweenAnimationViewState extends State<TweenAnimationView> {
  @override
  Widget build(BuildContext context) {
    var color = randomColor();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ClipPath(
            clipper: CircleCustomClip(),
            child: TweenAnimationBuilder(
              // Remeber the end value of previous animation and uses it as begin value of next animation
              tween: ColorTween(begin: randomColor(), end: color),
              onEnd: () {
                setState(() {
                  color = randomColor();
                });
              },
              duration: const Duration(seconds: 1),
              builder: (BuildContext context, Color? value, Widget? child) {
                return ColorFiltered(
                  colorFilter: ColorFilter.mode(value!, BlendMode.srcATop),
                  child: child,
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
