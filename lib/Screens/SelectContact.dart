import 'package:chat_app/CustomUI/ButtonCard.dart';
import 'package:chat_app/CustomUI/ContactCard.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/Screens/CreateGroup.dart';
import 'package:flutter/material.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({super.key});

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {

  @override
  Widget build(BuildContext context) {
    List<ChatModel> contacts = [
      ChatModel(
        name: "An 1",
        status: "Developer"
      ),
      ChatModel(
        name: "An 2",
        status: "Intern"
      ),
      ChatModel(
        name: "An 3",
        status: "Senior"
      ),
      ChatModel(
        name: "An 4",
        status: "Junior"
      ),
      ChatModel(
        name: "An 5",
        status: "Master"
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Contact",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),),
            Text("256 contacts",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: (){

              },
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 26,
              )
          ),
          PopupMenuButton<String>(
              onSelected: (value){
                print(value);
              },
              itemBuilder: (BuildContext context)
              {
                return [
                  PopupMenuItem(
                      child: Text("Invite a friend"),
                      value: "Invite a friend"),
                  PopupMenuItem(
                      child: Text("Contacts"),
                      value: "Contacts"),
                  PopupMenuItem(
                      child: Text("Refresh"),
                      value: "Refresh"),
                  PopupMenuItem(
                      child: Text("Help"),
                      value: "Help"),
                ];
              }
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length+2,
        itemBuilder: (context, index)
        {
          if(index==0)
            {
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => CreateGroup()));
                },
                child: ButtonCard(
                  icon: Icons.group,
                  name: "New group",
                ),
              );
            }
          else if(index == 1) {
            return ButtonCard(
              icon: Icons.person_add,
              name: "New contact",
            );
          }
          return ContactCard(
              contact: contacts[index-2],
          );
        }
      ),
    );
  }
}
