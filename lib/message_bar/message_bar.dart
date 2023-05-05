import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

///Normal Message bar with more actions
///
/// following attributes can be modified
///
///
/// # BOOLEANS
/// [replying] is additional reply widget top of the message bar
///
/// # STRINGS
/// [replyingTo] is a string to tag the replying message
///
/// # WIDGETS
/// [actions] are the additional leading action buttons like camera
/// and file select
///
/// # COLORS
/// [replyWidgetColor] is reply widget color
/// [replyIconColor] is the reply icon color on the left side of reply widget
/// [replyCloseColor] is the close icon color on the right side of the reply
/// widget
/// [messageBarColor] is the color of the message bar
/// [sendButtonColor] is the color of the send button
///
/// # METHODS
/// [onTextChanged] is function which triggers after text every text change
/// [onSend] is send button action
/// [onTapCloseReply] is close button action of the close button on the
/// reply widget usually change [replying] attribute to `false`
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
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
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
                          child: Container(
                            child: Text(
                              'Re : ' + widget.replyingTo,
                              overflow: TextOverflow.ellipsis,
                            ),
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
            Container(
              color: widget.messageBarColor,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  InkWell(
                    child: const Icon(
                      Icons.emoji_emotions_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    onTap: () {
                      EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          // Do something when emoji is tapped
                        },
                        config: const Config(
                            columns: 7,
                            emojiSizeMax: 32.0,
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            initCategory: Category.RECENT,
                            bgColor: Color(0xFFF2F2F2),
                            indicatorColor: Colors.blue,
                            iconColor: Colors.grey,
                            iconColorSelected: Colors.blue,
                            showRecentsTab: true,
                            recentsLimit: 28,
                            categoryIcons: CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.02),
                    child: InkWell(
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 24,
                      ),
                      onTap: () async {
                        ImagePicker image = ImagePicker();
                        try {
                          XFile? filePath =
                              await image.pickImage(source: ImageSource.camera);
                          print(filePath);
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 3,
                      onChanged: widget.onTextChanged,
                      decoration: InputDecoration(
                        hintText: "BoliyG",
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: InkWell(
                      child: Icon(
                        Icons.send,
                        color: widget.sendButtonColor,
                        size: 24,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class MessageBar extends StatelessWidget {
//   final bool replying;
//   final String replyingTo;
//   final List<Widget> actions;
//   final Color replyWidgetColor;
//   final Color replyIconColor;
//   final Color replyCloseColor;
//   final Color messageBarColor;
//   final Color sendButtonColor;
//   final void Function(String)? onTextChanged;
//   final void Function(String)? onSend;
//   final void Function()? onTapCloseReply;
//
//   /// [MessageBar] constructor
//   ///
//   ///
//   MessageBar({
//     this.replying = false,
//     this.replyingTo = "",
//     this.actions = const [],
//     this.replyWidgetColor = const Color(0xffF4F4F5),
//     this.replyIconColor = Colors.blue,
//     this.replyCloseColor = Colors.black12,
//     this.messageBarColor = const Color(0xffF4F4F5),
//     this.sendButtonColor = Colors.blue,
//     this.onTextChanged,
//     this.onSend,
//     this.onTapCloseReply,
//   });
//   final TextEditingController _textController = TextEditingController();
//
//   /// [MessageBar] builder method
//   ///
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             replying
//                 ? Container(
//                     color: replyWidgetColor,
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 8,
//                       horizontal: 16,
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.reply,
//                           color: replyIconColor,
//                           size: 24,
//                         ),
//                         Expanded(
//                           child: Container(
//                             child: Text(
//                               'Re : ' + replyingTo,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                         InkWell(
//                           onTap: onTapCloseReply,
//                           child: Icon(
//                             Icons.close,
//                             color: replyCloseColor,
//                             size: 24,
//                           ),
//                         ),
//                       ],
//                     ))
//                 : Container(),
//             replying
//                 ? Container(
//                     height: 1,
//                     color: Colors.grey.shade300,
//                   )
//                 : Container(),
//             Container(
//               color: messageBarColor,
//               padding: const EdgeInsets.symmetric(
//                 vertical: 8,
//                 horizontal: 16,
//               ),
//               child: Row(
//                 children: <Widget>[
//                   ...actions,
//                   Expanded(
//                     child: TextField(
//                       controller: _textController,
//                       keyboardType: TextInputType.multiline,
//                       textCapitalization: TextCapitalization.sentences,
//                       minLines: 1,
//                       maxLines: 3,
//                       onChanged: onTextChanged,
//                       decoration: InputDecoration(
//                         hintText: "BoliyG",
//                         hintMaxLines: 1,
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 18.0, vertical: 10),
//                         hintStyle: const TextStyle(
//                           fontSize: 16,
//                         ),
//                         fillColor: Colors.white,
//                         filled: true,
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.0),
//                           borderSide: const BorderSide(
//                             color: Colors.white,
//                             width: 0.2,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.0),
//                           borderSide: const BorderSide(
//                             color: Colors.black26,
//                             width: 0.2,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 16),
//                     child: InkWell(
//                       child: Icon(
//                         Icons.send,
//                         color: sendButtonColor,
//                         size: 24,
//                       ),
//                       onTap: () {
//                         if (_textController.text.trim() != '') {
//                           if (onSend != null) {
//                             onSend!(_textController.text.trim());
//                           }
//                           _textController.text = '';
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
