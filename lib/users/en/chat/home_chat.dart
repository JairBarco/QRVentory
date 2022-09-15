import 'package:flutter/material.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({Key? key}) : super(key: key);

  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Center(
        child: Card(
          elevation: 11,
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Welcome to support chat'),
                TextField(
                  controller: null,
                  decoration: InputDecoration(
                    hintText: 'Username'
                  ),
                ),
                ElevatedButton(
                    onPressed: _onGoPressed,
                    child: Text('Go')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
