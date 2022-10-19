import 'package:chat_app/screen/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

// firebase
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

// import 'chatpage.dart';
// import 'home.dart';
import 'nav.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
// 変数
  String email = '';
  String password = '';
  String imageUrl = '';
  String userName = '';
  bool hidePassword = true;
  // メッセージ表示用
  String infoText = '';

  // GoogleSignIn
  Future<void> signInWithGoogle() async {
    // GoogleSignIn をして得られた情報を Firebase と関連づけることをやっています。
    final googleUser =
        await GoogleSignIn(scopes: ['profile', 'email']).signIn();

    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Center(
          child: Column(
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Lottie.network(
                  'https://assets8.lottiefiles.com/packages/lf20_cSNnXm5euH.json',
                  errorBuilder: (context, error, stackTrace) {
                return Padding(
                  padding: EdgeInsets.all(30.0),
                  child: CircularProgressIndicator(),
                );
              }),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail),
                  hintText: 'muna',
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
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail),
                  hintText: 'http://',
                  labelText: 'Image URL',
                ),
                // TextFormFieldがもつプロパティ
                // → valueをemail変数に代入してsetState
                onChanged: (String value) {
                  setState(() {
                    imageUrl = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.mail),
                  hintText: 'hogehoge@qmail.com',
                  labelText: 'Email Address',
                ),
                // TextFormFieldがもつプロパティ
                // → valueをemail変数に代入してsetState
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextFormField(
                obscureText: hidePassword,
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  // パスワード隠す機能
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              // SignUpボタン
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    // ページ遷移
                    onPressed: () async {
                      try {
                        // メール/パスワードでユーザー登録
                        // displaynameとphotoURLを保存したい → accountpageで独立したdbじゃなくてuserのとこに直接指定する
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final UserCredential result =
                            await auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        // ユーザー登録成功後のメッセ
                        final User user = result.user!;
                        setState(() {
                          infoText = "登録完了 : ${user.email}";
                        });
                        // ユーザー登録に成功した場合
                        // チャット画面に遷移＋ログイン画面を破棄
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return NavScreen();
                          }),
                        );
                      } catch (e) {
                        // ユーザー登録に失敗した場合
                        setState(() {
                          infoText = "登録に失敗しました：${e.toString()}";
                        });
                      }
                    },
                    child: const Text('SignUp'),
                  ),
                  // ログインボタンの作成
                  OutlinedButton(
                    onPressed: () async {
                      try {
                        // メールアドレスでr銀
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        await auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        // ログインに成功
                        // チャット画面に遷移+ログイン画面を履き
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return NavScreen();
                          }),
                        );
                      } catch (e) {
                        // ログインに失敗した場合
                        setState(() {
                          infoText = "ログインに失敗しました : ${e.toString()}";
                        });
                      }
                    },
                    child: Text('Login'),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await signInWithGoogle();
                        // ログインが成功すると FirebaseAuth.instance.currentUserにログイン中のユーザーの情報が入る
                        print(FirebaseAuth.instance.currentUser?.displayName);
                        // ログインに成功したら ChatPage に遷移します。
                        // 前のページに戻らせないようにするにはpushAndRemoveUntilを使います。
                        if (mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                              return const NavScreen();
                            }),
                            (route) => false,
                          );
                        }
                      },
                      child: Text('GoogleSignIn')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
