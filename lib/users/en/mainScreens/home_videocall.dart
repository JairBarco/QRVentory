import 'package:flutter/material.dart';
import 'package:users_app/users/en/mainScreens/video_call.dart';

void main() {
  runApp(const VideoCallApp());
}

class VideoCallApp extends StatelessWidget {
  const VideoCallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoCall(),
      debugShowCheckedModeBanner: false,
    );
  }
}