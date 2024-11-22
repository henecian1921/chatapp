import 'package:camera/camera.dart';
import 'package:chat_app/Screens/CameraView.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


List<CameraDescription>? cameras;

class CameraScreen extends StatefulWidget {
  CameraScreen({super.key, required this.sendImage});
  Function sendImage;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;

  late Future<void> cameraValue;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController = CameraController(cameras![0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _cameraController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(future: cameraValue, builder: (context, snapshot) {
            if (snapshot.connectionState==ConnectionState.done) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(_cameraController));
            }
            else
              {
                return Center(child: CircularProgressIndicator(),
                );
              }
          }),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.only(
                top: 5, bottom: 5
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: (){

                      },
                          icon: Icon(Icons.flash_off, color: Colors.white, size: 30,)
                      ),
                      GestureDetector(
                        /// Chưa quay được video
                        // onLongPress: () async {
                        //   final path = join((await getTemporaryDirectory()).path, "${DateTime.now()}.mp4");
                        //   XFile video = await _cameraController.startVideoRecording(path);
                        //   video.saveTo(path);
                        // },
                          onLongPressUp: (){},

                        onTap: (){
                          takePhoto(context);
                          },

                        child:
                         Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.white,
                          size: 75,)
                        ),

                      IconButton(
                          onPressed: (){
                          },
                          icon: Icon(Icons.flip_camera_ios, color: Colors.white, size: 30,)
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text("Hold for Video, tap for photo",style: TextStyle(
                    color: Colors.white,
                  ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void takePhoto(BuildContext context) async {
    final path = join((await getTemporaryDirectory()).path, "${DateTime.now()}.png");
    XFile picture = await _cameraController.takePicture();
    picture.saveTo(path);
    
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder)=> CameraViewPage(
              path: picture.path,
              sendImage: widget.sendImage,
            )
        )
    );
  }
}
