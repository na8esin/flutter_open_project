import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'projects/projects_screen.dart';
import 'projects/new_project_screen.dart';
import 'profile/profile_screen.dart';

final pagesNavigatorKey = GlobalKey<NavigatorState>();

class PagesNavigator extends HookConsumerWidget {
  const PagesNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case NewProjectScreen.routeName:
                return NewProjectScreen();
              case ProfileScreen.routeName:
                return ProfileScreen();
              default:
                return const ProjectsScreen();
            }
          },
        );
      },
      key: pagesNavigatorKey,
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
