import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth/auth_provider.dart';
import 'projects/projects_screen.dart';

class ScaffoldAndNavigator extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [SignInAndOutWithGoogleWidget()],
      ),
      body: Navigator(
        pages: const [
          MaterialPage(
            key: ValueKey('ProjectsScreen'),
            child: ProjectsScreen(),
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
