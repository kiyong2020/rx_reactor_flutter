import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

import 'context_reactor.dart';

class ReactBuilder<T extends ContextReactor> extends StatefulWidget {
  final T reactor;
  final Widget Function(BuildContext context, T reactor) builder;

  const ReactBuilder({required this.reactor, required this.builder, super.key});

  @override
  State<StatefulWidget> createState() => ReactBuilderState<T>();
}

class ReactBuilderState<T extends ContextReactor>
    extends State<ReactBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    widget.reactor.onBuildUI(context);

    return Provider<T>.value(
      value: widget.reactor,
      child: Builder(builder: (context) {
        return widget.builder(context, widget.reactor);
      }),
    );
  }

  @override
  void initState() {
    super.initState();

    widget.reactor.onInitState(this);
  }

  @override
  void dispose() {
    widget.reactor.onDispose();
    super.dispose();
  }
}

class TickerReactBuilder<T extends ContextReactor> extends ReactBuilder<T> {
  const TickerReactBuilder(
      {required super.reactor, required super.builder, super.key});

  @override
  State<StatefulWidget> createState() => TickerProviderReactBuilderState<T>();
}

class TickerProviderReactBuilderState<T extends ContextReactor>
    extends ReactBuilderState<T> with TickerProviderStateMixin {}
