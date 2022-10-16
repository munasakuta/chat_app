import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final String titleName = 'Notification';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('お知らせ画面'),
    );
  }
}
