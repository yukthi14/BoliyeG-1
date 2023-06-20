import 'package:boliye_g/constant/sizer.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import '../constant/color.dart';

class EmojiPage extends StatefulWidget {
  const EmojiPage({
    super.key,
  });

  @override
  State<EmojiPage> createState() => _EmojiPageState();
}

class _EmojiPageState extends State<EmojiPage> {
  final TextEditingController _emojiTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Emoji',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.backgroundColor,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: displayWidth(context) * 0.2,
                bottom: displayHeight(context) * 0.5),
            width: displayWidth(context) * 0.6,
            height: displayHeight(context) * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.scaffoldColor, width: 3),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: displayHeight(context) * 0.29,
                left: displayWidth(context) * 0.7),
            child: FloatingActionButton(
              backgroundColor: AppColors.scaffoldColor,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.check),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: displayHeight(context) * 0.55),
            height: displayHeight(context) * 0.37,
            child: EmojiPicker(
              textEditingController: _emojiTextEditingController,
              config: const Config(
                  columns: 8,
                  emojiSizeMax: 32.0,
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  initCategory: Category.RECENT,
                  bgColor: Color(0xFFF2F2F2),
                  indicatorColor: Colors.blue,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.blue,
                  recentsLimit: 30,
                  categoryIcons: CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL),
            ),
          ),
        ],
      ),
    );
  }
}
