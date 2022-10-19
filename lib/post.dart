import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

class Post {
  // コンストラクタ
  Post({
    required this.text,
    required this.createdAt,
    required this.posterName,
    required this.posterImageUrl,
    required this.posterId,
    required this.reference,
  });

  // Firestoreから得られる型 → DocumentSnapshot
  // → これを受け取るためのfromFirestoreファクトリを作る
  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;

    ///data()の中にはMap型のデータが入っている
    ///data()! → nullabaleな型をnon-nullableとして扱うって意味
    ///dataの中身は必ず入っているだろうという仮説のもと！をつけている
    ///mapデータが得られている
    return Post(
      text: map['text'],
      createdAt: map['createdAt'],
      posterName: map['posterName'],
      posterImageUrl: map['posterImageUrl'],
      posterId: map['posterId'],
      reference:
          snapshot.reference, // 注意。reference は map ではなく snapshot に入っています。
    );
  }
  // PostインスタンスからMap<String, dynamic>に変換するためのtoMap()関数を作成
  // → FireStoreにデータを保存するときに活躍する
  // プロパティ名とkey名を一致させれば機械的に作れる
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'createdAt': createdAt,
      'posterName': posterName,
      'posterImageUrl': posterImageUrl,
      'posterId': posterId,
      // 'reference': reference, reference はfieldに含めなくて良い
      // fieldに含めなくても DocumentSnapshotにreferenceが存在するため
    };
  }

  // 投稿分
  final String text;
  // 投稿日時
  final Timestamp createdAt;
  // 投稿者の名前
  final String posterName;
  // 投稿者のアイコン画像URL
  final String posterImageUrl;
  // 投稿者のユーザーID
  final String posterId;
  // Firestoreのどこにデータが存在するかを表すpath情報
  final DocumentReference reference;
}

class UserInfo {
  // コンストラクタ
  UserInfo({
    required this.name,
    required this.iconImage,
    required this.userId,
    required this.reference,
  });

  factory UserInfo.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;

    ///data()の中にはMap型のデータが入っている
    ///data()! → nullabaleな型をnon-nullableとして扱うって意味
    ///dataの中身は必ず入っているだろうという仮説のもと！をつけている
    ///mapデータが得られている
    return UserInfo(
      name: map['name'],
      iconImage: map['iconImage'],
      userId: map['userId'],
      reference:
          snapshot.reference, // 注意。reference は map ではなく snapshot に入っています。
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconImage': iconImage,
      'userId': userId,
      // 'reference': reference, reference はfieldに含めなくて良い
      // fieldに含めなくても DocumentSnapshotにreferenceが存在するため
    };
  }

  final String name;
  final String iconImage;
  final String userId;
  final DocumentReference reference;
}
