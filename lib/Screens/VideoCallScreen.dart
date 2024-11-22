import 'package:chat_app/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class VideoCallScreen extends StatefulWidget {
  final String roomId;

  VideoCallScreen({required this.roomId});

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late IO.Socket socket;
  late RTCVideoRenderer _localRenderer;
  late RTCVideoRenderer _remoteRenderer;
  late RTCPeerConnection _peerConnection;

  @override
  void initState() {
    super.initState();

    _localRenderer = RTCVideoRenderer();
    _remoteRenderer = RTCVideoRenderer();
    _localRenderer.initialize().catchError((error) {
      print("Error initializing local renderer: $error");
    });
    _remoteRenderer.initialize().catchError((error) {
      print("Error initializing remote renderer: $error");
    });

    _connectToSocket();
  }

  Future<void> _connectToSocket() async {
    socket = IO.io(server, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.on('connect', (_) {
      socket.emit('join', widget.roomId);
    });

    socket.on('offer', (data) async {
      var sdp = data['sdp'];
      await _peerConnection.setRemoteDescription(RTCSessionDescription(sdp, 'offer'));
      var answer = await _peerConnection.createAnswer();
      await _peerConnection.setLocalDescription(answer);
      socket.emit('answer', {'sdp': answer.sdp, 'room': widget.roomId});
    });

    socket.on('answer', (data) async {
      var sdp = data['sdp'];
      await _peerConnection.setRemoteDescription(RTCSessionDescription(sdp, 'answer'));
    });

    socket.on('candidate', (data) async {
      var candidate = data['candidate'];
      await _peerConnection.addCandidate(RTCIceCandidate(candidate['candidate'], candidate['sdpMid'], candidate['sdpMLineIndex']));
    });

    await _createPeerConnection();
  }

  Future<void> _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},  // Sửa 'url' thành 'urls'
      ],
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      socket.emit('candidate', {
        'candidate': candidate.toMap(),
        'room': widget.roomId,
      });
    };

    //Kiểm tra người dùng kết nối thành công chưa
    _peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
      print("ICE Connection State: $state");
      if (state == RTCIceConnectionState.RTCIceConnectionStateConnected ||
          state == RTCIceConnectionState.RTCIceConnectionStateCompleted) {
        print("Peer-to-peer connection established successfully.");
      }
    };

    //state = stable: kết nối đã được thiết lập
    _peerConnection?.onSignalingState = (RTCSignalingState state) {
      print("Signaling State: $state");
      if (state == RTCSignalingState.RTCSignalingStateStable) {
        print("Signaling process completed and connection established.");
      }
    };

    //Kiểm tra 2 người đã kết nối thành công chưa
    _peerConnection.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        setState(() {
          _remoteRenderer.srcObject = event.streams[0];
        });
        print("Received remote video stream.");
      }
    };

    MediaStream localStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    }).catchError((e) {
      print("Error getting user media: $e");
    });

    localStream.getTracks().forEach((track) {
      _peerConnection.addTrack(track, localStream);
    });

    _localRenderer.srcObject = localStream;
    print("Local stream: ${localStream.id}");
  }

  void _endCall() async {
    await _peerConnection.close();

    _localRenderer.srcObject = null; // Ngắt kết nối renderer khỏi stream trước khi dispose
    _remoteRenderer.srcObject = null;

    _localRenderer.dispose();
    _remoteRenderer.dispose();

    socket.emit('leave', widget.roomId);
    socket.disconnect();

    Navigator.of(context).pop(); // Quay lại màn hình trước đó
  }

  @override
  void dispose() {
    _endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RTCVideoView(_remoteRenderer),
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1.0,
                )
              ),
              width: 150,
              height: 200,
              child: RTCVideoView(_localRenderer, mirror: true),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 20,
            left: 20,
            child: Center(
              child: FloatingActionButton(
                onPressed: _endCall,
                backgroundColor: Colors.red,
                child: Icon(Icons.call_end),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
