import 'package:flutter/material.dart';

import 'stories_bloc.dart';

class StoriesProvider extends InheritedWidget {
  late final StoriesBloc bloc;

  StoriesProvider({Key? key, required Widget child})
    : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static StoriesBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<StoriesProvider>()
      as StoriesProvider).bloc;
  }
}