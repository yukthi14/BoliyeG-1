import 'package:boliye_g/constant/sizer.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/strings.dart';
import '../screens/setting_screen.dart';
import '../services/firebase_mass.dart';

class AlertDialogBox extends StatefulWidget {
  const AlertDialogBox({
    Key? key,
    required this.title,
    required this.buttonString,
    required this.suggestionString,
    required this.myToken,
  }) : super(key: key);
  final String title;
  final String buttonString;
  final String suggestionString;
  final String myToken;

  @override
  State<AlertDialogBox> createState() => _AlertDialogBoxState();
}

class _AlertDialogBoxState extends State<AlertDialogBox> {
  final TextEditingController _controller = TextEditingController();
  bool _passwordVisible = true;

  @override
  void initState() {
    setState(() {
      isOpenAlertDialogBox = false;
    });
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff8585a2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: displayWidth(context) * 0.1,
              ),
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
      content: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: displayWidth(context) * 0.07),
            child: TextField(
              obscureText: !_passwordVisible,
              maxLength: 4,
              controller: _controller,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white60,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: displayWidth(context) * 0.6,
              top: displayHeight(context) * 0.01,
            ),
            child: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
        ],
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
                  width: displayWidth(context) * 0.39,
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
                    String code = await firebaseMassage.getPrivatePassword(
                      deviceToken: widget.myToken,
                    );
                    if (_controller.text == (code)) {
                      Navigator.pop(context);
                      setState(() {
                        openEnvelope = !openEnvelope;
                        Future.delayed(
                          const Duration(milliseconds: 300),
                        ).then((value) {
                          opening = !opening;
                        });
                      });
                    } else {
                      Fluttertoast.showToast(
                        msg: Strings.invalidPwdToast,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  } else {
                    if (_controller.text.length == 4) {
                      if (widget.myToken == '') {
                        Fluttertoast.showToast(msg: Strings.errorMsg);
                      } else {
                        firebaseMassage.setPrivatePassword(
                          pwd: _controller.text,
                          deviceToken: widget.myToken,
                        );
                        prefs
                            .setBool(Strings.submittedSecretCodeKey, true)
                            .whenComplete(() => Navigator.of(context).pop());
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: Strings.pwdSuggestion,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
