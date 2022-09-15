import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'home_chat.dart';

class Chat extends StatefulWidget {

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  StreamChatClient? client;

  @override
  void initState(){
    client = StreamChatClient("p6sktczedaap", logLevel: Level.INFO);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      builder: (context, child) => StreamChat(
        child: child,
        client: client!,
        streamChatThemeData: StreamChatThemeData.fromTheme(ThemeData.dark()),
      ),
      home: HomeChat(),
    );
  }
}
