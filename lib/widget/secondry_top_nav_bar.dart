import 'package:flutter/material.dart';

class SecondryTopNavBar extends StatelessWidget {
  const SecondryTopNavBar({super.key, required this.title, this.widget});
  final String title;

  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget,
    );
  }
}
