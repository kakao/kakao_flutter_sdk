import 'dart:io';

class LocalizationOptions {
  final String languageCode;
  final String selectLoginMethod;
  final String loginWithKakaoTalk;
  final String loginWithKakaoAccount;

  static LocalizationOptions? _prevOption;

  static String? _prevLocale;
  static const LocalizationOptions _englishOptions = LocalizationOptions(
    'en',
    selectLoginMethod: 'Select a method to log in',
    loginWithKakaoTalk: 'Log in with Kakao Talk',
    loginWithKakaoAccount: 'Enter your Kakao Account',
  );

  static const LocalizationOptions _koreanOptions = LocalizationOptions(
    'ko',
    selectLoginMethod: '로그인 방법을 선택해 주세요',
    loginWithKakaoTalk: '카카오톡으로 로그인',
    loginWithKakaoAccount: '카카오계정 직접 입력',
  );

  static const LocalizationOptions _japaneseOptions = LocalizationOptions(
    'ja',
    selectLoginMethod: 'ログイン方法を選択してください。',
    loginWithKakaoTalk: 'カカオトークでログイン',
    loginWithKakaoAccount: 'カカオアカウントを直接入力',
  );

  static const Map<String, LocalizationOptions> _languageMap = {
    'ko': _koreanOptions,
    'ja': _japaneseOptions,
    'en': _englishOptions,
  };

  const LocalizationOptions(
    this.languageCode, {
    required this.selectLoginMethod,
    required this.loginWithKakaoTalk,
    required this.loginWithKakaoAccount,
  });

  static LocalizationOptions getLocalizationOptions() {
    final platformLocale = Platform.localeName;

    if (_prevLocale == platformLocale && _prevOption != null) {
      return _prevOption!;
    }

    final locale = platformLocale.split('_')[0];
    final localizationOptions = _languageMap[locale] ?? _englishOptions;

    _prevLocale = platformLocale;
    _prevOption = localizationOptions;

    return localizationOptions;
  }
}
