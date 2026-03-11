import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void update(ThemeMode mode) {
    if (state == mode) {
      return;
    }
    state = mode;
  }
}

String themeModeLabel(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.system:
      return 'System';
    case ThemeMode.light:
      return 'Light';
    case ThemeMode.dark:
      return 'Dark';
  }
}

String themeModeDescription(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.system:
      return '시스템 설정에 따라 적용합니다.';
    case ThemeMode.light:
      return '라이트 모드를 적용합니다.';
    case ThemeMode.dark:
      return '다크 모드를 적용합니다.';
  }
}

IconData themeModeIcon(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.system:
      return Icons.brightness_auto_outlined;
    case ThemeMode.light:
      return Icons.light_mode_outlined;
    case ThemeMode.dark:
      return Icons.dark_mode_outlined;
  }
}
