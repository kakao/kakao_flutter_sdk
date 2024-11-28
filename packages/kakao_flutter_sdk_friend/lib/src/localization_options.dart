import 'dart:ui';

/// @nodoc
class LocalizationOptions {
  final String languageCode;
  final String pickerTitle;
  final String confirm;

  const LocalizationOptions(
    this.languageCode, {
    this.pickerTitle = 'Select Friend(s)',
    this.confirm = 'OK',
  });

  static LocalizationOptions getLocalizationOptions() {
    final locale = PlatformDispatcher.instance.locale.languageCode;

    switch (locale) {
      case "ko":
        return buildKoreanOptions();
      case "ja":
        return buildJapaneseOptions();
      default:
        return buildEnglishOptions();
    }
  }

  static LocalizationOptions buildKoreanOptions() {
    return const LocalizationOptions(
      'ko',
      pickerTitle: '친구 선택',
      confirm: '확인',
    );
  }

  static LocalizationOptions buildEnglishOptions() {
    return const LocalizationOptions('en');
  }

  static LocalizationOptions buildJapaneseOptions() {
    return const LocalizationOptions(
      'jp',
      pickerTitle: 'カカとも選択',
      confirm: '確認',
    );
  }
}
