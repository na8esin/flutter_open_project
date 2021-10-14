import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'profile_provider.dart';

final _formKey = GlobalKey<FormState>();

// userという名前はauthのuserとぶつかりがち
class ProfileScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(profileProvider);
    final entity = asyncValue.when(
        data: (e) => e!.data(), loading: (_) => null, error: (e, s, _) => null);
    final nicknameController = useTextEditingController(text: entity?.nickname);
    final photoUrlController = useTextEditingController(text: entity?.photoUrl);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nicknameController,
            ),
            TextFormField(
              controller: photoUrlController,
            )
          ],
        ),
      ),
    );
  }
}
