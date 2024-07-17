// ignore_for_file: body_might_complete_normally_nullable, avoid_print

import 'dart:io';

import 'package:chat_app/colors/theam_color.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtil {
  ImageUtil._();

  /// Open image gallery and pick an image
  static Future<XFile?> pickImageFromGallery() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  static Future<XFile?> pickImageFromCamera() async {
    try {
      XFile? cameraFile = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxWidth: 300,
          maxHeight: 300,
          imageQuality: 50,
          requestFullMetadata: false);
      print(((File(cameraFile!.path)).lengthSync() / 1024 / 1024)
          .toStringAsFixed(2));
      return cameraFile;
    } catch (e) {
      print(e);
    }
  }

  /// Pick Image From Gallery and return a File
  static Future<File?> cropSelectedImage(String filePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxWidth: 400,
      maxHeight: 400,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: ColorManager.primary,
            toolbarWidgetColor: ColorManager.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      return imageFile;
    }
  }
}
