import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'projects_repository.dart';

final projectsProvider = StreamProvider((ref) {
  return ProjectsRepository(ref.read).findAll();
});

final projectsRepositoryProvider = Provider((ref) {
  return ProjectsRepository(ref.read);
});
