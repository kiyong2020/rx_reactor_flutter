<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

## Features

Simple MVVM reactive programming tool using ReactiveX for flutter.
It helps to completely separate business logic from view.
The fundamental idea comes from ReactorKit [https://github.com/ReactorKit/ReactorKit].

## Getting started

Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  ...
  rx_reactor_flutter: ^0.3.0
```

## Usage

Reactor

```dart

/// declare actions
enum _Action {
  setTabItem,
}

/// declare mutations
enum _Mutation {
  setTabItem,
}

/// state
class MainScreenState {
  final selectedTabIndex = BehaviorSubject.seeded(0);
}

/// inherits from ContextReactor
class MainScreenReactor extends ContextReactor<MainState> {
  @override
  final state = MainState();

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
```

View

```dart
class MainScreen extends StatelessWidget {
  final reactor = MainScreenReactor(); 
  @override
  Widget build(BuildContext context) {
    return ReactBuilder(
        reactor: reactor,
        builder: (context, reactor) {
	...
        }
    );
  }
}
```
