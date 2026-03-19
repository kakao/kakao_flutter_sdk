import 'package:example/list_view.dart';
import 'package:example/model/custom_data.dart';
import 'package:example/theme_mode_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainPage extends ConsumerWidget {
  const MainPage({
    super.key,
    required this.title,
    required this.customData,
    this.extraAppBarActionsBuilder,
  });

  final String title;
  final CustomData customData;
  final List<Widget> Function(BuildContext context)? extraAppBarActionsBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          ...?extraAppBarActionsBuilder?.call(context),
          IconButton(
            onPressed: () => _showThemePickerSheet(context, ref, themeMode),
            icon: Icon(themeModeIcon(themeMode)),
          ),
          IconButton(
            onPressed: () => context.push('/debug'),
            icon: Icon(Icons.bug_report_outlined),
          ),
        ],
      ),
      body: ApiListView(customData: customData),
    );
  }

  Future<void> _showThemePickerSheet(
    BuildContext context,
    WidgetRef ref,
    ThemeMode selectedMode,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: false,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        final bottomPadding = MediaQuery.of(sheetContext).padding.bottom;

        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            top: 12,
            right: 20,
            bottom: 24 + bottomPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...ThemeMode.values.map(
                (mode) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ThemeModeOptionTile(
                    mode: mode,
                    isSelected: mode == selectedMode,
                    onTap: () {
                      ref.read(themeModeProvider.notifier).update(mode);
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeModeOptionTile extends StatelessWidget {
  const _ThemeModeOptionTile({
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  final ThemeMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: isSelected
          ? colorScheme.secondaryContainer
          : colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? colorScheme.secondary
                  : colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.secondary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  themeModeIcon(mode),
                  color: isSelected
                      ? colorScheme.onSecondary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      themeModeLabel(mode),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? colorScheme.onSecondaryContainer
                            : colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      themeModeDescription(mode),
                      style: textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? colorScheme.onSecondaryContainer.withValues(
                                alpha: 0.78,
                              )
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: isSelected
                    ? Icon(
                        Icons.check_circle,
                        key: const ValueKey('selected'),
                        color: colorScheme.secondary,
                      )
                    : Icon(
                        Icons.circle_outlined,
                        key: const ValueKey('unselected'),
                        color: colorScheme.outline,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
