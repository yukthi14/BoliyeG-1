import 'package:boliye_g/constant/sizer.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/strings.dart';
import '../dataBase/firebase_mass.dart';
import '../screens/setting_screen.dart';

class AlertDialogBox extends StatefulWidget {
  const AlertDialogBox({
    Key? key,
    required this.title,
    required this.buttonString,
    required this.suggestionString,
  }) : super(key: key);
  final String title;
  final String buttonString;
  final String suggestionString;
  @override
  State<AlertDialogBox> createState() => _AlertDialogBoxState();
}

class _AlertDialogBoxState extends State<AlertDialogBox> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff8585a2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: displayWidth(context) * 0.09,
                  right: displayWidth(context) * 0.1),
              child: ClayContainer(
                width: displayWidth(context) * 0.4,
                height: displayHeight(context) * 0.05,
                borderRadius: 10,
                color: const Color(0xff8585a2),
                child: Center(
                  child: ClayText(
                    widget.title,
                    size: displayWidth(context) * 0.05,
                    emboss: true,
                    color: Colors.black,
                    parentColor: const Color(0xff626294),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: ClayContainer(
                color: const Color(0xff8585a2),
                height: displayHeight(context) * 0.03,
                width: displayWidth(context) * 0.07,
                borderRadius: 75,
                depth: 40,
                spread: 10,
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.black,
                  weight: 40,
                ),
              ),
            ),
          ],
        ),
      ),
      content: TextField(
        maxLength: 4,
        controller: _controller,
        keyboardType: TextInputType.number,
        cursorColor: Colors.black,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xff626294),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: displayWidth(context) * 0.02),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          duration: const Duration(milliseconds: 300),
                          type: PageTransitionType.rightToLeft,
                          child: const SettingPage()));
                },
                child: ClayContainer(
                  width: displayWidth(context) * 0.3,
                  height: displayHeight(context) * 0.03,
                  borderRadius: 10,
                  color: const Color(0xff8585a2),
                  child: const Center(
                    child: Text(
                      Strings.changePwd,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            ClayContainer(
              width: displayWidth(context) * 0.2,
              height: displayHeight(context) * 0.05,
              borderRadius: 40,
              color: const Color(0xff8585a2),
              child: TextButton(
                child: Text(
                  widget.buttonString,
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  if (widget.buttonString == Strings.openEnvelope) {
                    if (_controller.text ==
                        prefs.getString(Strings.secretCodeKey)) {
                      setState(() {
                        openEnvelope = !openEnvelope;
                        Future.delayed(
                          const Duration(milliseconds: 300),
                        ).then((value) {
                          opening = !opening;
                        });
                      });
                    }
                  } else {
                    firebaseMassage.setPrivatePassword(pwd: _controller.text);
                    prefs.setBool(Strings.submittedSecretCodeKey, true);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
