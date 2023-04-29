import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';

import '../constant/sizer.dart';
import '../constant/strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AnimateIconController c1 = AnimateIconController();

  bool onEndIconPress(BuildContext context) {
    setState(() {
      drawer = false;
    });
    return true;
  }

  bool onStartIconPress(BuildContext context) {
    setState(() {
      drawer = true;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black45,
        child: Stack(
          children: [
            Container(
              height: displayHeight(context) * 0.06,
              margin: EdgeInsets.only(top: displayHeight(context) * 0.03),
              child: Center(
                  child: Text(
                Strings.tittleName,
                style: TextStyle(
                    fontSize: displayWidth(context) * 0.07,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              )),
            ),
            Container(
              width: displayWidth(context) * 0.25,
              height: displayHeight(context) * 0.25,
              margin: EdgeInsets.only(
                  left: displayWidth(context) * 0.38,
                  top: displayHeight(context) * 0.04),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image:
                      DecorationImage(image: AssetImage(Strings.avatarImage))),
            ),
            Container(
              width: displayWidth(context) * 0.4,
              height: displayWidth(context) * 0.08,
              margin: EdgeInsets.only(
                  left: displayWidth(context) * 0.31,
                  top: displayHeight(context) * 0.24),
              child: Center(
                child: Text(
                  Strings.userName,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50))),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: displayHeight(context) * 0.03,
                        left: displayWidth(context) * 0.07,
                        right: displayWidth(context) * 0.07),
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black45,
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
                        //prefixIconColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              width: drawer ? displayWidth(context) * 0.5 : 0,
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
                gradient: LinearGradient(
                  colors: [
                    Colors.black54,
                    Colors.transparent,
                  ],
                ),
              ),
              duration: const Duration(milliseconds: 300),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  drawer
                      ? Text(
                          Strings.profile,
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.05,
                            color: Colors.white,
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(
                        top: displayHeight(context) * 0.02,
                        bottom: displayHeight(context) * 0.02),
                    child: const Divider(
                      color: Colors.white,
                    ),
                  ),
                  drawer
                      ? Text(
                          Strings.aboutUs,
                          style: TextStyle(
                            fontSize: displayWidth(context) * 0.05,
                            color: Colors.white,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: displayHeight(context) * 0.03),
              child: AnimateIcons(
                startIcon: Icons.menu_rounded,
                endIcon: Icons.close_rounded,
                startIconColor: Colors.white,
                endIconColor: Colors.white,
                controller: c1,
                duration: const Duration(milliseconds: 300),
                size: displayWidth(context) * 0.07,
                onEndIconPress: () => onEndIconPress(context),
                onStartIconPress: () => onStartIconPress(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
