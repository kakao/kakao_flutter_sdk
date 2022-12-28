import 'dart:io';

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
    var locale = Platform.localeName.split('_')[0];

    LocalizationOptions localizationOptions;
    switch (locale) {
      case "ko":
        localizationOptions = buildKoreanOptions();
        break;
      case "ja":
        localizationOptions = buildJapaneseOptions();
        break;
      default:
        localizationOptions = buildEnglishOptions();
        break;
    }
    return localizationOptions;
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
