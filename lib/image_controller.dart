import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as imglib;

class ImageController extends ChangeNotifier {
  File? image;
  bool isLoading = false;
  List<Image> images = [];
  List<Widget> dataList = [];

  Future<void> setImage() async {
    isLoading = true;
    notifyListeners();
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (file != null) {
      image = File(file.path);
    }

    dataList.clear();
    splitImage();
  }

  Future<void> splitImage() async {
    // convert image to image from image package
    imglib.Image? img = await imglib.decodeImageFile(image!.path);

    int x = 0, y = 0;
    int width = (img!.width / 3).floor();
    int height = (img.height / 3).floor();

    // split image to parts
    List<imglib.Image> parts = <imglib.Image>[];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        parts.add(
          imglib.copyCrop(
            img,
            x: x,
            y: y,
            width: width,
            height: height,
          ),
        );
        x += width;
      }
      x = 0;
      y += height;
    }

    // convert image from image package to Image Widget to display
    List<Image> output = <Image>[];
    for (var img in parts) {
      output.add(Image.memory(imglib.encodeJpg(img)));
    }

    images = output;
    dataList = List.generate(
      images.length,
      (index) => Container(),
    );

    isLoading = false;
    notifyListeners();
  }

  void acceptImage(int index) {
    dataList[index] = images[index];
    log("$index changed...");
    notifyListeners();
  }
}
