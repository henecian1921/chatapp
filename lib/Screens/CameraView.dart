import 'dart:io';
import 'package:flutter/material.dart';

class CameraViewPage extends StatelessWidget {
  const CameraViewPage({super.key, required this.path, required this.sendImage,});

  static TextEditingController _controller = TextEditingController();
  final String path;
  final Function sendImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.crop_rotate, size: 27,)
          ),
          IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.emoji_emotions_outlined, size: 27,)
          ),
          IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.title, size: 27,)
          ),
          IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.edit, size: 27,)
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height-165,
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black38,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                child: TextFormField(
                  controller: _controller,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17
                  ),
                  maxLines: 6,
                  minLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.add_photo_alternate,
                      color: Colors.white,
                      size: 27,
                    ),
                    suffixIcon: InkWell(
                      onTap: (){
                        sendImage(File(path), _controller.text.trim());
                        _controller.clear();
                      },
                      child: CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.tealAccent[700],
                        child: Icon(Icons.check, color: Colors.white, size: 27,),
                      ),
                    ),
                    hintText: "Add Caption...",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 17
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
