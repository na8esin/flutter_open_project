import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// authの仕組みを理解するサンp

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
    return MaterialApp(
        home: Scaffold(
      body: AuthWidget(),
    ));
  }
}

class AuthWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(authStateChangesProvider).when(
        data: (user) {
          if (user == null) return SignInScreen();
          return WellcomeScreen();
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
                await FirebaseAuth.instance.signOut();
              },
              child: Text('SIGN OUT'))
        ],
      ),
    );
  }
}
