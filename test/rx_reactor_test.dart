import 'package:flutter/material.dart';

import 'package:rx_reactor/src/rx_reactor.dart';
import 'package:rxdart/rxdart.dart';

enum _Action {
  setTabItem,
}

enum _Mutation {
  setTabItem,
}

class MainState {
  final selectedTabIndex = BehaviorSubject.seeded(0);
}

class MainScreenReactor extends ContextReactor<MainState> {
  @override
  final state = MainState();

  MainScreenReactor() : super();

  setTabItem(int index) =>
      action.add(ReactAction(id: _Action.setTabItem, data: index));

  @override
  Stream<ReactMutation> mutate(ReactAction action) {
    switch (action.id as _Action) {
      case _Action.setTabItem:
        return Stream<ReactMutation>.value(
            ReactMutation(id: _Mutation.setTabItem, data: action.data));
    }
  }

  @override
  void reduce(ReactMutation mutation, MainState state) async {
    switch (mutation.id as _Mutation) {
      case _Mutation.setTabItem:
        state.selectedTabIndex.add(mutation.data);
        break;
    }
  }
}

class MainScreen extends StatelessWidget {
  final reactor = MainScreenReactor();

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactBuilder(
        reactor: reactor,
        builder: (context, reactor) => Center(
              child: Column(
                children: [
                  TextButton(
                      onPressed: () => reactor.setTabItem(0),
                      child: const Text('View1')),
                  TextButton(
                      onPressed: () => reactor.setTabItem(1),
                      child: const Text('View2')),
                  TextButton(
                      onPressed: () => reactor.setTabItem(2),
                      child: const Text('View3')),
                ],
              ),
            ));
  }
}

void main() {}
