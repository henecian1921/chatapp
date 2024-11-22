import 'package:camera/camera.dart';
import 'package:chat_app/Screens/CameraScreen.dart';
import 'package:chat_app/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp( MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "OpenSans",
        primaryColor: Colors.blue,
        hintColor: Colors.blueAccent[100],
      ),
      home: LoginScreen()
    );
  }
}
