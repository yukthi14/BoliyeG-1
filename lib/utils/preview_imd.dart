import 'dart:io';

import 'package:boliye_g/services/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../constant/sizer.dart';

class PreviewImage extends StatefulWidget {
  const PreviewImage({super.key, required this.path, required this.myToken});
  final String path;
  final String myToken;

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: displayHeight(context) * 0.05),
          width: displayWidth(context),
          height: displayHeight(context) * 5,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: FileImage(File(widget.path)))),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          firebaseVoiceMessage.setProfileImage(
              path: widget.path, myToken: widget.myToken);
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
