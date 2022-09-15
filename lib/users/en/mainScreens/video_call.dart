import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class VideoCall extends StatefulWidget {
  @override
  State<VideoCall> createState() => _VideoCallState();
}

const appId = "8139cfafa48c4b78af8426975903c5b6";
const token = "007eJxTYMh+5b2zb93u4FgXnhhXid47ez/MnXTj97f5wrb295ZHqrYoMFgYGlsmpyWmJZpYJJskmVskplmYGJlZmptaGhgnmyaZJQYrJz9aopIsxXaUmZEBAkF8Hoa0zKLikuSMxLy81BwGBgDbPiUA";

class _VideoCallState extends State<VideoCall> {
  int? _remoteUid;
  late RtcEngine _engine;
  
  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = await RtcEngine.create(appId);
    await _engine.enableVideo();
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.joinChannel(token, "firstchannel", null, 0);
  }
    
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Video Call'),
        ),
        body: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 100,
                height: 100,
                child: Center(
                  child: RtcLocalView.SurfaceView(),
                ),
              ),
            ),
          ],
        ),
      );
    }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(uid: _remoteUid!);
    } else {
      return Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
