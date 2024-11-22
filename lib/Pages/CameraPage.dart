import 'package:chat_app/Screens/CameraScreen.dart';
import 'package:flutter/material.dart';
class CameraPage extends StatelessWidget {
  CameraPage({super.key,required this.sendImage});
  Function sendImage;
  @override
  Widget build(BuildContext context) {
    return CameraScreen(sendImage: sendImage,);
  }
}
