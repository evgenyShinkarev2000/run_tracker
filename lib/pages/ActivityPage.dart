import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/bloc/cubits/CounterCubit.dart';
import 'package:run_tracker/components/drawer/AppMainDrawer.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    increment() => context.read<CounterCubit>().increment();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: AppMainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            BlocBuilder<CounterCubit, int>(
              builder: (bc, state) => Text(
                "$state",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
