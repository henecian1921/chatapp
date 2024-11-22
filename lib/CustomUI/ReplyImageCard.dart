import 'dart:io';
import 'dart:typed_data';

import 'package:chat_app/const.dart';
import 'package:flutter/material.dart';

class ReplyImageCard extends StatelessWidget {
  const ReplyImageCard({super.key, required this.path, required this.message, required this.time, required this.url
});
  final String path;
  final String message;
  final String time;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height/2.3,
          width: MediaQuery.of(context).size.width/1.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blue[100],
          ),
          child: Card(
            margin: EdgeInsets.all(2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(url,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  height: 54.5,
                  padding: EdgeInsets.only(
                      left: 15,
                      top: 8
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          message,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600]
                            ),
                          ),
                          SizedBox(width: 5,),
                          Icon(
                            Icons.done_all,
                            size: 20,
                          ),
                          SizedBox(width: 10,)
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
