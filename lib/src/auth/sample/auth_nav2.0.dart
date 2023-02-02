import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authStateChangesProvider = StreamProvider((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

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
              child: const Text('SIGN OUT'),
            ),
            // ここにNavigatorを追加するだけで、AnotherScreenまで行った時に
            // fabでsign outすると、sign inページに遷移する
            body: Navigator(
              pages: const [
                MaterialPage(
                  key: ValueKey('WellcomeScreen'),
                  child: WellcomeScreen(),
                )
              ],
              onPopPage: (route, result) => route.didPop(result),
            ),
          );
        },
        // https://github.com/rrousselGit/riverpod/blob/master/examples/marvel/lib/src/screens/home.dart#L90
        error: (err, stack) => Center(child: Text('$err')),
        loading: () => const CircularProgressIndicator());
  }
}

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Image(
          image: AssetImage(
              'assets/images/btn_google_signin_light_normal_web.png'),
        ),
        onPressed: () async {
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
          Text('Wellcome!'),
          ElevatedButton(
              onPressed: () async {
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

// このパターンだとScaffoldの子供として現れるので、
//`SIGN OUT`ボタンはいらなくなる(fabを使えばいい)
class AnotherScreen extends StatelessWidget {
  const AnotherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [Center(child: Text('AnotherScreen'))],
    );
  }
}
