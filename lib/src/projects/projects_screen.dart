import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'project_provider.dart';

class ProjectsScreen extends HookConsumerWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final asyncValue = ref.watch(projectsProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppLocalizations.of(context)!.projectsTitle),
          ListView(
            shrinkWrap: true,
            children: [
              ...asyncValue.when(
                  data: (data) {
                    return data.docs
                        .map((e) => ListTile(
                              title: Text('${e.data().title}'),
                            ))
                        .toList();
                  },
                  error: (e, s, _) => [Text(e.toString())],
                  loading: (_) => [CircularProgressIndicator()])
            ],
          )
        ],
      ),
    );
  }
}
