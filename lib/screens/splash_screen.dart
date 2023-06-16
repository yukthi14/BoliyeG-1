import 'dart:async';

import 'package:boliye_g/bloc/initiate_state_bloc/bloc.dart';
import 'package:boliye_g/screens/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/initiate_state_bloc/bloc_event.dart';
import '../bloc/initiate_state_bloc/bloc_state.dart';
import '../constant/sizer.dart';
import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ChatBlocks _blocks = ChatBlocks();

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      _blocks.add(InitialEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider(
        create: (_) => _blocks,
        child: BlocBuilder<ChatBlocks, ChatState>(
          builder: (context, state) {
            if (state is HomeState) {
              print(
                  'helooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
              return HomeScreen(name: state.name, imageString: state.image);
            } else if (state is IntroPage) {
              return const IntroScreen();
            } else {
              return body(context);
            }
          },
        ),
      ),
    );
  }

  Widget body(context) {
    return Center(
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
    );
  }
}
