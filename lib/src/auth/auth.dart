import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// authの仕組みを理解するサンプル

Future<UserCredential?> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  if (googleUser == null) {
    return null;
  }

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

final authStateChangesProvider = StreamProvider((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp(home: AuthWidget());
  }
}

class AuthWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(authStateChangesProvider).when(
        data: (user) {
          if (user == null) return SignInScreen();
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Text('SIGN OUT'),
            ),
            body: WellcomeScreen(),
          );
        },
        error: (e, s, d) => Center(child: Text('$e')),
        loading: (d) => CircularProgressIndicator());
  }
}

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text('SIGN IN'),
        onPressed: () async {
          // googleアカウントを選択するポップアップが起動して選択するとログインできる
          await signInWithGoogle();
        },
      ),
    );
  }
}

class WellcomeScreen extends StatelessWidget {
  const WellcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Wellcome'),
          ElevatedButton(
              onPressed: () async {
                // この方法だと遷移先でsign outしてもsignInページには移動しない
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnotherScreen()),
                );
              },
              child: Text('to another screen'))
        ],
      ),
    );
  }
}

class AnotherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Text('AnotherScreen')),
        ElevatedButton(
            onPressed: () async {
              // signOutが実行されてもこのページは表示されたまま
              await FirebaseAuth.instance.signOut();

              // 例えば苦し紛れにこの辺でNavigator.pushなどすると、
              // SignInScreenからandroidのbackボタンで
              // このAnotherScreenに戻ってこれる。
              // その時、firestoreなどに接続するようになってると
              // 権限の問題でエラーが発生したりする。
            },
            child: Text('SIGN OUT'))
      ],
    );
  }
}
