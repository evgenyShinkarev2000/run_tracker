import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:latlong2/latlong.dart';
import 'package:run_tracker/Components/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Providers/Track/export.dart';
import 'package:run_tracker/Routing/export.dart';
import 'package:run_tracker/Services/Track/export.dart';
import 'package:run_tracker/localization/export.dart';

class TrackHistoryList extends ConsumerStatefulWidget {
  const TrackHistoryList({super.key});

  @override
  ConsumerState<TrackHistoryList> createState() => _TrackHistoryListState();
}

// TODO для упрощения отрисовки можно уменьшить число точек алгоритмом Ramer-Douglas-Peucker
// или готовой билиотекой и сохранять их бд, если запуск алгоритма тяжелый.
// В flutter_map это уже есть, пока совершенно не критично.
// TODO ListTile зачем-то рендерится несколько раз 
class _TrackHistoryListState extends ConsumerState<TrackHistoryList> {
  static const int pageSize = 20;

  late final _controller =
      PagingController<int, TrackRecordWithSummaryAndPoints>(
        getNextPageKey: (state) =>
            state.lastPageIsEmpty ? null : state.nextIntPageKey,
        fetchPage: _fetchSummary,
      );

  final CancellationToken ct = CancellationToken();

  @override
  void dispose() {
    ct.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagingListener(
      controller: _controller,
      builder: (context, state, fetchNext) {
        return PagedListView<int, TrackRecordWithSummaryAndPoints>(
          state: state,
          fetchNextPage: fetchNext,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, item, index) {
              return ListTile(
                leading: SizedBox(
                  width: 100,
                  height: 100,
                  child: SmallPeviewMap(polylines: _pointsToPolylines(item)),
                ),
              );
            },
            noItemsFoundIndicatorBuilder: (context) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(context.appLocalization.historyPageNoRecords),
                    TextButton(
                      onPressed: context.appRouter.goMap,
                      child: Text(
                        context.appLocalization.historyPageCreateRecord,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<List<TrackRecordWithSummaryAndPoints>> _fetchSummary(
    int pageKey,
  ) async {
    var service = ref.read(trackServiceProvider);

    return await service.getTrackRecordWithSummaryAndPointsOrGenerate(
      TrackRecordQueryModel(
        pagination: PaginationModel.indexedFromOnePage(pageSize, pageKey),
        trackCreatedAtSort: SortDirection.Descending,
      ),
      ct,
    );
  }

  List<List<LatLng>> _pointsToPolylines(TrackRecordWithSummaryAndPoints model) {
    return model
        .splitPath()
        .map(
          (points) => points
              .where((p) => p.hasLatLng)
              .map((p) => p.toLatLng())
              .toList(),
        )
        .toList();
  }
}
