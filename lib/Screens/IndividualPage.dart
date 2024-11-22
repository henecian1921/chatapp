import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_app/CustomUI/OwnImageCard.dart';
import 'package:chat_app/CustomUI/OwnMessageCard.dart';
import 'package:chat_app/CustomUI/ReplyCard.dart';
import 'package:chat_app/CustomUI/ReplyImageCard.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/Model/MessageModel.dart';
import 'package:chat_app/Screens/CameraScreen.dart';
import 'package:chat_app/Screens/CameraView.dart';
import 'package:chat_app/Screens/IncomingCallScreen.dart';
import 'package:chat_app/Screens/VideoCallScreen.dart';
import 'package:chat_app/const.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class IndividualPage extends StatefulWidget {
  const IndividualPage({super.key, required this.chatModel, required this.sourchat,});
  final ChatModel chatModel;
  final ChatModel sourchat;

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  late IO.Socket socket;

  late XFile? file;
  int popTime =0;

  bool sendButton = false;
  File? image;
  final picker = ImagePicker();
  String? url;
  int? roomID;

  List<MessageModel> messages = [];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus)
        {
          setState((){
            show = false;
          });
        }
    });
    connect();
  }

  void connect()
  {
    // socket = IO.io("$host:5000/", <String, dynamic>{
    socket = IO.io("$server", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
      "query": {
        "userId":"${widget.sourchat.id}"
      }
    });

    socket.connect();
    socket.emit("signin", widget.sourchat.id);

    socket.onConnect((data) {
      print("Connected");
      socket.on("message", (msg) {
        print(msg);
        setMessage("destination", msg["message"], msg["path"],"");
      });

      socket.on("upload-success", (resData) {
        //print(resData["image"] as String);
        String enCode= jsonEncode(resData);
        print(enCode);
        setMessage("image", resData["message"].toString(), "", resData["image"].toString());
      });

      socket.on('incoming_call', (data) {
        String callerId = data['callerId'];
        String roomId = data['roomId'];

        // Hiển thị màn hình thông báo cuộc gọi
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => IncomingCallScreen(
              socket: socket,
              callerId: callerId,
              roomId: roomId,
            ),
          ),
        );
      });

      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });

    print(socket.connected);
  }

  void sendMessage(String message, int sourceId, int targetId, String path){
    setMessage("source", message, path,"");
    roomID = sourceId.toInt()+ targetId.toInt();
    print(roomID);
    socket.emit("message",
        {"message":message,
          "sourceId": sourceId,
          "targetId": targetId,
          "path": path,
          "roomID": roomID
        });

  }

  void sendImage(File image, String message) async {
    for(int i = 0; i<popTime;i++) {
      Navigator.pop(context);
    }
    setState(() {
      popTime = 0;
    });
    List<int> imageBytes = await image.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    String fileName = image.path.split('/').last;

    setMessage("source", message, image.path, "");
    socket.emit('upload-file', {
      'image': base64Image,
      'filename': fileName,
      "sourceId": widget.sourchat.id,
      "targetId": widget.chatModel.id,
      "message": messages,
    });

    print("Gui thanh cong");
  }

  void setMessage(String type, String message, String path, String URL){
    MessageModel messageModel = MessageModel(
        message: message,
        type: type,
        time: DateTime.now().toString().substring(10,16),
        path: path,
        URL: URL
    );
    if (mounted) setState(() {
      messages.add(messageModel);
    });
  }

  @override
  void dispose() {
    //Hủy bỏ các listener và kết nối socket khi widget bị hủy
    focusNode.removeListener(() {});
    focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    socket.dispose(); // Hủy kết nối socket
    super.dispose();
  }

  void onFileSend(File file) async {
    String fileName = file.path.split('/').last;
    List<int> fileBytes = await file.readAsBytes();
    String base64File = base64Encode(fileBytes);

    socket.emit("send_file", {
      "file": base64File,
      "fileName": fileName,
      "sourceId": widget.sourchat.id,
      "targetId": widget.chatModel.id,
    });

    // Optionally: Add file to local chat history
    MessageModel messageModel = MessageModel(
      message: fileName,
      type: "file",
      time: DateTime.now().toString().substring(10, 16),
      path: "",
      URL: ""
    );
    setState(() {
      messages.add(messageModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
            'assets/background1.png',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              leadingWidth: 70,
              titleSpacing: 0,
              backgroundColor: Colors.blue[600],
              leading: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24,),
                    CircleAvatar(
                      child: SvgPicture.asset(
                        widget.chatModel.isGroup! ? "assets/group.svg": "assets/person.svg",
                        height: 35,
                        width: 35,
                        color: Colors.white,
                      ),
                      radius: 20,
                      backgroundColor: Colors.blueGrey[300],
                    )
                  ],
                ),
              ),
              title: InkWell(
                onTap: (){},
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.chatModel.name}",
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                      Text(
                          "Last seen today at 12:05",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VideoCallScreen(roomId: roomID.toString())),
                      );
                    },
                    icon: Icon(Icons.videocam, color: Colors.white,)
                ),
                IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.call, color: Colors.white)
                ),
                PopupMenuButton<String>(
                    onSelected: (value){
                      print(value);
                    },
                    iconColor: Colors.white,
                    itemBuilder: (BuildContext context){
                      return [
                        PopupMenuItem(
                            child: Text("View contact"),
                            value: "View contact"),
                        PopupMenuItem(
                            child: Text("Media, links and docs"),
                            value: "Media, links and docs"),
                        PopupMenuItem(
                            child: Text("Search"),
                            value: "Search"),
                        PopupMenuItem(
                            child: Text("Mute Notification"),
                            value: "Mute Notification"),
                        PopupMenuItem(
                            child: Text("Wallpaper"),
                            value: "Wallpaper"),
                      ];
                    }
                    ),
              ],
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
              child: Column(
                children: [
                  Expanded(
                    // height: MediaQuery.of(context).size.height - 170,
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: messages.length + 1,
                      itemBuilder: (context, index) {
                        if(index==messages.length) {
                          return Container(height: 70,);
                        }
                        if(messages[index].type == "source"){
                          if(messages[index].path.length >0) {
                            return OwnImageCard(
                              path: messages[index].path,
                              message: messages[index].message,
                              time: messages[index].time,
                            );
                          }
                           else {
                            return OwnMessageCard(
                              message: messages[index].message,
                              time: messages[index].time,
                            );
                          }

                        } else {
                          if(messages[index].URL.length >0) {
                            print("Nhan hinh anh");
                            return ReplyImageCard(
                              path: messages[index].path,
                              message: messages[index].message,
                              time: messages[index].time,
                              url: messages[index].URL,
                            );
                          }
                           else {
                            print("Nhan tin nhan");
                            return ReplyCard(
                              message: messages[index].message,
                              time: messages[index].time,
                            );
                          }
                        }
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width - 60,
                                child: Card(
                                  margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                    child: TextFormField(
                                      controller: _controller,
                                      focusNode: focusNode,
                                      textAlignVertical: TextAlignVertical.center,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 5,
                                      minLines: 1,
                                      onChanged: (value){
                                        if(value.length>0) {
                                          setState(() {
                                            sendButton = true;
                                          });
                                        }
                                        else {
                                          setState(() {
                                            sendButton = false;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Type a message",
                                        prefixIcon: IconButton(
                                          icon: Icon(
                                              Icons.emoji_emotions),
                                          color: Colors.blue,
                                        onPressed: (){
                                            setState(() {
                                              focusNode.unfocus();
                                              focusNode.canRequestFocus = false;
                                              show = !show;
                                            });
                                        },
                                        ),
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: (){
                                                  showModalBottomSheet(
                                                      backgroundColor: Colors.transparent,
                                                      context: context,
                                                      builder: (builder)=> bottomSheet());
                                                },
                                                icon: Icon(Icons.attach_file),
                                                color: Colors.blue,
                                            ),
                                            IconButton(
                                                onPressed: (){
                                                  setState(() {
                                                    popTime = 2;
                                                  });
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (builder)=> CameraScreen(
                                                        sendImage: sendImage,
                                                      ))
                                                  );
                                                },
                                                icon: Icon(Icons.camera_alt),
                                                color: Colors.blue,
                                            )
                                          ],
                                        ),
                                        contentPadding: EdgeInsets.all(5),
                                      ),
                                    )
                                ),
                              ),
                              SizedBox(width: 5,),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8, right: 2),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 24,
                                  child: IconButton(
                                    icon: Icon(
                                        sendButton ? Icons.send : Icons.mic,
                                    ),
                                    onPressed: (){
                                      if(sendButton) {
                                        _scrollController.animateTo(
                                            _scrollController.position.maxScrollExtent,
                                            duration: Duration(milliseconds: 300),
                                            curve: Curves.easeOut);
                                        sendMessage(
                                            _controller.text,
                                            widget.sourchat.id!,
                                            widget.chatModel.id!,
                                            ""
                                        );
                                        _controller.clear();
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          show ? emojiSelect() : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onWillPop: (){
                if(show) {
                  setState(() {
                    show = false;
                  });
                }
                else {
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 280,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.insert_drive_file, Colors.indigo, "Document", ()async{
                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      File file = File(result.files.single.path!);
                      onFileSend(file);
                    } else {
                      print("No file selected.");
                    }
                  }),
                  SizedBox(width: 50,),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera", ()async{
                    setState(() {
                      popTime = 3;
                    });
                    Navigator.push(context, MaterialPageRoute(
                      builder: (builder)=> CameraScreen(
                        sendImage: sendImage,
                      ),
                    ));
                  }),
                  SizedBox(width: 50,),
                  iconCreation(
                      Icons.insert_photo,
                      Colors.purple,
                      "Gallery",
                      () async {
                        setState(() {
                          popTime =2;
                        });
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() {
                            image = File(pickedFile.path);
                          });
                          print(pickedFile.path);
                          Navigator.push(context, MaterialPageRoute(builder: (builder) =>
                              CameraViewPage(
                                  path: pickedFile.path,
                                  sendImage: sendImage,
                              )
                          ));
                        }
                  }),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headphones, Colors.orange, "Audio", ()async{
                    print("Audio");
                  }),
                  SizedBox(width: 50,),
                  iconCreation(Icons.location_pin, Colors.teal, "Location", ()async{
                    print("Location");
                  }),
                  SizedBox(width: 50,),
                  iconCreation(Icons.person, Colors.blue, "Contact", ()async{
                    print("Contact");
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icon, Color color, String text, Future<void> Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5,),
          Text(text,
          style: TextStyle(
            fontSize: 12
          ),),
        ],
      ),
    );
  }

  Widget emojiSelect() {
    return EmojiPicker(
      config: Config(
        emojiViewConfig: EmojiViewConfig(
          columns: 7,
          recentsLimit: 28,
        ),
      ),
      onEmojiSelected: (Category? category, Emoji emoji){
        print(emoji.emoji);
        setState(() {
          _controller.text = _controller.text + emoji.emoji;
        });
      }
    );
  }
}
