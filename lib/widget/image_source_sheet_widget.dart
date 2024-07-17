import 'package:chat_app/utils/image_util.dart';
import 'package:flutter/material.dart';

class ImageSourceSheet extends StatelessWidget {
  const ImageSourceSheet({super.key});
  static String? imagePathFootball;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.photo_library, color: Colors.grey, size: 27),
              label: const Text("Gallery",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              onPressed: () async {
                // Step #1: Pick Image From Galler.
                await ImageUtil.pickImageFromGallery().then((pickedFile) async {
                  // Step #2: Check if we actually picked an image. Otherwise -> stop;
                  if (pickedFile == null) return;
                  // Step #3: Crop earlier selected image
                  await ImageUtil.cropSelectedImage(pickedFile.path)
                      .then((croppedFile) {
                    // Step #4: Check if we actually cropped an image. Otherwise -> stop;
                    if (croppedFile == null) {
                      return null;
                    } else {
                      print("CP ${croppedFile.path}");
                      imagePathFootball = croppedFile.path;
                    }
                    /* if (imageType == 'PF') {
                      _detailsController.pFrontImagePath.value = croppedFile.path;
                    } else if (imageType == 'PB') {
                      _detailsController.pBackImagePath.value = croppedFile.path;
                    } else if (imageType == 'VI') {
                      _detailsController.visaImagePath.value = croppedFile.path;
                    } else if (imageType == 'TI') {
                      _detailsController.ticketImagePath.value = croppedFile.path;
                    } */
                    // Step #5: Display image on screen
                  });
                });
                print(imagePathFootball);
                Navigator.of(context).pop();
                // Get image from device gallery
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.camera_alt, size: 20),
              label: const Text("Camera",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              onPressed: () async {
                // Step #1: Pick Image From Galler.
                await ImageUtil.pickImageFromCamera().then((pickedFile) async {
                  // Step #2: Check if we actually picked an image. Otherwise -> stop;
                  if (pickedFile == null) return;
        
                  // Step #3: Crop earlier selected image
                  await ImageUtil.cropSelectedImage(pickedFile.path)
                      .then((croppedFile) {
                    // Step #4: Check if we actually cropped an image. Otherwise -> stop;
                    if (croppedFile == null)
                      return null;
                    else {
                      imagePathFootball = croppedFile.path;
                    }
                    /*  if (imageType == 'PF') {
                      _detailsController.pFrontImagePath.value = croppedFile.path;
                    } else if (imageType == 'PB') {
                      _detailsController.pBackImagePath.value = croppedFile.path;
                    } else if (imageType == 'VI') {
                      _detailsController.visaImagePath.value = croppedFile.path;
                    } else if (imageType == 'TI') {
                      _detailsController.ticketImagePath.value = croppedFile.path;
                    }
        */
                    // Step #5: Display image on screen
                  });
                });
                print(imagePathFootball);
                Navigator.of(context).pop(); // Get image from device gallery
              },
              // Capture image from camera
            ),
          ],
        ),
      ),
    );
  }
}
