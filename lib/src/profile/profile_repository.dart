import 'package:riverpod/riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/profile.dart';

class ProfileRepository {
  ProfileRepository(this.read);
  final Reader read;
  final db = FirebaseFirestore.instance;
  static const collectionPath = 'profiles';

  CollectionReference<Profile> withConverter() {
    return db.collection(collectionPath).withConverter<Profile>(
          fromFirestore: (snapshot, _) => Profile.fromJson(snapshot.data()!),
          toFirestore: (e, _) => e.toJson(),
        );
  }

  void set(String uid, Profile entity) {
    withConverter().doc(uid).set(entity);
  }

  Stream<DocumentSnapshot<Profile>> findByUid(String uid) {
    return withConverter().doc(uid).snapshots();
  }
}
