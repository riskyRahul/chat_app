// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class MyAnimatedWidget extends StatefulWidget {
  const MyAnimatedWidget({Key? key}) : super(key: key);
  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<MyAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(seconds: 60),
        vsync: this,
        upperBound: 360,
        lowerBound: 0)
      ..repeat();
  }

  @override
  void didUpdateWidget(MyAnimatedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_controller.isAnimating) {
      _controller.repeat();
    } else if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.rotate(
        angle: (_controller.value),
        child: const Icon(Icons.network_cell),
      ),
    );
  }
}

class CPIWidget extends StatefulWidget {
  const CPIWidget({Key? key}) : super(key: key);
  @override
  State<CPIWidget> createState() => _CPIWidgetState();
}

class _CPIWidgetState extends State<CPIWidget> {
  @override
  Widget build(BuildContext context) {
    const double bigLogo = 100;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size biggest = constraints.biggest;
        return Container(
          constraints: constraints,
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(child: MyAnimatedWidget())),
            ],
          ),
        );
      },
    );
  }
}
