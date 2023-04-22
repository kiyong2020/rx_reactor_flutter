import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

import 'context_reactor.dart';

class ReactBuilder<T extends ContextReactor> extends StatefulWidget {
  final T reactor;
  final Widget Function(BuildContext context, T reactor) builder;

  const ReactBuilder({required this.reactor, required this.builder, super.key});

  @override
  State<StatefulWidget> createState() => _ReactBuilderState<T>();
}

class _ReactBuilderState<T extends ContextReactor>
    extends State<ReactBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    widget.reactor.onBuildUI(context);

    return ChangeNotifierProvider<T>(
      create: (context) => widget.reactor,
      child: Builder(builder: (context) {
        return widget.builder(context, widget.reactor);
      }),
    );
  }

  @override
  void initState() {
    super.initState();

    // widget.reactor.onInit();
  }

  @override
  void dispose() {
    widget.reactor.onDispose();
    super.dispose();
  }
}
