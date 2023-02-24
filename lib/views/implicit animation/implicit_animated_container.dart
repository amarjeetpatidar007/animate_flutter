import 'package:flutter/material.dart';

class ImplicitAnimatedContainer extends StatefulWidget {
  const ImplicitAnimatedContainer({super.key});

  @override
  State<ImplicitAnimatedContainer> createState() =>
      _ImplicitAnimatedContainerState();
}

const dWidth = 100.0;

class _ImplicitAnimatedContainerState extends State<ImplicitAnimatedContainer> {
  var _isZoomedIn = false;
  var _buttonTitle = "Zoom In";
  var _width = dWidth;
  var _curve = Curves.bounceOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit Animated Container'),
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
                curve: _curve,
                duration: const Duration(milliseconds: 350),
                width: _width,
                child: Image.asset(
                  'assets/images/ap.png',
                  color: Colors.grey,
                )),
          ],
        ),
        TextButton(
            onPressed: () {
              setState(() {
                _isZoomedIn = !_isZoomedIn;
                _buttonTitle = _isZoomedIn ? "Zoom In" : "Zoom Out";
                _width =
                    _isZoomedIn ? MediaQuery.of(context).size.width : dWidth;
                _curve = _isZoomedIn ? Curves.bounceIn : Curves.bounceOut;
              });
            },
            child: Text(_buttonTitle))
      ]),
    );
  }
}
