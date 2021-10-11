import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth/auth_provider.dart';

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
          Text(AppLocalizations.of(context)!.projectsTitle),
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
