import 'package:chat_app/constants/ui_fonts.dart';
import 'package:flutter/material.dart';

TextStyle _getTextStyle(
    double fontSize, String fontFamily, FontWeight fontWeight, Color color) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      color: color);
}

TextStyle _getTextStyleWithShadow(
    double fontSize, String fontFamily, FontWeight fontWeight, Color color) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      color: color,
      shadows: [
        Shadow(
          color: Colors.grey.withOpacity(0.6),
          offset: const Offset(0, 3), // Adjust this value for shadow position
          blurRadius: 2,
        ),
      ]);
}

TextStyle getRegularStyle(
    {bool isWithShadow = false,
    double fontSize = FontSize.s12,
    required Color color}) {
  return isWithShadow
      ? _getTextStyleWithShadow(
          fontSize, FontConstant.fontFamily, FontWeightManager.regular, color)
      : _getTextStyle(
          fontSize, FontConstant.fontFamily, FontWeightManager.regular, color);
}

TextStyle getLightStyle(
    {bool isWithShadow = false,
    double fontSize = FontSize.s12,
    required Color color}) {
  return isWithShadow
      ? _getTextStyleWithShadow(
          fontSize, FontConstant.fontFamily, FontWeightManager.light, color)
      : _getTextStyle(
          fontSize, FontConstant.fontFamily, FontWeightManager.light, color);
}

TextStyle getMediumStyle(
    {bool isWithShadow = false,
    double fontSize = FontSize.s12,
    required Color color}) {
  return isWithShadow
      ? _getTextStyleWithShadow(
          fontSize, FontConstant.fontFamily, FontWeightManager.medium, color)
      : _getTextStyle(
          fontSize, FontConstant.fontFamily, FontWeightManager.medium, color);
}

TextStyle getSemiBoldStyle(
    {bool isWithShadow = false,
    double fontSize = FontSize.s12,
    required Color color}) {
  return isWithShadow
      ? _getTextStyleWithShadow(
          fontSize,
          FontConstant.fontFamily,
          FontWeightManager.semiBold,
          color,
        )
      : _getTextStyle(
          fontSize,
          FontConstant.fontFamily,
          FontWeightManager.semiBold,
          color,
        );
}

TextStyle getBoldStyle(
    {bool isWithShadow = false,
    double fontSize = FontSize.s12,
    required Color color}) {
  return isWithShadow
      ? _getTextStyleWithShadow(
          fontSize, FontConstant.fontFamily, FontWeightManager.bold, color)
      : _getTextStyle(
          fontSize, FontConstant.fontFamily, FontWeightManager.bold, color);
}
