import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OwnImageCard extends StatelessWidget {
  const OwnImageCard({super.key, required this.path, required this.message, required this.time});
  final String path;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
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
            color: Colors.blueAccent[100],
          ),
          child: Card(
            margin: EdgeInsets.all(3),
            color: Color(0xffdcf8c6),
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.file(
                      File(path),
                      fit: BoxFit.fitHeight,
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
                        ),
                      ],
                    ),
                  ),
                ],
            ),
          ),
        ),
      ),
    );
  }
}
