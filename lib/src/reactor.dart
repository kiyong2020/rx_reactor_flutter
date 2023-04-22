import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dispose_bag.dart';

mixin Reactor<State> {
  final action = PublishSubject<ReactAction>();
  final _mutation = PublishSubject<ReactMutation>();

  var disposeBag = DisposeBag();

  State get state;

  @mustCallSuper
  void initReact() {
    action
        .flatMap((act) => mutate(act))
        .listen((mutation) => _mutation.add(mutation))
        .disposedBy(disposeBag);

    transform(_mutation)
        .listen((mutation) => reduce(mutation, state))
        .disposedBy(disposeBag);
  }

  /// 화면이 끝나고 리소스를 정리할때 호출
  @mustCallSuper
  void onDispose() {
    disposeBag.dispose();
    disposeBag = DisposeBag();
  }

  Stream<ReactMutation> mutate(ReactAction action);

  Stream<ReactMutation> transform(Stream<ReactMutation> mutation) => mutation;

  void reduce(ReactMutation mutation, State state);
}

class ReactAction {
  dynamic id;
  dynamic data;

  ReactAction({required this.id, this.data});
}

class ReactMutation {
  dynamic id;
  dynamic data;

  ReactMutation({required this.id, this.data});
}
