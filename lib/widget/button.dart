import 'package:chat_app/colors/theam_color.dart';
import 'package:flutter/material.dart';

class Button {
  static Widget primaryButton(
      {required Widget child, required VoidCallback onPressed}) {
    return MaterialButton(
      elevation: 0,
      height: 50,
      color: ColorManager.primary,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onPressed: onPressed,
      child: child,
    );
  }

  static Widget secondaryButton(
      {required Widget child, required VoidCallback onPressed,double horizontal=32,double height=50,}) {
    return MaterialButton(
      elevation: 0,
      height: height,
      color: Colors.transparent,
      padding:  EdgeInsets.symmetric(vertical: 8, horizontal: horizontal),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: ColorManager.buttonBorderColor, width: 1.5)),
      onPressed: onPressed,
      child: child,
    );
  }

  static Widget logoutButton(
      {Color backgroundColor = Colors.transparent,
      double horizontal=32,
      double height=50,
      required Widget child,
      required VoidCallback onPressed}) {
    return MaterialButton(
      elevation: 0,
      height: height,
      color: backgroundColor,
      padding:  EdgeInsets.symmetric(vertical: 8, horizontal: horizontal),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: ColorManager.logoutbuttonBorderColor, width: 1)),
      onPressed: onPressed,
      child: child,
    );
  }

  static Widget homeButton(
      {Color backgroundColor = Colors.transparent,
      double horizontal=32,
      double height=50,
      required Widget child,
      required VoidCallback onPressed}) {
    return MaterialButton(
      elevation: 0,
      height: height,
      color: backgroundColor,
      padding:  EdgeInsets.symmetric(vertical: 8, horizontal: horizontal),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: backgroundColor, width: 1)),
      onPressed: onPressed,
      child: child,
    );
  }

  static Widget viewButton(
      {Color backgroundColor = Colors.transparent,
      double horizontal=32,
      double height=50,
      double radius=100,
      required Widget child,
      required VoidCallback onPressed}) {
    return MaterialButton(
      elevation: 0,
      height: height,
      color: backgroundColor,
      padding:  EdgeInsets.symmetric(vertical: 8, horizontal: horizontal),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(
              color: backgroundColor, width: 1)),
      onPressed: onPressed,
      child: child,
    );
  }

    

}
