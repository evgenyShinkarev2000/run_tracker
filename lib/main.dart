import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/l10n/app_localizations.dart';
import 'package:run_tracker/localization/export.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locale = ref.watch(localeProvider).value;
    var localeRepository = ref.watch(localeRepositoryProvider);
    return MaterialApp(
      title: 'Run tracker',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: locale ?? AppLocales.fallback,
      supportedLocales: AppLocales.supported,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        setRussian: () => localeRepository.Set(AppLocales.ru),
        setEnglish: () => localeRepository.Set(AppLocales.en),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.setRussian,
    required this.setEnglish,
  });
  final String title;
  final VoidCallback setRussian;
  final VoidCallback setEnglish;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                const Text('You have pushed the button this many times:'),
                Text(context.appLocalization.nounCancel),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                TextButton(
                  onPressed: widget.setRussian,
                  child: Text("русский"),
                ),
                TextButton(
                  onPressed: widget.setEnglish,
                  child: Text("english"),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
