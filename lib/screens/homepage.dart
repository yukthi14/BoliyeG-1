import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../constant/sizer.dart';
import '../constant/strings.dart';
import '../firebase/firebase_mass.dart';
import 'chating_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controllerSearch = TextEditingController();
  final ref = FirebaseDatabase.instance.ref('users');

  @override
  void initState() {
    setState(() {
      online = true;
    });
    FirebaseMassage().getToken();
    super.initState();
  }

  @override
  void dispose() {
    setState(() {
      online = false;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                    image: DecorationImage(
                        image: AssetImage(Strings.avatarImage))),
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
                          top: displayHeight(context) * 0.024,
                          left: displayWidth(context) * 0.07,
                          right: displayWidth(context) * 0.07),
                      child: TextField(
                        controller: _controllerSearch,
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
                      height: displayHeight(context) * 0.58,
                      width: displayHeight(context),
                      child: StreamBuilder<DatabaseEvent>(
                          stream: ref.onValue,
                          builder: (context, snapshot) {
                            var allUser = snapshot.data?.snapshot.children;
                            List userName = [];
                            List userKey = [];
                            allUser?.forEach((element) {
                              if (element.key != deviceToken) {
                                userName.add(element.value);
                                userKey.add(element.key);
                              }
                            });
                            return (userKey.isNotEmpty)
                                ? ListView.separated(
                                    itemCount: userKey.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          String msgToken =
                                              '${userKey[index]}@boliyegUser$deviceToken';
                                          String revToken =
                                              '$deviceToken@boliyegUser${userKey[index]}';
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  type: PageTransitionType
                                                      .topToBottom,
                                                  child: ChattingScreen(
                                                    msgToken: msgToken,
                                                    revMsgToken: revToken,
                                                    myToken: deviceToken,
                                                  )));
                                        },
                                        child: Container(
                                          color: Colors.white,
                                          height:
                                              displayHeight(context) * 0.075,
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: displayWidth(context) *
                                                    0.12,
                                                height: displayHeight(context) *
                                                    0.12,
                                                margin: EdgeInsets.only(
                                                  left: displayWidth(context) *
                                                      0.05,
                                                ),
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.blueAccent,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            Strings
                                                                .avatarImage))),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        displayWidth(context) *
                                                            0.2,
                                                    top:
                                                        displayHeight(context) *
                                                            0.025),
                                                child: Text(
                                                  userName[index]
                                                      [Strings.userName],
                                                  style: TextStyle(
                                                    fontSize:
                                                        displayWidth(context) *
                                                            0.05,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Divider(
                                      color: Colors.black,
                                    ),
                                  )
                                : const Center(
                                    child: Text('No User'),
                                  );
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
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
