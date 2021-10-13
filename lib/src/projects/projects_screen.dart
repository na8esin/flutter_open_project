import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'project_provider.dart';
import '../auth/google_auth_widget.dart';

class ProjectsScreen extends HookConsumerWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final asyncValue = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.projectsTitle),
        actions: [GoogleAuthWidget()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  ...asyncValue.when(
                      data: (data) {
                        return data.docs
                            .map((e) => Card(
                                    child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${e.data().title}',
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${e.data().description}',
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                )))
                            .toList();
                      },
                      error: (e, s, _) => [Text(e.toString())],
                      loading: (_) => [CircularProgressIndicator()])
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
