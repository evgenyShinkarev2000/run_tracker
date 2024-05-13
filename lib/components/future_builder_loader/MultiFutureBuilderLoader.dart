import 'package:flutter/material.dart';

class MultiFutureBuilderLoader extends StatefulWidget {
  final Function(BuildContext context, List<FutureInfo> futureInfos) loader;
  final Function(BuildContext context, MultiFutureBuilderLoaderHelperGet store) builder;
  final Function(MultiFutureBuilderLoaderHelperRegister storage) register;

  const MultiFutureBuilderLoader({
    super.key,
    required this.loader,
    required this.builder,
    required this.register,
  });

  @override
  State<StatefulWidget> createState() => _MultiFutureBuilderLoaderState();
}

class _MultiFutureBuilderLoaderState extends State<MultiFutureBuilderLoader> {
  late final MultiFutureBuilderLoaderHelper helper;
  bool isCompleated = false;
  List<FutureInfo> futureInfos = [];

  @override
  void initState() {
    helper = MultiFutureBuilderLoaderHelper(
      onCompleted: () {
        setState(() {
          isCompleated = true;
        });
      },
      onChange: (futureInfos) {
        setState(() {
          this.futureInfos = futureInfos.toList();
        });
      },
    );

    widget.register(helper);
    if (helper.activeFutureCount == 0) {
      setState(() {
        isCompleated = true;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isCompleated) {
      return widget.builder(context, helper);
    }

    return widget.loader(context, futureInfos);
  }
}

abstract class MultiFutureBuilderLoaderHelperGet {
  T get<T>();
}

abstract class MultiFutureBuilderLoaderHelperRegister {
  void register<T>(Future<T> future, [String? name]);
}

class MultiFutureBuilderLoaderHelper
    implements MultiFutureBuilderLoaderHelperGet, MultiFutureBuilderLoaderHelperRegister {
  final Map<Type, dynamic> _typeToInstance = {};
  final List<FutureInfo> _futureInfos = [];
  final Function() onCompleted;
  final Function(Iterable<FutureInfo> indexToInfo) onChange;
  int index = 0;
  int activeFutureCount = 0;

  MultiFutureBuilderLoaderHelper({required this.onCompleted, required this.onChange});

  @override
  void register<T>(Future<T> future, [String? name]) {
    ++activeFutureCount;
    _futureInfos.add(FutureInfo(isCompleated: false, name: name));
    final localIndex = index;
    ++index;
    onChange(_futureInfos);

    future.then((value) {
      final type = value.runtimeType;
      if (null.runtimeType != type && _typeToInstance.containsKey(type)) {
        throw Exception("shouldn't contains equal types");
      }

      --activeFutureCount;
      _typeToInstance[type] = value;
      _futureInfos[localIndex].isCompleated = true;
      onChange(_futureInfos);

      if (activeFutureCount == 0) {
        onCompleted();
      }
    });
  }

  @override
  T get<T>() {
    assert(T != dynamic);
    if (activeFutureCount != 0) {
      throw Exception("shouldn't call get before all futures aren't compleated");
    }

    if (!_typeToInstance.containsKey(T)) {
      throw Exception("no such type registered");
    }

    return _typeToInstance[T];
  }
}

class FutureInfo {
  bool isCompleated;
  String? name;

  FutureInfo({
    required this.isCompleated,
    this.name,
  });
}
