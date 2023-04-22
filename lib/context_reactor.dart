import 'dart:async';

import 'package:flutter/material.dart';

import 'reactor.dart';

abstract class ContextReactor<State> extends ChangeNotifier
    with Reactor<State> {
  late BuildContext context;

  Future<BuildContext> get safeContext async {
    await Future.delayed(Duration.zero);
    return context;
  }

  var _isContextReady = false;

  /// Method which runs when widget builds UI
  @mustCallSuper
  void onBuildUI(BuildContext context) {
    this.context = context;

    if (!_isContextReady) {
      _isContextReady = true;
      initReact();
      onContextReady(context);
    }
  }

  /// Method which runs when context is ready for the first time.
  void onContextReady(BuildContext context) {}

  @override
  void onDispose() {
    super.onDispose();
    _isContextReady = false;
  }
}
