import 'package:chat_app/CustomUI/AvatarCard.dart';
import 'package:chat_app/CustomUI/ContactCard.dart';
import 'package:chat_app/Model/ChatModel.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {

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

  List<ChatModel> groups = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New Group",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),),
            Text("Add participants",
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

        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: contacts.length+1,
              itemBuilder: (context, index)
              {
                if(index==0) {
                  return Container(
                    height: groups.length > 0 ? 90 : 10,
                  );
                }
                return InkWell(
                  onTap: (){
                    if(contacts[index-1].select == false) {
                      setState(() {
                        contacts[index-1].select = true;
                        groups.add(contacts[index-1]);
                      });
                    }
                    else {
                        setState(() {
                          contacts[index-1].select = false;
                          groups.remove(contacts[index-1]);
                        });
                    }
                  },
                  child: ContactCard(
                    contact: contacts[index-1],
                  ),
                );
              },
          ),
          groups.length>0 ? Column(
            children: [
              Container(
                height: 75,
                color: Colors.white,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    if (contacts[index].select == true)
                      {
                        return InkWell(
                          onTap: (){
                            setState(() {

                              groups.remove(contacts[index]);
                              contacts[index].select = false;
                            });
                          },
                            child: AvatarCard(contact: contacts[index]),
                        );
                      }
                    else
                      {
                        return Container();
                      }
                  }
                ),
              ),
              Divider(
                thickness: 1,
              ),
            ],
          ): Container(),
        ],
      ),
    );
  }
}
