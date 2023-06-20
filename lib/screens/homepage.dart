import 'dart:convert';
import 'dart:io' as Io;

import 'package:boliye_g/bloc/home_bloc/bloc.dart';
import 'package:boliye_g/bloc/home_bloc/home_event.dart';
import 'package:boliye_g/bloc/home_bloc/home_state.dart';
import 'package:boliye_g/constant/color.dart';
import 'package:boliye_g/screens/profile_screen.dart';
import 'package:boliye_g/screens/setting_screen.dart';
import 'package:boliye_g/utils/preview_imd.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

import '../constant/sizer.dart';
import '../constant/strings.dart';
import 'chating_screen.dart';
import 'emoji_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    Key? key,
    required this.name,
    required this.imageString,
  }) : super(key: key);
  final String name;
  final String imageString;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controllerSearch = TextEditingController();
  final ref = FirebaseDatabase.instance.ref('users');
  final HomeScreenBloc _bloc = HomeScreenBloc();
  List userName = [];
  List userKey = [];
  Future<void> _refresh(
      bool reload, AsyncSnapshot<DatabaseEvent> snapshot) async {
    userName.clear();
    userKey.clear();
    var allUser = snapshot.data?.snapshot.children;
    allUser?.forEach((element) {
      if (element.key != deviceToken.value) {
        userName.add(element.value);
        userKey.add(element.key);
      }
    });
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    _bloc.add(HomeProfileEvent());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _globalKey,
      drawer: Drawer(
          width: displayWidth(context) * 0.5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(35),
                  bottomRight: Radius.circular(35))),
          backgroundColor: const Color(0xffbcbcd1),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: displayHeight(context) * 0.05,
                ),
                width: displayWidth(context) * 0.55,
                height: displayHeight(context) * 0.18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber.shade200,
                  image: DecorationImage(
                    image: MemoryImage(
                      base64Decode(imageString),
                    ),
                  ),
                ),
              ),
              Container(
                width: displayWidth(context) * 0.13,
                height: displayHeight(context) * 0.06,
                margin: EdgeInsets.only(
                    top: displayHeight(context) * 0.19,
                    left: displayWidth(context) * 0.35),
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
              Padding(
                padding: EdgeInsets.only(top: displayHeight(context) * 0.24),
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text(Strings.profile),
                      leading: const Icon(
                        Icons.people,
                        color: Colors.black,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                duration: const Duration(milliseconds: 300),
                                type: PageTransitionType.rightToLeft,
                                child: const ProfilePage()));
                        // Navigator.pop(context);
                      },
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.settings_suggest_rounded,
                        color: Colors.black,
                      ),
                      title: const Text(Strings.setting),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                duration: const Duration(milliseconds: 300),
                                type: PageTransitionType.rightToLeft,
                                child: const SettingPage()));
                        // Navigator.pop(context);
                      },
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 0.2,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: displayHeight(context) * 0.48),
                      child: ListTile(
                        trailing: const Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        title: const Text(
                          Strings.logOut,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
      body: Container(
        color: AppColors.profileCardColor,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: displayHeight(context) * 0.03,
                  left: displayWidth(context) * 0.01),
              child: IconButton(
                  onPressed: () {
                    //_globalKey.currentState?.openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: displayWidth(context) * 0.07,
                  )),
            ),
            Container(
              height: displayHeight(context) * 0.06,
              margin: EdgeInsets.only(top: displayHeight(context) * 0.03),
              child: Center(
                child: Text(
                  Strings.tittleName,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.07,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              width: displayWidth(context) * 0.3,
              height: displayHeight(context) * 0.3,
              margin: EdgeInsets.only(
                  left: displayWidth(context) * 0.35,
                  top: displayHeight(context) * 0.02),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.scaffoldColor, width: 2),
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  image: MemoryImage(
                    base64Decode(imageString),
                  ),
                ),
              ),
            ),
            Container(
              width: displayWidth(context) * 0.4,
              height: displayWidth(context) * 0.08,
              margin: EdgeInsets.only(
                  left: displayWidth(context) * 0.31,
                  top: displayHeight(context) * 0.24),
              child: Center(
                child: Text(
                  (name == '') ? Strings.userName : name,
                  style: TextStyle(
                    fontSize: displayWidth(context) * 0.05,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: displayHeight(context) * 0.3),
              height: displayHeight(context) * 0.7,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.backgroundColor,
                    begin: Alignment.topCenter,
                    end: Alignment(0.8, 2),
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: displayHeight(context) * 0.02,
                          left: displayWidth(context) * 0.07,
                          right: displayWidth(context) * 0.07),
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 32.0,
                            // offset: Offset(0, 20),
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _controllerSearch,
                        keyboardType: TextInputType.multiline,
                        cursorColor: Colors.black,
                        maxLines: 1,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.textFieldColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: Strings.searchBar,
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    BlocProvider(
                      create: (_) => _bloc,
                      child: BlocBuilder<HomeScreenBloc, HomeState>(
                        builder: (context, state) {
                          if (state is HomeUserState) {
                            return usersBody(context);
                          } else if (state is HomeUserWithNoInternetState) {
                            return noInternet(context);
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

<<<<<<< Updated upstream
  Widget usersBody(context) {
    return SizedBox(
      height: displayHeight(context) * 0.58,
      child: StreamBuilder<DatabaseEvent>(
          stream: ref.onValue,
          builder: (context, snapshot) {
            userName.clear();
            userKey.clear();
            var allUser = snapshot.data?.snapshot.children;
            allUser?.forEach((element) {
              if (element.key != deviceToken.value) {
                userName.add(element.value);
                userKey.add(element.key);
              }
            });
            return RefreshIndicator(
              onRefresh: () async {
                await _refresh(true, snapshot);
              },
              color: Colors.black,
              backgroundColor: AppColors.refresherColor,
              child: ListView.builder(
                itemCount: userKey.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      String msgToken =
                          '${userKey[index]}${Strings.middleOfMessageToken}${deviceToken.value}';
                      String revToken =
                          '${deviceToken.value}${Strings.middleOfMessageToken}${userKey[index]}';
                      Navigator.push(
                        context,
                        PageTransition(
                          duration: const Duration(milliseconds: 300),
                          type: PageTransitionType.topToBottom,
                          child: ChattingScreen(
                            msgToken: msgToken,
                            revMsgToken: revToken,
                            myToken: deviceToken.value,
                            name: userName[index][Strings.userName],
                            image: userName[index][Strings.profileImg],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 2),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.deepPurple.shade300,
                        ),
                      ),
                      height: displayHeight(context) * 0.075,
                      child: Stack(
                        children: [
                          Container(
                            width: displayWidth(context) * 0.12,
                            height: displayHeight(context) * 0.12,
                            margin: EdgeInsets.only(
                              left: displayWidth(context) * 0.05,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueAccent,
                              image: DecorationImage(
                                image: MemoryImage(base64Decode(
                                    userName[index][Strings.profileImg])),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: displayWidth(context) * 0.2,
                                top: displayHeight(context) * 0.025),
                            child: Text(
                              userName[index][Strings.userName],
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.05,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }

  Widget notInternet(context) {
    return SizedBox(
      height: displayHeight(context) * 0.58,
      child: StreamBuilder<List<Map<String, Object?>>>(
          stream: usersStreaming.stream,
          builder: (context, snapshot) {
            userName.clear();
            userKey.clear();
            List userImage = [];
            var allUser = snapshot.data;
            userImage.clear();
            for (int i = 0; i < allUser!.length; i++) {
              print(allUser[i]['userToken']);
              userName.add(allUser[i]['name']);
              userKey.add(allUser[i]['userToken']);
              userImage.add(allUser[i]['photoName']);
            }
            print(userKey.length);
            return RefreshIndicator(
              onRefresh: () async {
                // await _refresh(true, snapshot);
              },
              color: Colors.black,
              backgroundColor: AppColors.refresherColor,
              child: ListView.builder(
                itemCount: allUser.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      String msgToken =
                          '${allUser[index]['userToken']}${Strings.middleOfMessageToken}${deviceToken.value}';
                      String revToken =
                          '${deviceToken.value}${Strings.middleOfMessageToken}${allUser[index]['userToken']}';
                      Navigator.push(
                        context,
                        PageTransition(
                          duration: const Duration(milliseconds: 300),
                          type: PageTransitionType.topToBottom,
                          child: ChattingScreen(
                            msgToken: msgToken,
                            revMsgToken: revToken,
                            myToken: deviceToken.value,
                            name: userName[index],
                            image: userImage[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 2),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.deepPurple.shade300,
                        ),
                      ),
                      height: displayHeight(context) * 0.075,
                      child: Stack(
                        children: [
                          Container(
                            width: displayWidth(context) * 0.12,
                            height: displayHeight(context) * 0.12,
                            margin: EdgeInsets.only(
                              left: displayWidth(context) * 0.05,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueAccent,
                              image: DecorationImage(
                                image:
                                    MemoryImage(base64Decode(userImage[index])),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: displayWidth(context) * 0.2,
                                top: displayHeight(context) * 0.025),
                            child: Text(
                              userName[index],
                              style: TextStyle(
                                fontSize: displayWidth(context) * 0.05,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }

  Widget noInternet(context) {
    return Column(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top: displayHeight(context) * 0.1),
            width: displayWidth(context) * 0.4,
            height: displayHeight(context) * 0.2,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(Strings.sadImg), fit: BoxFit.fill)),
          ),
        ),
        Container(
          width: displayWidth(context) * 1,
          height: displayHeight(context) * 0.05,
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage(Strings.shadow))),
        ),
        const Text(
          Strings.errorInternetMsg,
          style: TextStyle(fontSize: 20, color: Colors.redAccent),
        )
      ],
    );
  }

  void showCustomDialog(BuildContext context) => showDialog(
=======
  showCustomDialog(BuildContext context) => showDialog(
>>>>>>> Stashed changes
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
                                  myToken: deviceToken.value,
                                  name: name,
                                )));
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
                                  name: name,
                                )));
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
              ),
              SimpleDialogOption(
                padding: EdgeInsets.symmetric(
                  horizontal: displayWidth(context) * 0.06,
                  vertical: displayWidth(context) * 0.04,
                ),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EmojiPage()));
                },
                child: const Text(
                  Strings.emojiText,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          );
        },
      );
}
