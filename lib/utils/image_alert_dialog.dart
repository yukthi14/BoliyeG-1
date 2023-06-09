import 'package:boliye_g/constant/sizer.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageDialogBox extends StatefulWidget {
  const ImageDialogBox({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageDialogBox> createState() => _ImageDialogBoxState();
}

class _ImageDialogBoxState extends State<ImageDialogBox> {
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
                left: displayWidth(context) * 0.07,
              ),
              child: ClayContainer(
                width: displayWidth(context) * 0.4,
                height: displayHeight(context) * 0.05,
                borderRadius: 10,
                color: const Color(0xff8585a2),
                child: Center(
                  child: ClayText(
                    'Pick Image',
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
              child: Padding(
                padding: EdgeInsets.only(
                  left: displayWidth(context) * 0.05,
                ),
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
            ),
          ],
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () async {
              try {
                ImagePicker pick = ImagePicker();
                XFile? path = await pick.pickImage(source: ImageSource.camera);
              } catch (e) {
                print(e.toString());
              }
            },
            child: ClayContainer(
              width: displayWidth(context) * 0.2,
              height: displayHeight(context) * 0.1,
              borderRadius: 10,
              color: const Color(0xff8585a2),
              child: Center(
                child: ClayText(
                  'Camera',
                  size: displayWidth(context) * 0.05,
                  emboss: true,
                  color: Colors.black,
                  parentColor: const Color(0xff626294),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              try {
                ImagePicker pick = ImagePicker();
                XFile? path = await pick.pickImage(source: ImageSource.gallery);
              } catch (e) {
                print(e.toString());
              }
            },
            child: ClayContainer(
              width: displayWidth(context) * 0.2,
              height: displayHeight(context) * 0.1,
              borderRadius: 10,
              color: const Color(0xff8585a2),
              child: Center(
                child: ClayText(
                  'Gallery',
                  size: displayWidth(context) * 0.05,
                  emboss: true,
                  color: Colors.black,
                  parentColor: const Color(0xff626294),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
