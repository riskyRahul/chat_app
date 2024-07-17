
import 'package:flutter/material.dart';

class MImage {
  static Widget viewImage({required String imageUrl, double scale = 5.0}) {
    return Image.asset(imageUrl, scale: scale);
  }
  // static Widget viewImage({required String imageUrl, double scale = 5.0}) {
  //   return Image.network(imageUrl, scale: scale);
  // }
}
