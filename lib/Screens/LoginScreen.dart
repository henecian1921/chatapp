import 'package:chat_app/CustomUI/ButtonCard.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/Screens/Homescreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ChatModel sourceChat;

  List<ChatModel> chatmodels = [
    ChatModel(
        name: "An 1",
        isGroup: false,
        currentMessage: "Hello world",
        time: "10:00",
        icon: "person.svg",
        id: 1,
    ),
    ChatModel(
        name: "An 3",
        isGroup: false,
        currentMessage: "Hello",
        time: "09:00",
        icon: "person.svg",
      id: 2
    ),

    ChatModel(
        name: "An 5",
        isGroup: false,
        currentMessage: "Hello my name's An",
        time: "06:30",
        icon: "person.svg",
      id: 3
    ),

    ChatModel(
        name: "An 7",
        isGroup: false,
        currentMessage: "Test demo",
        time: "03:00",
        icon: "person.svg",
      id: 4
    ),

    // ChatModel(
    //     name: "An 9",
    //     isGroup: true,
    //     currentMessage: "How are you today?",
    //     time: "01:50",
    //     icon: "group.svg"
    // ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: chatmodels.length,
          itemBuilder: (context, index)=> InkWell(
            onTap: (){
              sourceChat = chatmodels.removeAt(index);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=> Homescreen(
                chatmodels: chatmodels,
                sourchat: sourceChat,
              )));
            },
            child: ButtonCard(
                name: chatmodels[index].name!,
                icon: Icons.person
            ),
          )
      ),
    );
  }
}
