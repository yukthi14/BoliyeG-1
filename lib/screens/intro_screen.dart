import 'dart:convert';
import 'dart:io' as Io;
import 'dart:math';

import 'package:boliye_g/bloc/initiate_state_bloc/bloc.dart';
import 'package:boliye_g/bloc/initiate_state_bloc/bloc_event.dart';
import 'package:boliye_g/constant/color.dart';
import 'package:boliye_g/constant/sizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../constant/strings.dart';
import '../utils/preview_imd.dart';
import 'homepage.dart';

class ItemData {
  final Color color;
  ItemData(this.color);
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({
    super.key,
    this.imgae = '',
  });
  final String imgae;

  @override
  _WithBuilder createState() => _WithBuilder();
}

class _WithBuilder extends State<IntroScreen> with TickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: controller,
    curve: Curves.elasticIn,
  ));

  int page = 0;
  late LiquidController liquidController;
  late UpdateType updateType;

  List<ItemData> data = [
    ItemData(
      AppColors.appBarColor,
    ),
    ItemData(
      AppColors.scaffoldColor,
    ),
  ];

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    double selectness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectness;
    return SizedBox(
      width: 25.0,
      child: Center(
        child: Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: SizedBox(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  final TextEditingController _controller = TextEditingController();
  final ChatBlocks _blocks = ChatBlocks();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: body(context),
    );
  }

  Widget body(context) {
    return Stack(
      children: <Widget>[
        LiquidSwipe.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return (index == 0)
                ? Container(
                    width: double.infinity,
                    color: data[index].color,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: displayHeight(context) * 0.3),
                          width: displayWidth(context),
                          height: displayHeight(context) * 0.4,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/logo.gif'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: displayHeight(context) * 0.2),
                          width: displayWidth(context),
                          height: displayHeight(context) * 0.03,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Strings.logoMsg,
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                'Se',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'lf',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'ie',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'e',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'ra',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.purple,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          color: data[index].color,
                        ),
                        (widget.imgae == '')
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: displayHeight(context) * 0.03,
                                    left: displayWidth(context) * 0.25),
                                width: displayWidth(context) * 0.5,
                                height: displayHeight(context) * 0.3,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.amber.shade200,
                                    image: const DecorationImage(
                                      image: AssetImage(Strings.avatarImage),
                                    )),
                              )
                            : Container(
                                margin: EdgeInsets.only(
                                    top: displayHeight(context) * 0.03,
                                    left: displayWidth(context) * 0.25),
                                width: displayWidth(context) * 0.5,
                                height: displayHeight(context) * 0.3,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.amber.shade200,
                                    image: DecorationImage(
                                      image: MemoryImage(
                                          base64Decode(widget.imgae)),
                                    )),
                              ),
                        Container(
                          width: displayWidth(context) * 0.13,
                          height: displayHeight(context) * 0.06,
                          margin: EdgeInsets.only(
                            top: displayHeight(context) * 0.25,
                            left: displayWidth(context) * 0.65,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.profileCardColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: MaterialButton(
                            child: const Icon(Icons.edit),
                            onPressed: () {
                              showCustomDialog(context);
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: displayWidth(context) * 0.08,
                            top: displayHeight(context) * 0.35,
                          ),
                          width: displayWidth(context),
                          height: displayHeight(context) * 0.05,
                          child: const Text(
                            Strings.profileUserName,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: displayWidth(context) * 0.05,
                            right: displayWidth(context) * 0.05,
                            top: displayHeight(context) * 0.4,
                          ),
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.black,
                            textAlign: TextAlign.start,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: Strings.profileName,
                              filled: true,
                              fillColor: Colors.white60,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: displayHeight(context) * 0.5,
                            left: displayWidth(context) * 0.8,
                          ),
                          child: TextButton(
                            onPressed: () async {
                              if (_controller.text.isNotEmpty &&
                                  widget.imgae != '') {
                                _blocks.add(
                                  SetUserEvent(
                                      name: _controller.text,
                                      image: widget.imgae),
                                );
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                            name: _controller.text,
                                            imageString: widget.imgae)),
                                    (route) => false);
                              } else if (_controller.text.isNotEmpty &&
                                  widget.imgae == '') {
                                ByteData bytes =
                                    await rootBundle.load('assets/avatar.webp');
                                var buffer = bytes.buffer;
                                String image =
                                    base64.encode(Uint8List.view(buffer));

                                _blocks.add(
                                  SetUserEvent(
                                      name: _controller.text, image: image),
                                );
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                            name: _controller.text,
                                            imageString: image)),
                                    (route) => false);
                                _blocks.add(UpdateUsersEvent());
                              } else {
                                Fluttertoast.showToast(
                                  msg: Strings.profileMsgError,
                                  gravity: ToastGravity.TOP,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                                backgroundColor:
                                    AppColors.appBarColor.withOpacity(0.01),
                                foregroundColor: Colors.black),
                            child: const Text(
                              Strings.nextTextButton,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
          },
          positionSlideIcon: 0.8,
          slideIconWidget: SlideTransition(
            position: _offsetAnimation,
            child: const Icon(Icons.arrow_back_ios),
          ),
          onPageChangeCallback: pageChangeCallback,
          waveType: WaveType.circularReveal,
          liquidController: liquidController,
          fullTransitionValue: 880,
          enableSideReveal: true,
          preferDragFromRevealedArea: true,
          enableLoop: false,
          initialPage: (widget.imgae != '') ? 1 : 0,
          ignoreUserGestureWhileAnimating: true,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(data.length, _buildDot),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }

  void showCustomDialog(BuildContext context) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: AppColors.profileCardColor,
            title: const Text(Strings.selectOption),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            children: <Widget>[
              SimpleDialogOption(
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.06,
                  vertical: displayWidth(context) * 0.04,
                ),
                onPressed: () async {
                  ImagePicker image = ImagePicker();
                  try {
                    XFile? filePath =
                        await image.pickImage(source: ImageSource.camera);
                    final bytes = Io.File(filePath!.path).readAsBytesSync();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PreviewImage(
                          path: base64Encode(bytes),
                        ),
                      ),
                    ).then((value) => Navigator.pop(context, true));
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                child: const Text(
                  Strings.cameraText,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.06,
                  vertical: displayWidth(context) * 0.04,
                ),
                onPressed: () async {
                  ImagePicker image = ImagePicker();
                  try {
                    XFile? filePath =
                        await image.pickImage(source: ImageSource.gallery);
                    final bytes = Io.File(filePath!.path).readAsBytesSync();
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreviewImage(
                                      path: base64Encode(bytes),
                                      myToken: deviceToken.value,
                                    )))
                        .then((value) => Navigator.pop(context, true));
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                child: const Text(
                  Strings.galleryText,
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          );
        },
      );
}
