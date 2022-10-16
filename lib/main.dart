import 'package:flutter/material.dart';

// firebase
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screen/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // firebase初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Chat());
}

class Chat extends StatelessWidget {
  const Chat({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}


/// TODO
/// 1. ログインとサインアップUIを作る → firebaseとつなげる
/// 2. ログイン後の画面遷移 → homePageを作成 teamsとtwitterのイメージ
/// 3. チャットタブの画面遷移 → chatpageを作成 → flutter_firebase_chat_coreを参考に
/// 4. chatroomの作成
/// ～～～好きっていう大きなテーマがある
/// or 1つのトークテーマ
