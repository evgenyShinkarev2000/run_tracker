import 'package:flutter/material.dart';

class FutureBuilderLoader<T> extends StatelessWidget {
  final Widget loader;
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;

  const FutureBuilderLoader(
      {super.key, required this.future, required this.builder, required this.loader});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          return builder(context, asyncSnapshot.requireData);
        }

        return loader;
      },
    );
  }
}
