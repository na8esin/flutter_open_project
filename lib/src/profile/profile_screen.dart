import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_open_project/src/profile/models/profile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'profile_provider.dart';
import '../auth/auth_provider.dart';

final _formKey = GlobalKey<FormState>();

// userという名前はauthのuserとぶつかりがち
class ProfileScreen extends HookConsumerWidget {
  static const routeName = '/profile';

  ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(profileProvider);
    return asyncValue.when(
        data: (e) {
          final profile = e!.data();
          final nicknameController =
              useTextEditingController(text: profile?.nickname);
          final photoUrlController =
              useTextEditingController(text: profile?.photoUrl);

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(photoUrlController.text),
                      ),
                      TextFormField(
                        controller: nicknameController,
                        decoration: const InputDecoration(
                          label: Text('nickname'),
                        ),
                      ),
                      TextFormField(
                        controller: photoUrlController,
                        decoration: const InputDecoration(
                          label: Text('photoUrl'),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            final user =
                                ref.read(authRepositoryProvider).getUser();
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'You are not logged in. Please login.')),
                              );
                              return;
                            }
                            photoUrlController.text = user.photoURL ?? "";
                          },
                          child: Text('Apply Goole Account photoUrl')),
                      ElevatedButton(
                          onPressed: () {
                            final user =
                                ref.read(authRepositoryProvider).getUser();
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'You are not logged in. Please login.')),
                              );
                              return;
                            }
                            ref.read(profileRepositoryProvider).set(
                                user.uid,
                                Profile(
                                    nickname: nicknameController.text,
                                    photoUrl: photoUrlController.text));
                          },
                          child: Text('update'))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: (_) => CircularProgressIndicator(),
        error: (e, s, _) => Center(
              child: Text(e.toString()),
            ));
  }
}
