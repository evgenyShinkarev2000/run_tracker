import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/Settings/export.dart';
import 'package:run_tracker/Routing/export.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var localeRepository = ref.watch(localeRepositoryProvider);
    return MyHomePageView(
      counter: _counter,
      increment: _incrementCounter,
      setRussian: () => localeRepository.Set(AppLocales.ru),
      setEnglish: () => localeRepository.Set(AppLocales.en),
    );
  }
}

class MyHomePageView extends StatelessWidget {
  final int counter;
  final VoidCallback increment;
  final VoidCallback setRussian;
  final VoidCallback setEnglish;

  const MyHomePageView({
    super.key,
    required this.counter,
    required this.increment,
    required this.setRussian,
    required this.setEnglish,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.themeData.colorScheme.inversePrimary,
        title: Text(context.appLocalization.menuMain),
      ),
      drawer: AppMainDrawer(),
      body: Consumer(
        builder: (context, ref, child) {
          return Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                const Text('You have pushed the button this many times:'),
                Text(context.appLocalization.nounCancel),
                Text(
                  "$counter",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TextButton(onPressed: setRussian, child: Text("русский")),
                TextButton(onPressed: setEnglish, child: Text("english")),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
