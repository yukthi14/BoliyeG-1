import 'dart:convert';

import 'package:boliye_g/bloc/bloc.dart';
import 'package:boliye_g/bloc/bloc_event.dart';
import 'package:boliye_g/constant/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../constant/color.dart';
import '../constant/strings.dart';
import '../utils/alert_dialog_box.dart';

const double BUBBLE_RADIUS_IMAGE = 16;

class BubbleNormalImage extends StatelessWidget {
  static const loadingWidget = Center(
    child: CircularProgressIndicator(),
  );

  final String id;
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final bool tail;
  final bool sent;
  final bool delivered;
  final String imgLink;
  final bool seen;
  final String myToken;
  final bool isPrivate;
  final void Function()? onTap;

  const BubbleNormalImage({
    Key? key,
    required this.id,
    this.bubbleRadius = BUBBLE_RADIUS_IMAGE,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.onTap,
    required this.imgLink,
    required this.myToken,
    required this.isPrivate,
  }) : super(key: key);

  /// image bubble builder method
  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Row(
      children: <Widget>[
        isSender
            ? const Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .5,
                maxHeight: MediaQuery.of(context).size.width * .5),
            child: GestureDetector(
              onTap: onTap ??
                  () {
                    if (!openEnvelope || !isPrivate) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return DetailScreen(
                          tag: id,
                          image: imgLink,
                          isNetwork: true,
                          isDetailShow: true,
                        );
                      }));
                    } else {
                      Navigator.push(
                        context,
                        PageTransition(
                          duration: const Duration(
                            milliseconds: 300,
                          ),
                          alignment: Alignment.center,
                          type: PageTransitionType.rotate,
                          child: AlertDialogBox(
                            title: Strings.secretCode,
                            buttonString: Strings.openEnvelope,
                            suggestionString: Strings.changePwd,
                            myToken: myToken,
                          ),
                        ),
                      );
                    }
                  },
              child: Hero(
                tag: id,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(bubbleRadius),
                          topRight: Radius.circular(bubbleRadius),
                          bottomLeft: Radius.circular(tail
                              ? isSender
                                  ? bubbleRadius
                                  : 0
                              : BUBBLE_RADIUS_IMAGE),
                          bottomRight: Radius.circular(tail
                              ? isSender
                                  ? 0
                                  : bubbleRadius
                              : BUBBLE_RADIUS_IMAGE),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(bubbleRadius),
                          child: (!openEnvelope || !isPrivate)
                              ? _image()
                              : SizedBox(
                                  width: displayWidth(context) * 0.3,
                                  height: displayHeight(context) * 0.2,
                                  child: const Icon(Icons.lock),
                                ),
                        ),
                      ),
                    ),
                    stateIcon != null && stateTick
                        ? Positioned(
                            bottom: 4,
                            right: 6,
                            child: stateIcon,
                          )
                        : const SizedBox(
                            width: 1,
                          ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _image() {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 20.0,
        minWidth: 20.0,
      ),
      child: CachedNetworkImage(
        imageUrl: imgLink,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final String tag;
  final String image;
  final bool isNetwork;
  final String myToken;
  final String msgTokenImage;
  final String revMsgTokenImage;
  final String timeStamp;
  final bool isPrivate;
  final bool isDetailShow;

  const DetailScreen({
    Key? key,
    required this.tag,
    required this.image,
    required this.isNetwork,
    this.myToken = '',
    this.msgTokenImage = '',
    this.timeStamp = '',
    this.revMsgTokenImage = '',
    this.isPrivate = false,
    required this.isDetailShow,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ChatBlocks _chatBlocks = ChatBlocks();
  Widget _image() {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 20.0,
        minWidth: 20.0,
      ),
      child: (widget.isNetwork)
          ? CachedNetworkImage(
              imageUrl: widget.image,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
          : Image.memory(base64Decode(widget.image)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (!widget.isDetailShow)
          ? FloatingActionButton(
              onPressed: () {
                _chatBlocks.add(
                  UpLoadImage(
                    file: widget.image,
                    isPrivate: widget.isPrivate,
                    timeStamp: widget.timeStamp,
                    myToken: widget.myToken,
                    msgTokenImage: widget.msgTokenImage,
                    reverseTokenImage: widget.revMsgTokenImage,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Icon(Icons.send_outlined),
            )
          : const SizedBox(),
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
            child: Center(
              child: Hero(
                tag: widget.tag,
                child: _image(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
