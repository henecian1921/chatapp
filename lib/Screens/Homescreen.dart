import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/Pages/CameraPage.dart';
import 'package:chat_app/Pages/ChatPage.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  Homescreen({super.key, required this.chatmodels, required this.sourchat});
  final List<ChatModel> chatmodels;
  final ChatModel sourchat;

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with SingleTickerProviderStateMixin{
  late TabController _controller;
  late Function sendImage;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this,initialIndex: 0);
    sendImage = (String path) {
    };
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat IO',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(
                Icons.search,
                color: Colors.white,)
          ),
          PopupMenuButton<String>(
              onSelected: (value){
                print(value);
              },
              itemBuilder: (BuildContext context){
            return [
              PopupMenuItem(
                  child: Text("New group"),
                  value: "New group"),
              PopupMenuItem(
                  child: Text("New broadcast"),
                  value: "New broadcast"),
              PopupMenuItem(
                  child: Text("Whatsapp Web"),
                  value: "Whatsapp Web"),
              PopupMenuItem(
                  child: Text("Startted messages"),
                  value: "Startted messages"),
              PopupMenuItem(
                  child: Text("Settings"),
                  value: "Settings"),
            ];
          }),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              icon: Icon(Icons.camera_alt),
            ),
            Tab(
              text: "CHATS",
            ),
            Tab(
              text: "STATUS",
            ),
            Tab(
              text: "CALLS",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          CameraPage(sendImage: sendImage,),
          ChatPage(
            chatmodels: widget.chatmodels,
            sourchat: widget.sourchat,
          ),
          Text("Status"),
          Text("Calls"),
        ],
      ),
    );
  }
}

