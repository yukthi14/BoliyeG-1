import 'package:boliye_g/constant/sizer.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../constant/strings.dart';
import 'image_alert_dialog.dart';

class MessageBar extends StatefulWidget {
  const MessageBar({
    Key? key,
    this.replying = false,
    this.replyingTo = "",
    this.replyWidgetColor = const Color(0xffF4F4F5),
    this.replyIconColor = Colors.blue,
    this.replyCloseColor = Colors.black12,
    this.messageBarColor = const Color(0xffF4F4F5),
    this.sendButtonColor = Colors.blue,
    this.onTextChanged,
    this.onSend,
    this.onTapCloseReply,
  }) : super(key: key);
  final bool replying;
  final String replyingTo;
  final Color replyWidgetColor;
  final Color replyIconColor;
  final Color replyCloseColor;
  final Color messageBarColor;
  final Color sendButtonColor;
  final void Function(String)? onTextChanged;
  final void Function(String)? onSend;
  final void Function()? onTapCloseReply;

  @override
  State<MessageBar> createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final TextEditingController _textController = TextEditingController();
  makeIconTilt() {
    setState(() {
      showCheckIcon = _textController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          widget.replying
              ? Container(
                  color: widget.replyWidgetColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.reply,
                        color: widget.replyIconColor,
                        size: 24,
                      ),
                      Expanded(
                        child: Text(
                          'Re : ${widget.replyingTo}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: widget.onTapCloseReply,
                        child: Icon(
                          Icons.close,
                          color: widget.replyCloseColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ))
              : Container(),
          widget.replying
              ? Container(
                  height: 1,
                  color: Colors.grey.shade300,
                )
              : Container(),
          Row(
            children: [
              // InkWell(
              //   child: const Icon(
              //     Icons.emoji_emotions_rounded,
              //     color: Colors.black,
              //     size: 24,
              //   ),
              //   onTap: () {
              //     EmojiPicker(
              //       onEmojiSelected: (category, emoji) {
              //         // Do something when emoji is tapped
              //       },
              //       config: const Config(
              //           columns: 7,
              //           emojiSizeMax: 32.0,
              //           verticalSpacing: 0,
              //           horizontalSpacing: 0,
              //           initCategory: Category.RECENT,
              //           bgColor: Color(0xFFF2F2F2),
              //           indicatorColor: Colors.blue,
              //           iconColor: Colors.grey,
              //           iconColorSelected: Colors.blue,
              //           showRecentsTab: true,
              //           recentsLimit: 28,
              //           categoryIcons: CategoryIcons(),
              //           buttonMode: ButtonMode.MATERIAL),
              //     );
              //   },
              // ),
              // Padding(
              //   padding: EdgeInsets.only(
              //       left: MediaQuery.of(context).size.width * 0.04,
              //       right: MediaQuery.of(context).size.width * 0.02),
              //   child: InkWell(
              //     child: const Icon(
              //       Icons.camera_alt,
              //       color: Colors.white,
              //       size: 24,
              //     ),
              //     onTap: () async {
              //       ImagePicker image = ImagePicker();
              //       try {
              //         XFile? filePath =
              //             await image.pickImage(source: ImageSource.camera);
              //         print(filePath);
              //       } catch (e) {
              //         print(e);
              //       }
              //     },
              //   ),
              // ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: displayWidth(context) * 0.03,
                    bottom: displayHeight(context) * 0.005,
                    top: displayHeight(context) * 0.009,
                  ),
                  child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.black,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 3,
                    onChanged: (_) => {widget.onTextChanged, makeIconTilt()},
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            startAudioChat.value = true;
                          });
                        },
                        icon: const Icon(
                          Icons.mic,
                          color: Colors.black,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              PageTransition(
                                  duration: const Duration(milliseconds: 100),
                                  type: PageTransitionType.topToBottom,
                                  child: const ImageDialogBox()));
                          // try {
                          //   ImagePicker pick = ImagePicker();
                          //   XFile? path = await pick.pickImage(
                          //       source: ImageSource.camera);
                          // } catch (e) {
                          //   print(e.toString());
                          // }
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => const PhotoPicker()));
                        },
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.black,
                        ),
                      ),
                      hintText: Strings.tittleName,
                      hintMaxLines: 1,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 10),
                      hintStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 0.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(
                          color: Colors.black26,
                          width: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  height: displayHeight(context) * 0.05,
                  margin: EdgeInsets.only(
                      right: displayWidth(context) * 0.04,
                      left: displayWidth(context) * 0.04),
                  child: Transform.rotate(
                    angle: (showCheckIcon) ? -0.55 : 0.0,
                    child: Icon(
                      Icons.send,
                      color: widget.sendButtonColor,
                      size: 24,
                    ),
                  ),
                ),
                onTap: () {
                  if (_textController.text.trim() != '') {
                    if (widget.onSend != null) {
                      widget.onSend!(_textController.text.trim());
                    }
                    _textController.text = '';
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
