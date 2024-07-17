// ignore_for_file: must_be_immutable

import 'package:chat_app/colors/theam_color.dart';
import 'package:chat_app/constants/ui_fonts.dart';
import 'package:chat_app/constants/ui_spacing.dart';
import 'package:flutter/material.dart';

import '../constants/ui_text_style.dart';

class GetButtonWidget extends StatelessWidget {
  GetButtonWidget({
    super.key,
    required this.onPressed,
    required this.btnText,
    required this.btnColor,
    required this.btnTextColor,
  });
  VoidCallback onPressed;
  String btnText;
  Color btnColor;
  Color btnTextColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize:
            MaterialStateProperty.all(const Size.fromHeight(AppSize.s45)),
        backgroundColor: MaterialStateProperty.all(
          btnColor,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide(color: ColorManager.buttonBorderColor),
            borderRadius: BorderRadius.circular(AppSize.s10),
          ),
        ),
      ),
      child: Text(
        btnText,
        style: getBoldStyle(
          color: btnTextColor,
          fontSize: FontSize.s18,
        ),
      ),
    );
  }
}
