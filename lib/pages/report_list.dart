import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wildlife_nl_app/state/interactions.dart';

class ActivitiesPage extends ConsumerWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var interactions = ref.watch(interactionsProvider);
    var provider = ref.read(interactionsProvider.notifier);

    return const Placeholder();
  }
}
