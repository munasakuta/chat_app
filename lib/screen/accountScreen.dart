// import 'package:chat_app/screen/chatRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../post.dart' as post;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../main.dart';

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
            // Expanded(
            //   child: StreamBuilder<QuerySnapshot<post.UserInfo>>(
            //     // streamプロパティにsnapshots()を与えると、コレクションの中のドキュメントをリアルタイムで監視することができる
            //     stream: userInfosReference.orderBy('createdAt').snapshots(),
            //     // ここで受け取っているsnapshotにstreamで流れてきたデータが入ってくる
            //     builder: (context, snapshot) {
            //       // docsにはCollectionに保存されたすべてのドキュメントが入る
            //       // 取得までには時間がかかるのではじめはnullが入っています
            //       // nullの場合はから破裂が代入されるようにしている
            //       final docs = snapshot.data?.docs ?? [];
            //       return ListView.builder(
            //         itemCount: docs.length,
            //         itemBuilder: (context, index) {
            //           // data()にPostインスタンスが入っている
            //           // これはwithConverterを使ったことにより得られる恩恵
            //           // 何もしなければこのデータ型はmapになる
            //           final userInfo = docs[index].data();
            //           return Text(userInfo.name);
            //         },
            //       );
            //     },
            //   ),
            // ),
            ElevatedButton(
              // ページ遷移
              onPressed: () {
                //   await FirebaseChatCore.instance.createUserInFirestore(
                //       types.User(
                //           firstName: userName, id: userUid, imageUrl: imageUrl));
                final user = FirebaseAuth.instance.currentUser!;
                final userId = user.uid;
                final name = userName;
                final iconImage = imageUrl;
                final newDocumentReference = userInfosReference.doc();

                // package:firebase_auth_platform_interface/src/user_info.dart
                final newUserInfo = post.UserInfo(
                  name: name,
                  iconImage: iconImage,
                  userId: userId,
                  reference: newDocumentReference,
                );
                newDocumentReference.set(newUserInfo);
              },
              child: const Text('登録'),
            ),
          ],
        ),
      )),
    );
  }
}
