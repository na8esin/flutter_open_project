import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './auth_provider.dart';

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
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [SignInAndOutWithGoogleWidget()],
      ),
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
  }
}

class SignInAndOutWithGoogleWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    return ref.watch(authStateChangesProvider).when(
        data: (user) {
          return user == null
              ? TextButton(
                  child: const Image(
                    image: AssetImage(
                        'assets/images/btn_google_signin_light_normal_web.png'),
                  ),
                  onPressed: () async {
                    await signInWithGoogle();
                  })
              : TextButton(
                  child: const Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                );
        },
        error: (e, s, d) {
          print('$e');
          return Center();
        },
        loading: (d) => CircularProgressIndicator());
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
                  MaterialPageRoute(builder: (context) => Center()),
                );
              },
              child: Text('to another screen'))
        ],
      ),
    );
  }
}
