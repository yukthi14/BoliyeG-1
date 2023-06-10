import 'dart:convert';

import 'package:boliye_g/bloc/bloc.dart';
import 'package:boliye_g/bloc/bloc_event.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final ChatBlocks block = ChatBlocks();
          block.add(EditProfile(
              image: widget.path, name: '', myToken: widget.myToken));
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
