import 'package:chat_app/screen/accountScreen.dart';
import 'package:chat_app/screen/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  // final User? userEmail;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String titleName = 'HOME';
  late User user;

  // 状態を管理する変数
  String? userEmail;
  @override
  void initState() {
    userEmail = FirebaseAuth.instance.currentUser?.email!;
    user = FirebaseAuth.instance.currentUser!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$titleName'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(),
              otherAccountsPictures: [],
              accountEmail: Text('Email : $userEmail'),
              accountName: Text('User Name : '),
              decoration: BoxDecoration(
                color: Colors.blue[300],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text('Account'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AccountScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('LogOut'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('ホーム画面'),
      ),
    );
  }
}
