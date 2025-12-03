import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_flutter_sdk_user/src/component/kakao_colors.dart';
import 'package:kakao_flutter_sdk_user/src/component/localization_options.dart';
import 'package:kakao_flutter_sdk_user/src/component/login_bridge_paddings.dart';
import 'package:kakao_flutter_sdk_user/src/component/square_button.dart';
import 'package:kakao_flutter_sdk_user/src/model/login_ui_mode.dart';

class LoginBridgeBottomSheet extends StatelessWidget {
  final LoginUiMode uiMode;
  final LocalizationOptions? _localization;
  final VoidCallback onTalkLoginPressed;
  final VoidCallback onAccountLoginPressed;

  static const _lightModeColors = LightMode();
  static const _darkModeColors = DarkMode();
  static const _borderRadius = BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
  );

  late final LoginBridgePaddings paddings;

  late final LocalizationOptions _localString;

  LoginBridgeBottomSheet({
    required this.uiMode,
    LocalizationOptions? localization,
    required this.onTalkLoginPressed,
    required this.onAccountLoginPressed,
    super.key,
  }) : _localization = localization {
    _localString =
        _localization ?? LocalizationOptions.getLocalizationOptions();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final colors = _isDarkMode(mediaQuery) ? _darkModeColors : _lightModeColors;
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    paddings = isIOS ? IosPaddings() : AndroidPaddings();
    final horizontalPadding = _getBottomSheetHorizontalPadding(mediaQuery);

    return SafeArea(
      child: Container(
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
            _buildButtons(colors, onTalkLoginPressed, onAccountLoginPressed),
            _buildKakaoLogo(mediaQuery, colors),
          ],
        ),
      ),
    );
  }

  Padding _buildKakaoLogo(MediaQueryData mediaQuery, KakaoColorScheme colors) {
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    return Padding(
      padding: EdgeInsets.only(
        top: 24,
        bottom: isPortrait
            ? paddings.logoPortraitBottomPadding
            : paddings.logoLandscapeBottomPadding,
      ),
      child: SvgPicture.asset(
        'assets/images/logo_light.svg',
        package: 'kakao_flutter_sdk_user',
        colorFilter: ColorFilter.mode(colors.gray900s, BlendMode.srcIn),
        width: 44,
        height: 14,
      ),
    );
  }

  Widget _buildButtons(
    KakaoColorScheme colors,
    VoidCallback onKakaoTalkLoginPressed,
    VoidCallback onKakaoAccountLoginPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          SquareButton(
            iconAsset: 'assets/images/icon_talk_login.svg',
            title: _localString.loginWithKakaoTalk.keepWord(),
            backgroundColor: colors.yellow500s,
            onPressed: onKakaoTalkLoginPressed,
          ),
          const SizedBox(height: 12),
          SquareButton(
            iconAsset: 'assets/images/icon_account_login.svg',
            title: _localString.loginWithKakaoAccount.keepWord(),
            backgroundColor: colors.gray070a,
            iconColor: colors.gray900s,
            textColor: colors.gray900s,
            rippleColor: colors.gray900s,
            onPressed: onKakaoAccountLoginPressed,
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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2))),
        ),
      ),
    );
  }

  Padding _buildTitleText(KakaoColorScheme colors) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          0, paddings.titleTopPadding, 0, paddings.titleBottomPadding),
      child: Text(
        _localString.selectLoginMethod.keepWord(),
        style: TextStyle(
          fontSize: 16,
          height: 0.9,
          fontWeight: FontWeight.w600,
          color: colors.gray900s,
        ),
        textAlign: TextAlign.center,
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
    return isPortrait ? paddings.portraitPadding : paddings.landscapePadding;
  }
}

@Preview(name: 'LoginBridgeBottomSheet', size: Size(360, 640))
Widget previewLoginBridgeBottomSheet() {
  return LoginBridgeBottomSheet(
    uiMode: LoginUiMode.light,
    onTalkLoginPressed: () {},
    onAccountLoginPressed: () {},
  );
}
