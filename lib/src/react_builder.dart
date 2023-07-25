import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

import 'context_reactor.dart';

class ReactBuilder<T extends ContextReactor> extends StatefulWidget {
  final T? reactor;
  final T Function()? create;
  final Widget Function(BuildContext context, T reactor) builder;

  ReactBuilder({required this.builder, this.reactor, this.create, super.key}) {
    assert(this.reactor != null || this.create != null,
        'At least one of reactor or create must be set');
    assert(this.reactor == null || this.create == null,
        'Only one of reactor or create parameter must be used');
  }

  @override
  State<StatefulWidget> createState() => ReactBuilderState<T>();
}

class ReactBuilderState<T extends ContextReactor>
    extends State<ReactBuilder<T>> {
  late T reactor;
  @override
  Widget build(BuildContext context) {
    reactor.onBuildUI(context);

    return Provider<T>.value(
      value: reactor,
      child: Builder(builder: (context) {
        return widget.builder(context, reactor);
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    reactor = widget.reactor ?? widget.create!();
    reactor.onInitState(this);
  }

  @override
  void didUpdateWidget(ReactBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reactor != null) {
      reactor = widget.reactor!;
    }
  }

  @override
  void dispose() {
    reactor.onDispose();
    super.dispose();
  }
}

class TickerReactBuilder<T extends ContextReactor> extends ReactBuilder<T> {
  const TickerReactBuilder(
      {required super.builder, super.reactor, super.create, super.key});

  @override
  State<StatefulWidget> createState() => TickerProviderReactBuilderState<T>();
}

class TickerProviderReactBuilderState<T extends ContextReactor>
    extends ReactBuilderState<T> with TickerProviderStateMixin {}
