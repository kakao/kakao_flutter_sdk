import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk_user/src/component/kakao_colors.dart';
import 'package:kakao_flutter_sdk_user/src/component/square_button.dart';
import 'package:kakao_flutter_sdk_user/src/model/login_ui_mode.dart';

class LoginBridgeBottomSheet extends StatelessWidget {
  final LoginUiMode uiMode;
  static final _lightModeColors = LightMode();
  static final _darkModeColors = DarkMode();
  static const _borderRadius = BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
  );

  // 플랫폼별 패딩 값 캐싱
  static const double _iosPortraitPadding = 25.0;
  static const double _iosLandscapePadding = 73.0;
  static const double _androidPortraitPadding = 8.5;
  static const double _androidLandscapePadding = 16.0;

  const LoginBridgeBottomSheet({
    required this.uiMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final colors = _isDarkMode(mediaQuery) ? _darkModeColors : _lightModeColors;
    final horizontalPadding = _getBottomSheetHorizontalPadding(mediaQuery);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: colors.white001s,
        borderRadius: _borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDragHandler(colors),
          _buildTitleText(colors),
          _buildButtons(colors),
          _buildKakaoLogo(colors),
        ],
      ),
    );
  }

  Padding _buildKakaoLogo(KakaoColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 30),
      child: SvgPicture.asset(
        'assets/images/logo_light.svg',
        package: 'kakao_flutter_sdk_user',
        colorFilter: ColorFilter.mode(colors.gray900s, BlendMode.srcIn),
        width: 44,
        height: 14,
      ),
    );
  }

  Widget _buildButtons(KakaoColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          SquareButton(
            iconAsset: 'assets/images/icon_account_login.svg',
            title: '카카오톡으로 로그인',
            backgroundColor: colors.yellow500s,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          SquareButton(
            iconAsset: 'assets/images/icon_talk_login.svg',
            title: '카카오계정 직접 입력',
            backgroundColor: colors.gray070a,
            iconColor: colors.gray900s,
            textColor: colors.gray900s,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandler(KakaoColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: 36,
        height: 4,
        decoration: ShapeDecoration(
          color: colors.gray500s,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
        ),
      ),
    );
  }

  Padding _buildTitleText(KakaoColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Text(
        "로그인 방법을 선택해 주세요",
        style: TextStyle(
          fontSize: 16,
          height: 0.9,
          fontWeight: FontWeight.w600,
          color: colors.gray900s,
        ),
      ),
    );
  }

  bool _isDarkMode(MediaQueryData mediaQuery) {
    return uiMode == LoginUiMode.dark ||
        (uiMode == LoginUiMode.auto &&
            mediaQuery.platformBrightness == Brightness.dark);
  }

  double _getBottomSheetHorizontalPadding(MediaQueryData mediaQuery) {
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    if (isIOS) {
      return isPortrait ? _iosPortraitPadding : _iosLandscapePadding;
    } else {
      return isPortrait ? _androidPortraitPadding : _androidLandscapePadding;
    }
  }
}

@Preview(name: 'LoginBridgeBottomSheet', size: Size(360, 640))
Widget previewLoginBridgeBottomSheet() {
  return const LoginBridgeBottomSheet(uiMode: LoginUiMode.light);
}
