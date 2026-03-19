import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';

import '../model/login_ui_mode.dart';
import 'kakao_colors.dart';
import 'localization_options.dart';
import 'login_bridge_paddings.dart';
import 'square_button.dart';

/// @nodoc
class LoginBridgeBottomSheet extends StatelessWidget {
  final LoginUiMode uiMode;
  final LocalizationOptions _localString;
  final VoidCallback onTalkLoginPressed;
  final VoidCallback onAccountLoginPressed;

  static const _lightModeColors = LightMode();
  static const _darkModeColors = DarkMode();
  static const _borderRadius = BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
  );

  LoginBridgeBottomSheet({
    required this.uiMode,
    LocalizationOptions? localization,
    required this.onTalkLoginPressed,
    required this.onAccountLoginPressed,
    super.key,
  }) : _localString =
           localization ?? LocalizationOptions.getLocalizationOptions();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final colors = _isDarkMode(mediaQuery) ? _darkModeColors : _lightModeColors;
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    final paddings = isIOS ? IosPaddings() : AndroidPaddings();

    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final horizontalPadding = isPortrait
        ? paddings.portraitPadding
        : paddings.landscapePadding;

    return Container(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: isIOS ? 0 : mediaQuery.padding.bottom, // android edge to edge 대응
      ),
      decoration: BoxDecoration(
        color: colors.white001s,
        borderRadius: _borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDragHandler(colors),
          _buildTitleText(colors, paddings),
          _buildButtons(colors, onTalkLoginPressed, onAccountLoginPressed),
          _buildKakaoLogo(isPortrait, paddings, colors),
        ],
      ),
    );
  }

  Padding _buildKakaoLogo(
    bool isPortrait,
    LoginBridgePaddings paddings,
    KakaoColorScheme colors,
  ) {
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
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
      ),
    );
  }

  Padding _buildTitleText(
    KakaoColorScheme colors,
    LoginBridgePaddings paddings,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        paddings.titleTopPadding,
        0,
        paddings.titleBottomPadding,
      ),
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
}

@Preview(name: 'LoginBridgeBottomSheet', size: Size(360, 640))
Widget previewLoginBridgeBottomSheet() {
  return LoginBridgeBottomSheet(
    uiMode: LoginUiMode.light,
    onTalkLoginPressed: () {},
    onAccountLoginPressed: () {},
  );
}
