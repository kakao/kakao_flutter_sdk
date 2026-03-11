import 'dart:async';

import 'package:example/model/custom_data.dart';
import 'package:example/model/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api/sdk_apis.dart';
import 'util/api_call_context.dart';

enum _ApiCallState { idle, pending, success, failure }

final _apiCallStateProvider =
    NotifierProvider<_ApiCallStateNotifier, Map<int, _ApiCallState>>(
      _ApiCallStateNotifier.new,
    );

class _ApiCallStateNotifier extends Notifier<Map<int, _ApiCallState>> {
  @override
  Map<int, _ApiCallState> build() => const <int, _ApiCallState>{};

  final Map<int, int> _activeRunIdByIndex = <int, int>{};
  int _nextRunId = 0;

  _ApiCallState stateOf(int index) => state[index] ?? _ApiCallState.idle;

  void setStateOf(int index, _ApiCallState callState) {
    state = <int, _ApiCallState>{...state, index: callState};
  }

  int startRun(int index) {
    final runId = ++_nextRunId;
    _activeRunIdByIndex[index] = runId;
    setStateOf(index, _ApiCallState.pending);
    return runId;
  }

  bool isActiveRun(int index, int runId) {
    return _activeRunIdByIndex[index] == runId;
  }

  bool setIdleIfActiveRun(int index, int runId) {
    if (!isActiveRun(index, runId)) {
      return false;
    }

    setStateOf(index, _ApiCallState.idle);
    return true;
  }

  bool completeRun(int index, int runId, _ApiCallState callState) {
    if (!isActiveRun(index, runId)) {
      return false;
    }

    _activeRunIdByIndex.remove(index);
    setStateOf(index, callState);
    return true;
  }
}

final _collapsedHeaderIndicesProvider =
    NotifierProvider<_CollapsedHeaderNotifier, Set<int>>(
      _CollapsedHeaderNotifier.new,
    );

class _CollapsedHeaderNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => const <int>{};

  void toggle(int headerIndex) {
    final next = <int>{...state};
    if (!next.add(headerIndex)) {
      next.remove(headerIndex);
    }
    state = next;
  }
}

class ApiListView extends ConsumerWidget {
  const ApiListView({required this.customData, super.key});

  final CustomData customData;

  _ApiTileColors _tileColorsOf(BuildContext context, _ApiCallState state) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (state) {
      case _ApiCallState.success:
        return _ApiTileColors(
          backgroundColor: colorScheme.tertiaryContainer,
          foregroundColor: colorScheme.onTertiaryContainer,
        );
      case _ApiCallState.failure:
        return _ApiTileColors(
          backgroundColor: colorScheme.errorContainer,
          foregroundColor: colorScheme.onErrorContainer,
        );
      case _ApiCallState.idle:
      case _ApiCallState.pending:
        return _ApiTileColors(
          backgroundColor: null,
          foregroundColor: colorScheme.onSurface,
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sdkApis = createSdkApis(customData);
    final collapsedHeaderIndices = ref.watch(_collapsedHeaderIndicesProvider);
    final headerIndexByItemIndex = _buildHeaderIndexByItemIndex(sdkApis);

    return ListView.builder(
      itemCount: sdkApis.length,
      itemBuilder: (context, index) {
        final item = sdkApis[index];
        final showDivider = index < sdkApis.length - 1;

        switch (item) {
          case Header():
            return _HeaderTile(
              index: index,
              title: item.title,
              showDivider: showDivider,
            );
          case Api():
            final headerIndex = headerIndexByItemIndex[index];
            final isVisible = headerIndex == null
                ? true
                : !collapsedHeaderIndices.contains(headerIndex);
            return _ApiTile(
              index: index,
              item: item,
              isVisible: isVisible,
              showDivider: showDivider,
              tileColorsOf: _tileColorsOf,
              onRunApi: () => _runApi(context, ref, index, item),
            );
        }
      },
    );
  }

  Future<void> _runApi(
    BuildContext context,
    WidgetRef ref,
    int index,
    Api item,
  ) async {
    final stateNotifier = ref.read(_apiCallStateProvider.notifier);

    if (stateNotifier.stateOf(index) == _ApiCallState.pending) {
      return;
    }

    final runId = stateNotifier.startRun(index);

    final action = item.api;
    final collector = ApiResultCollector();
    final idleTimer = Timer(const Duration(seconds: 10), () {
      stateNotifier.setIdleIfActiveRun(index, runId);
    });

    try {
      final result = await runZoned(
        () async {
          return await Future<dynamic>.value(action(context));
        },
        zoneValues: {
          ApiCallContext.apiCallZoneKey: true,
          ApiCallContext.apiCallResultCollectorZoneKey: collector,
        },
      );

      if (collector.hasError) {
        throw collector.error ?? Exception(collector.message ?? '호출 실패');
      }

      final didComplete = stateNotifier.completeRun(
        index,
        runId,
        _ApiCallState.success,
      );
      if (!didComplete) {
        return;
      }

      if (!context.mounted || !item.showResult) {
        return;
      }

      await _showResultDialog(
        context: context,
        title: item.title,
        result: collector.message ?? result?.toString() ?? '호출 성공 (반환값 없음)',
      );
    } catch (error, stackTrace) {
      debugPrint('$error\n$stackTrace');
      final didComplete = stateNotifier.completeRun(
        index,
        runId,
        _ApiCallState.failure,
      );
      if (!didComplete) {
        return;
      }

      if (!context.mounted || !item.showResult) {
        return;
      }

      await _showResultDialog(
        context: context,
        title: '${item.title} 실패',
        result: collector.message ?? error.toString(),
      );
    } finally {
      idleTimer.cancel();
    }
  }

  Future<void> _showResultDialog({
    required BuildContext context,
    required String title,
    required String result,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  List<int?> _buildHeaderIndexByItemIndex(List<ListItem> sdkApis) {
    final indices = List<int?>.filled(sdkApis.length, null);
    int? currentHeaderIndex;

    for (var index = 0; index < sdkApis.length; index++) {
      final item = sdkApis[index];
      if (item is Header) {
        currentHeaderIndex = index;
        continue;
      }

      indices[index] = currentHeaderIndex;
    }

    return indices;
  }
}

class _HeaderTile extends ConsumerWidget {
  const _HeaderTile({
    required this.index,
    required this.title,
    required this.showDivider,
  });

  final int index;
  final String title;
  final bool showDivider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(
      _collapsedHeaderIndicesProvider.select((state) => state.contains(index)),
    );
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          header: true,
          button: true,
          child: Material(
            color: colorScheme.primaryContainer,
            child: InkWell(
              onTap: () => ref
                  .read(_collapsedHeaderIndicesProvider.notifier)
                  .toggle(index),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 16,
                  end: 16,
                  top: 4,
                ),
                child: SizedBox(
                  height: 28,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: isCollapsed ? 0 : 0.5,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}

class _ApiTile extends ConsumerWidget {
  const _ApiTile({
    required this.index,
    required this.item,
    required this.isVisible,
    required this.showDivider,
    required this.tileColorsOf,
    required this.onRunApi,
  });

  final int index;
  final Api item;
  final bool isVisible;
  final bool showDivider;
  final _ApiTileColors Function(BuildContext context, _ApiCallState)
  tileColorsOf;
  final VoidCallback onRunApi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callState = ref.watch(
      _apiCallStateProvider.select(
        (states) => states[index] ?? _ApiCallState.idle,
      ),
    );
    final tileColors = tileColorsOf(context, callState);

    final tile = ListTile(
      title: Text(item.title),
      tileColor: tileColors.backgroundColor,
      textColor: tileColors.foregroundColor,
      iconColor: tileColors.foregroundColor,
      trailing: callState == _ApiCallState.pending
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      onTap: onRunApi,
    );

    return ClipRect(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          opacity: isVisible ? 1 : 0,
          child: IgnorePointer(
            ignoring: !isVisible,
            child: isVisible
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [tile, if (showDivider) const Divider(height: 1)],
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

class _ApiTileColors {
  const _ApiTileColors({
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final Color? backgroundColor;
  final Color foregroundColor;
}
