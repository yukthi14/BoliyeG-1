import 'dart:io';

import 'package:boliye_g/constant/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constant/color.dart';
import '../utils/bottomDrawer.dart';

class PhotoPicker extends StatefulWidget {
  const PhotoPicker({Key? key}) : super(key: key);

  @override
  State<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  List<File> images = [];
  @override
  void initState() {
    // _getFromCamera();
    requestPermission();
    super.initState();
  }

  _getFromCamera() async {
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
    } catch (e) {
      print(e);
    }
  }

  Future<void> requestPermission() async {
    final PermissionStatus status = await Permission.photos.request();
    print(status);

    if (status.isGranted) {
      loadImages();
    }
  }

  Future<void> loadImages() async {
    final Directory directory = Directory('/storage/emulated/0/DCIM/Camera');
    final List<FileSystemEntity> files = directory.listSync();

    for (FileSystemEntity file in files) {
      if (file is File) {
        final File compressedImage =
            await FlutterNativeImage.compressImage(file.path, percentage: 10);

        setState(() {
          images.add(compressedImage);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            height: displayHeight(context) * 0.8,
            margin: EdgeInsets.only(top: displayHeight(context) * 0.03),
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemCount: images.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    decoration: BoxDecoration(
                        color: AppColors.appBarColor,
                        border: Border.all(color: Colors.black)),
                    child: Image.file(images[index]));
              },
            ),
          ),
          Opacity(
            opacity: 1,
            child: ClipPath(
              clipper: BottomDrawer(alignment: Alignment.bottomLeft),
              child: Container(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// Stack(
// children: [
// // GridView.builder(
// //   scrollDirection: Axis.horizontal,
// //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //     crossAxisCount: 8,
// //   ),
// //   itemCount: images.length,
// //   itemBuilder: (BuildContext context, int index) {
// //     return Container(
// //         decoration: BoxDecoration(
// //             color: AppColors.appBarColor,
// //             border: Border.all(color: Colors.black)),
// //         child: Image.file(images[index]));
// //   },
// // ),
//
// ],
// ),
