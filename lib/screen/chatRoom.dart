import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'accountScreen.dart';

import '../post.dart' as post;

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<post.Post>>(
              // streamプロパティにsnapshots()を与えると、コレクションの中のドキュメントをリアルタイムで監視することができる
              stream: postsReference.orderBy('createdAt').snapshots(),
              // ここで受け取っているsnapshotにstreamで流れてきたデータが入ってくる
              builder: (context, snapshot) {
                // docsにはCollectionに保存されたすべてのドキュメントが入る
                // 取得までには時間がかかるのではじめはnullが入っています
                // nullの場合はから破裂が代入されるようにしている
                final docs = snapshot.data?.docs ?? [];
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    // data()にPostインスタンスが入っている
                    // これはwithConverterを使ったことにより得られる恩恵
                    // 何もしなければこのデータ型はmapになる
                    final post = docs[index].data();
                    return Text(post.text);
                  },
                );
              },
            ),
          ),
          TextFormField(
            onFieldSubmitted: (text) {
              // userという変数にログイン中のユーザーデータを格納します
              final user = FirebaseAuth.instance.currentUser!;
              final posterId = user.uid; // ログイン中のユーザーIDが取れる
              // userNameとアイコンを設定してここに変わりのコード記述 → accountScreen.dartのとこ編集
              // firebaseからデータ取得
              final posterName = user.displayName!;
              final posterImageUrl = user.photoURL!;
              // 先程作ったpostsReferenceからランダムなIDのドキュメントリファレンスを作成
              // docの引数を空にするとランダムなIDが採番される
              final newDocumentReference = postsReference.doc();

              final newPost = post.Post(
                text: text,
                createdAt: Timestamp.now(),
                posterName: posterName,
                posterImageUrl: posterImageUrl,
                posterId: posterId,
                reference: newDocumentReference,
              );

              // 先程作ったnewDocumentReferenceのset関数を実行するとそのドキュメントにデータが保存されます。
              // 引数としてPostインスタンスを渡します。
              // 通常Mapしか受け付けませんが、withConverterを使用したことによりPostインスタンスを受け取れるようになります
              newDocumentReference.set(newPost);
            },
          ),
        ],
      ),
    );
  }
}
