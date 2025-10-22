import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk_user/src/component/kakao_colors.dart';
import 'package:kakao_flutter_sdk_user/src/component/square_button.dart';
import 'package:kakao_flutter_sdk_user/src/model/login_ui_mode.dart';

class LoginBridgeBottomSheet extends StatelessWidget {
  final LoginUiMode uiMode;

  const LoginBridgeBottomSheet({
    required this.uiMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _isDarkMode(context) ? DarkMode() : LightMode();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.5),
      decoration: BoxDecoration(
        color: colors.white001s,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDragHandler(),
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
        clipBehavior: Clip.antiAlias,
      ),
    );
  }

  Column _buildButtons(KakaoColorScheme colors) {
    return Column(
      children: [
        const SizedBox(height: 10),
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
    );
  }

  Padding _buildDragHandler() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: 36,
        height: 4,
        decoration: ShapeDecoration(
          color: const Color(0xFF949494),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
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

  bool _isDarkMode(BuildContext context) {
    return uiMode == LoginUiMode.dark ||
        uiMode == LoginUiMode.auto &&
            MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}

@Preview(name: 'LoginBridgeBottomSheet', size: Size(360, 640))
Widget previewLoginBridgeBottomSheet() {
  return const LoginBridgeBottomSheet(uiMode: LoginUiMode.light);
}
