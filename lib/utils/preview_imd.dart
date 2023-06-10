import 'dart:convert';

import 'package:boliye_g/bloc/bloc.dart';
import 'package:boliye_g/bloc/bloc_event.dart';
import 'package:boliye_g/screens/homepage.dart';
import 'package:boliye_g/screens/intro_screen.dart';
import 'package:flutter/material.dart';

import '../constant/sizer.dart';

class PreviewImage extends StatefulWidget {
  const PreviewImage(
      {super.key, required this.path, this.myToken = '', this.name = ''});
  final String path;
  final String name;
  final String myToken;

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (widget.myToken == '') {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => IntroScreen(
                          imgae: widget.path,
                        )),
                (route) => false);
          } else {
            final ChatBlocks block = ChatBlocks();
            block.add(
                EditProfileImage(image: widget.path, myToken: widget.myToken));
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(name: widget.name, imageString: widget.path)),
                (route) => false);
          }
        },
        child: const Icon(Icons.check),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: displayHeight(context) * 0.05),
          width: displayWidth(context),
          height: displayHeight(context) * 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: MemoryImage(
                base64Decode(widget.path),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
