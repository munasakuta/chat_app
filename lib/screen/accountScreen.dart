import 'package:chat_app/screen/chatRoom.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // 変数
  String userName = '';
  String id = '';
  String imageUrl = '';

  // 状態を管理する変数
  late String userUid;
  @override
  void initState() {
    userUid = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.account_box),
                hintText: 'User_Name',
                labelText: 'User Name',
              ),
              // TextFormFieldがもつプロパティ
              // → valueをemail変数に代入してsetState
              onChanged: (String value) {
                setState(() {
                  userName = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: const Icon(Icons.image),
                // パスワード隠す機能
                labelText: 'Image URL',
              ),
              onChanged: (String value) {
                setState(() {
                  imageUrl = value;
                });
              },
            ),
            ElevatedButton(
              // ページ遷移
              onPressed: () async {
                await FirebaseChatCore.instance.createUserInFirestore(
                    types.User(
                        firstName: userName, id: userUid, imageUrl: imageUrl));
              },
              child: const Text('登録'),
            ),
          ],
        ),
      )),
    );
  }
}

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  // Create a user with an ID of UID if you don't use `FirebaseChatCore.instance.users()` stream
  void _handlePressed(types.User otherUser, BuildContext context) async {
    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    // Navigate to the Chat screen
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChatRoom()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<types.User>>(
        stream: FirebaseChatCore.instance.users(),
        initialData: const [],
        builder: (context, snapshot) {
          return Scaffold();
        },
      ),
    );
  }
}

class RoomsPage extends StatelessWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<types.Room>>(
        stream: FirebaseChatCore.instance.rooms(),
        initialData: const [],
        builder: (context, snapshot) {
          return Scaffold();
        },
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widget;
    return Scaffold(
      body: StreamBuilder<List<types.Message>>(
        initialData: const [],
        stream: FirebaseChatCore.instance.messages(widget.room),
        builder: (context, snapshot) {
          return Scaffold();
        },
      ),
    );
  }
}
