import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'project_provider.dart';
import 'models/project.dart';

final _formKey = GlobalKey<FormState>();

class NewProjectScreen extends HookConsumerWidget {
  static const routeName = '/projects/add';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(projectsRepositoryProvider);
    final titleController = useTextEditingController(text: "");
    final descriptionController = useTextEditingController(text: "");
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        label: Text(
                            AppLocalizations.of(context)!.projectTitleLabel)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      label: Text('description'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          repository.add(Project(
                              title: titleController.text,
                              description: descriptionController.text));

                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('submit'))
                ],
              )),
        )));
  }
}
