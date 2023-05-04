import 'package:boliye_g/screens/chating_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/sizer.dart';
import '../constant/strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    getToken();
    super.initState();
  }

  getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ref = FirebaseDatabase.instance.ref();
    if (prefs.get('token') == null) {
      try {
        print(
            "jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj");
        await FirebaseMessaging.instance.getToken().then((tokenValue) async {
          print(
              "jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjkkkkkjjjjjjjjjjjjjjjj");
          if (tokenValue.toString().isEmpty) {
            print("Error in generate token");
          } else {
            print(tokenValue);
            prefs.setString("token", tokenValue!);
            await ref
                .child('users')
                .child(tokenValue)
                .set({'userName': 'vishwajeet'});
          }
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _globalKey,
      drawer: Drawer(
        width: displayWidth(context) * 0.5,
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(top: displayHeight(context) * 0.1),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: const Text(Strings.profile),
                onTap: () {
                  // Navigator.pop(context);
                },
              ),
              const Divider(
                color: Colors.black,
                thickness: 0.2,
              ),
              ListTile(
                title: const Text(Strings.setting),
                onTap: () {
                  // Navigator.pop(context);
                },
              ),
              const Divider(
                color: Colors.black,
                thickness: 0.2,
              ),
              ListTile(
                title: const Text(Strings.aboutUs),
                onTap: () async {},
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.black45,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: displayHeight(context) * 0.03,
                  left: displayWidth(context) * 0.01),
              child: IconButton(
                  onPressed: () {
                    _globalKey.currentState?.openDrawer();
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
                      ),
                    ),
                  ),
                  SizedBox(
                    height: displayHeight(context) * 0.6,
                    width: displayHeight(context),
                    child: ListView.separated(
                      itemCount: 100,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    duration: const Duration(milliseconds: 300),
                                    type: PageTransitionType.topToBottom,
                                    child: const ChattingScreen()));
                          },
                          child: Container(
                            color: Colors.white,
                            height: displayHeight(context) * 0.075,
                            child: Stack(
                              children: [
                                Container(
                                  width: displayWidth(context) * 0.12,
                                  height: displayHeight(context) * 0.12,
                                  margin: EdgeInsets.only(
                                    left: displayWidth(context) * 0.05,
                                  ),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blueAccent,
                                      image: DecorationImage(
                                          image:
                                              AssetImage(Strings.avatarImage))),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: displayWidth(context) * 0.2,
                                      top: displayHeight(context) * 0.025),
                                  child: Text(
                                    Strings.userName,
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
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
// Widget openDrawer(BuildContext context) {
//   return Drawer(
//     backgroundColor: Colors.transparent,
//     child: Padding(
//       padding:  EdgeInsets.only(top: displayHeight(context)*0.1),
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//
//           ListTile(
//             title: const Text('Profile'),
//             onTap: () {
//               // Navigator.pop(context);
//             },
//           ),
//           const Divider(
//             color: Colors.black,
//             thickness: 0.2,
//           ),
//           ListTile(
//             title: const Text('Records'),
//             onTap: () {
//             },
//           ),
//           const Divider(
//             color: Colors.black,
//             thickness: 0.2,
//           ),
//           ListTile(
//             title: const Text('About Us'),
//             onTap: () async {
//             },
//           ),
//           const Divider(
//             color: Colors.black,
//             thickness: 0.2,
//           ),
//           ListTile(
//             title: const Text('More app'),
//             onTap: () {
//             },
//           ),
//         ],
//       ),
//     ),
//   );
// }
}
