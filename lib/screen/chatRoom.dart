// import 'dart:convert';
// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';

// String randomString() {
//   final random = Random.secure();
//   final values = List<int>.generate(16, (i) => random.nextInt(255));
//   return base64UrlEncode(values);
// }
class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  // final String titleName = 'CHAT ROOM';
  // final List<types.Message> _messages = [];
  // final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatRoom'),
      ),
      // body: Chat(
      //   user: _user,
      //   messages: _messages,
      //   onSendPressed: _handleSendPressed,
      // ),
      body: StreamBuilder<List<types.User>>(
        stream: FirebaseChatCore.instance.users(),
        initialData: const [],
        builder: (context, snapshot) {
          return Scaffold();
        },
      ),
    );
  }

//   void _addMessage(types.Message message) {
//     setState(() {
//       _messages.insert(0, message);
//     });
//   }

//   void _handleSendPressed(types.PartialText message) {
//     final textMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: randomString(),
//       text: message.text,
//     );

//     _addMessage(textMessage);
//   }
}
