import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth_provider.dart';

class GoogleAuthWidget extends HookConsumerWidget {
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
