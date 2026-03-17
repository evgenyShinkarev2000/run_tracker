import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:run_tracker/Data/export.dart';

class TrackHistoryList extends ConsumerStatefulWidget {
  const TrackHistoryList({super.key});

  @override
  ConsumerState<TrackHistoryList> createState() => _TrackHistoryListState();
}

class _TrackHistoryListState extends ConsumerState<TrackHistoryList> {
  late final PagingController _controller =
      PagingController<int, TrackRecordSummary>(
        getNextPageKey: (state) =>
            state.lastPageIsEmpty ? null : state.nextIntPageKey,
        fetchPage: _fetchSummary,
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  Future<List<TrackRecordSummary>> _fetchSummary(int pageKey) async {
    return [];
  }
}
