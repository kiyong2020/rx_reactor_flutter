import 'package:flutter/widgets.dart';

import 'reactor.dart';

mixin ServiceProvider {
  // late ServiceContext serviceContext;
  late BuildContext context;
}

class ServiceReactorProvider extends StatefulWidget {
  final List<ServiceProvider> providers;
  final Widget child;

  const ServiceReactorProvider(
      {super.key, required this.providers, required this.child});

  @override
  State createState() => ServiceReactorProviderState();
}

class ServiceReactorProviderState extends State<ServiceReactorProvider> {
  var bindComplete = false;

  @override
  Widget build(BuildContext context) {
    for (final provider in widget.providers) {
      provider.context = context;
    }

    if (!bindComplete) {
      bindComplete = true;
      widget.providers.whereType<Reactor>().forEach((e) => e.onBindReactor());
    }
    return widget.child;
  }
}
