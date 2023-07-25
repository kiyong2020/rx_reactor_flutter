import 'dart:async';

import 'package:rxdart/utils.dart';

class DisposeBag extends CompositeSubscription {}

extension DisposableStreamSubscription on StreamSubscription {
  StreamSubscription disposedBy(DisposeBag bag) {
    bag.add(this);
    return this;
  }
}
