import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TalkerPage extends ConsumerWidget {
  const TalkerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = ref.watch(talkerProvider);

    return TalkerScreen(talker: talker);
  }
}
