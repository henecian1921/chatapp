import 'package:chat_app/Model/ChatModel.dart';
import 'package:chat_app/Screens/IndividualPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCard extends StatelessWidget {

  const CustomCard({super.key, required this.chatModel, required this.sourchat});
  final ChatModel chatModel;
  final ChatModel sourchat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => IndividualPage(
          chatModel: chatModel,
          sourchat: sourchat,
        )));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: SvgPicture.asset(
                 chatModel.isGroup! ? "assets/group.svg": "assets/person.svg",
                height: 40,
                width: 40,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey[600],
            ),
            title: Text(
              "${chatModel.name}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(Icons.done_all),
                SizedBox(width: 5,),
                Text("${chatModel.currentMessage}",
                  style: TextStyle(
                    fontSize: 13,
                  ),),
              ],
            ),
            trailing: Text("${chatModel.time}"),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 80),
            child: Divider(thickness: 1,),
          )
        ],
      ),
    );
  }
}
