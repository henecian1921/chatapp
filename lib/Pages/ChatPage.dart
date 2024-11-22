// ignore_for_file: duplicate_import

import 'package:chat_app/CustomUI/CustomCard.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/Screens/SelectContact.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/CustomUI/CustomCard.dart';


class ChatPage extends StatefulWidget {
  ChatPage({super.key, required this.chatmodels, required this.sourchat});
  final List<ChatModel> chatmodels;
  final ChatModel sourchat;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (builder)=> SelectContact()));
        },
        backgroundColor: Colors.blue[500],
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),

      body: ListView.builder(
        itemCount: widget.chatmodels.length,
        itemBuilder: (context,index)=> CustomCard(
            chatModel:widget.chatmodels[index],
          sourchat: widget.sourchat,
        ),
      ),

    );
  }
}
