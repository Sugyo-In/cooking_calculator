import 'package:data/data.dart';
import 'package:flutter/material.dart';

import 'edit.dart';

typedef EditPrepPageArguments = ({Prep? prep});

class EditPrepPage extends StatelessWidget {
  static const routeName = '/editPrep';

  const EditPrepPage({super.key, this.prep});

  final Prep? prep;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('재료 추가')),
      body: PrepForm(
        prep: prep,
        onSubmitted: (prep) => _onPrepSubmitted(context, prep),
      ),
    );
  }

  void _onPrepSubmitted(BuildContext context, Prep<Amount> prep) {
    Navigator.maybeOf(context)?.maybePop(prep);
  }
}
