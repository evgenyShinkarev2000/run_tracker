import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:run_tracker/components/AppMainLoader.dart';
import 'package:run_tracker/components/drawer/AppMainDrawer.dart';
import 'package:run_tracker/data/repositories/repositories.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/pages/StatisticPage/Gistograms.dart';

class StatisticPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final runCoverRepository = context.read<RunCoverRepository>();

    return Scaffold(
      appBar: AppBar(),
      drawer: AppMainDrawer(),
      body: FutureBuilder(
          future: Future.wait(runCoverRepository.getIterator()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AppMainLoader();
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(context.appLocalization.nounError),
              );
            }

            return Gistograms(runCovers: snapshot.requireData);
          }),
    );
  }
}
