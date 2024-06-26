import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:run_tracker/Router.dart';
import 'package:run_tracker/components/AppMainLoader.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordBarTab/RunRecordBarTab.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordChartTab/RunRecordChartTab.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordMapTab.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordPointsTab.dart';
import 'package:run_tracker/services/RunRecordService.dart';
import 'package:run_tracker/services/models/models.dart';
import 'package:share_plus/share_plus.dart';

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
            return AppMainLoader();
          }

          return DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                  toolbarHeight: 60,
                  title: Text(
                    snapshot.requireData!.runCoverData.title,
                  ),
                  leading: IconButton(
                    iconSize: 30,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  actions: [
                    PopupMenuButton(
                      onSelected: (v) {},
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.trash),
                              SizedBox(width: 16),
                              Text(context.appLocalization.verbRemove),
                            ],
                          ),
                          onTap: () => removeRecord(context, snapshot.requireData!),
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.shift),
                              SizedBox(width: 16),
                              Text(context.appLocalization.verbExport),
                            ],
                          ),
                          onTap: () => export(context, snapshot.requireData!),
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.share),
                              SizedBox(width: 16),
                              Text(context.appLocalization.runRecordPageShare),
                            ],
                          ),
                          onTap: () => share(context, snapshot.requireData!),
                        ),
                      ],
                    ),
                  ],
                  bottom: TabBar(
                    dividerColor: context.themeData.appBarTheme.backgroundColor,
                    tabs: const [
                      Tab(icon: Icon(CupertinoIcons.map)),
                      Tab(
                        icon: Icon(CupertinoIcons.chart_bar),
                      ),
                      Tab(
                        icon: Icon(CupertinoIcons.placemark),
                      ),
                      Tab(
                        icon: Icon(CupertinoIcons.graph_square),
                      ),
                    ],
                  )),
              body: TabBarView(
                children: [
                  RunRecordMapTab(runRecordModel: snapshot.requireData!),
                  RunRecordBarTab(runRecordModel: snapshot.requireData!),
                  RunRecordPointsTab(runRecordModel: snapshot.requireData!),
                  RunRecordChartTab(runRecordModel: snapshot.requireData!),
                ],
              ),
            ),
          );
        });
  }

  void removeRecord(BuildContext context, RunRecordModel runRecordModel) {
    context.read<RunRecordService>().removeByModel(runRecordModel).then((value) => context.go(Routes.historyPage));
  }

  void export(BuildContext context, RunRecordModel runRecordModel) {
    context
        .read<RunRecordService>()
        .export(runRecordModel)
        .then((pathToFile) => Fluttertoast.showToast(msg: pathToFile));
  }

  void share(BuildContext context, RunRecordModel runRecordModel) {
    final webApi = context.webApi;
    webApi.shareRunCover(runRecordModel.runCoverData).then(
      (runCoverExternalId) {
        Share.shareUri(webApi.buildShareUri(runCoverExternalId));
      },
    ).catchError((e) {
      Fluttertoast.showToast(msg: context.appLocalization.runRecordPageShareError);

      return null;
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
