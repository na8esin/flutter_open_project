import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'profile_repository.dart';
import 'models/profile.dart';
import '../auth/auth_provider.dart';

// こんなふうにRepositoryのメソッドごとにProviderを分ける様子
// https://github.com/rrousselGit/river_pod/blob/master/examples/marvel/lib/src/screens/character_detail.dart#L49
// https://github.com/rrousselGit/river_pod/blob/master/examples/marvel/lib/src/screens/home.dart#L35

final profileRepositoryProvider = Provider((ref) {
  return ProfileRepository(ref.read);
});

// widgetでasyncValueを使いたいから
// こういうのはStreamProviderで欲しい
final profileProvider =
    StreamProvider.autoDispose<DocumentSnapshot<Profile>?>((ref) {
  // TODO: streamで取らないとダメ
  final authRepository = ref.watch(authRepositoryProvider);
  final user = authRepository.getUser();
  if (user == null) {
    return StreamController<DocumentSnapshot<Profile>?>().stream;
  }

  return ref.watch(profileRepositoryProvider).findByUid(user.uid);
});
