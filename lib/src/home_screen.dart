import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'projects/projects_screen.dart';

class PagesNavigator extends HookConsumerWidget {
  const PagesNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Navigator(
      pages: const [
        MaterialPage(
          key: ValueKey('ProjectsScreen'),
          child: ProjectsScreen(),
        )
      ],
      onPopPage: (route, result) => route.didPop(result),
    );
  }
}
