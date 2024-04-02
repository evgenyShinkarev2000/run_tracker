import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Router.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordBarTab/RunRecordBarTab.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordMapTab.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordPointsTab.dart';
import 'package:run_tracker/services/RunRecordService.dart';

class RunRecordPage extends StatelessWidget {
  final int runCoverKey;
  const RunRecordPage(this.runCoverKey, {super.key});
  @override
  Widget build(BuildContext context) {
    final runRecordService = context.read<RunRecordService>();

    return FutureBuilder(
        future: runRecordService.getByCoverKey(runCoverKey),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("loading"),
            );
          }

          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                  toolbarHeight: 60,
                  title: Text(
                    snapshot.requireData!.runCoverData.title,
                  ),
                  leading: IconButton(
                    iconSize: 30,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => context.go(Routes.historyPage),
                  ),
                  bottom: TabBar(
                    dividerColor: context.themeDate.appBarTheme.backgroundColor,
                    tabs: [
                      Tab(icon: Icon(Icons.map)),
                      Tab(
                        icon: SvgPicture.asset(
                          "assets/images/bar-icon.svg",
                          width: 28,
                        ),
                      ),
                      Tab(
                        icon: Icon(Icons.place),
                      ),
                    ],
                  )),
              body: TabBarView(
                children: [
                  RunRecordMapTab(runRecordModel: snapshot.requireData!),
                  RunRecordBarTab(runRecordModel: snapshot.requireData!),
                  RunRecordPointsTab(runRecordModel: snapshot.requireData!),
                ],
              ),
            ),
          );
        });
  }
}

class RunRecordPageContainer extends StatefulWidget {
  final int runRecordId;
  const RunRecordPageContainer({super.key, required this.runRecordId});

  @override
  State<RunRecordPageContainer> createState() => _RunRecordPageContainerState();
}

class _RunRecordPageContainerState extends State<RunRecordPageContainer> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
