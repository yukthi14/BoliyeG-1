import 'dart:async';
import 'dart:math';

import 'package:boliye_g/bloc/bloc.dart';
import 'package:boliye_g/bloc/bloc_event.dart';
import 'package:boliye_g/bloc/bloc_state.dart';
import 'package:boliye_g/constant/color.dart';
import 'package:boliye_g/constant/sizer.dart';
import 'package:boliye_g/screens/homepage.dart';
import 'package:boliye_g/services/firebase_mass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../constant/strings.dart';

class ItemData {
  final Color color;
  ItemData(this.color);
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({
    super.key,
  });

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
        body: BlocProvider(
          create: (_) => _blocks,
          child: BlocBuilder<ChatBlocks, ChatState>(
            builder: (context, state) {
              if (state is IntroPage) {
                return body(context);
              } else if (state is HomeState) {
                return HomePage(name: state.name);
              } else {
                return splash(context);
              }
            },
          ),
        ));
  }

  Widget splash(context) {
    Timer(const Duration(seconds: 2), () {
      _blocks.add(InitialEvent());
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: displayWidth(context) * 0.65,
          height: displayHeight(context) * 0.3,
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: AssetImage('assets/splash_logo.gif'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
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
                : Container(
                    width: double.infinity,
                    color: data[index].color,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: displayHeight(context) * 0.08),
                          width: displayWidth(context) * 0.65,
                          height: displayHeight(context) * 0.3,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/img.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: displayWidth(context) * 0.08),
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
                              right: displayWidth(context) * 0.05),
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
                              top: displayHeight(context) * 0.07,
                              left: displayWidth(context) * 0.7),
                          child: TextButton(
                            onPressed: () {
                              if (_controller.text.isNotEmpty) {
                                firebaseMassage.getToken(
                                    userName: _controller.text);
                                Future.delayed(
                                        const Duration(milliseconds: 500))
                                    .then(
                                        (value) => _blocks.add(InitialEvent()));
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
          waveType: WaveType.liquidReveal,
          liquidController: liquidController,
          fullTransitionValue: 880,
          enableSideReveal: true,
          preferDragFromRevealedArea: true,
          enableLoop: false,
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
}
