import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:option_result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wildlife_nl_app/models/example_by_id.dart';
import 'package:wildlife_nl_app/state/example_by_id.dart';

part "example.g.dart";

@riverpod
class ExampleCounter extends _$ExampleCounter {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void reset() {
    state = 0;
  }
}

class ExamplePage extends ConsumerWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var counter = ref.watch(exampleCounterProvider);
    var counterProvider = ref.read(exampleCounterProvider.notifier);

    var future = ref.watch(getExampleByIdProvider(counter));

    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        //
        // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
        // action in the IDE, or press "p" in the console), to see the
        // wireframe for each widget.
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            '$counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          IconButton(
            onPressed: () {
              counterProvider.increment();
            },
            icon: const Icon(
              Icons.add,
              size: 48,
            ),
          ),
          IconButton(
            onPressed: () async {
              ref.invalidate(getExampleByIdProvider(counter));
            },
            icon: const Icon(
              Icons.refresh,
              size: 48,
            ),
          ),
          switch (future) {
            AsyncData(:final value) => switch (value) {
                Ok<GetExampleByIdResponse, String>(:final value) => Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.bodySmall),
                Err<GetExampleByIdResponse, String>(:final error) =>
                  Text(error, style: Theme.of(context).textTheme.bodySmall),
              },
            AsyncError() => Text(
                "An unhandled exception was thrown",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            _ => Text(
                "Data is still loading.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
          },
          IconButton(
            onPressed: () async {
              counterProvider.reset();
            },
            icon: const Icon(
              Icons.close,
              size: 48,
            ),
          )
        ],
      ),
    );
  }
}
