import 'package:flutter_test/flutter_test.dart';
import 'dart:ui';
import 'package:kakao_flutter_sdk_friend/src/localization_options.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalizationOptions Web Tests', () {

    /// 헬퍼 함수: 테스트 환경에서 locale 값을 강제로 설정하는 함수
    /// Flutter 앱의 로케일을 테스트할 때 실제 기기나 시스템 설정에 의존하지 않고 원하는 로케일을 직접 지정하여 테스트할 수 있게 해줍니다.
    /// `TestWidgetsFlutterBinding.instance.platformDispatcher.localesTestValue`를 이용해 로케일 값을 변경합니다.
    /// @param locale: 설정하려는 `Locale` 객체
      void setWebLocale(Locale locale) {
      TestWidgetsFlutterBinding.instance.platformDispatcher.localesTestValue = [locale];
    }

    test('Returns English options by default when locale is unsupported (Web)', () {
      // Arrange
      setWebLocale(const Locale('xx')); // Unsupported locale

      // Act
      final options = LocalizationOptions.getLocalizationOptions();

      // Assert
      expect(options.languageCode, 'en');
      expect(options.pickerTitle, 'Select Friend(s)');
      expect(options.confirm, 'OK');
    });

    test('Returns English options when no locale is set (Web)', () {
      // Arrange
      setWebLocale(const Locale('en')); // Default locale

      // Act
      final options = LocalizationOptions.getLocalizationOptions();

      // Assert
      expect(options.languageCode, 'en');
      expect(options.pickerTitle, 'Select Friend(s)');
      expect(options.confirm, 'OK');
    });

    test('Returns English options with empty language code locale (Web)', () {
      // Arrange
      setWebLocale(const Locale.fromSubtags()); // Locale with no language code

      // Act
      final options = LocalizationOptions.getLocalizationOptions();

      // Assert
      expect(options.languageCode, 'en');
      expect(options.pickerTitle, 'Select Friend(s)');
      expect(options.confirm, 'OK');
    });
  });
}
