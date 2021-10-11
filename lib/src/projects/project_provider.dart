import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'models/project.dart';

final projectsProvider = StreamProvider((ref) {
  return FirebaseFirestore.instance
      .collection('projects')
      .withConverter<Project>(
        fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
        toFirestore: (e, _) => e.toJson(),
      )
      .snapshots();
});
