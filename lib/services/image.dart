import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
//import 'dart:ui';
import 'package:flutter/material.dart';
class imageservice{
 static final _picker = ImagePicker();
static Future<String?> getImage(bool camera, BuildContext context) async {
    var pickedFile = await _picker.pickImage(
      source: (camera) ? ImageSource.camera : ImageSource.gallery,
    );

    if (pickedFile == null) return null;

    //var bytes = await file.readAsBytes();

    return pickedFile.path;
}
}