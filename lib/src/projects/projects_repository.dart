import 'package:riverpod/riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/auth_provider.dart';
import 'models/project.dart';

// https://riverpod.dev/docs/concepts/combining_providers
class ProjectsRepository {
  ProjectsRepository(this.read);
  final Reader read;

  final db = FirebaseFirestore.instance;
  static const collectionPath = 'projects';

  CollectionReference<Project> withConverter() {
    return db.collection(collectionPath).withConverter<Project>(
          fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
          toFirestore: (e, _) => e.toJson(),
        );
  }

  void add(Project entity) {
    // uidが欲しい
    withConverter().add(entity);
  }

  Stream<QuerySnapshot<Project>> findAll() {
    return withConverter().snapshots();
  }
}
