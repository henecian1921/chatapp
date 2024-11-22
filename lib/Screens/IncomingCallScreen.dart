import 'package:chat_app/Screens/VideoCallScreen.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class IncomingCallScreen extends StatefulWidget {
  final IO.Socket socket;
  final String callerId;
  final String roomId;

  IncomingCallScreen({required this.socket, required this.callerId, required this.roomId});

  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  void _acceptCall() {
    widget.socket.emit('accept_call', {
      'callerId': widget.callerId,
      'roomId': widget.roomId,
    });

    // Điều hướng đến màn hình Video Call
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => VideoCallScreen(roomId: widget.roomId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Incoming Call')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bạn có cuộc gọi từ $widget.callerId'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _acceptCall,
              child: Text('Chấp nhận'),
            ),
          ],
        ),
      ),
    );
  }
}
