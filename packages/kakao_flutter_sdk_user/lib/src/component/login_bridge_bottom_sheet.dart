import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk_user/src/component/square_button.dart';

enum LoginUiMode {
  light,
  dark,
  auto,
}

class LoginBridgeBottomSheet extends StatelessWidget {
  final LoginUiMode uiMode;

  const LoginBridgeBottomSheet({
    LoginUiMode themeMode = LoginUiMode.auto,
    super.key,
  }) : uiMode = themeMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.5),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDragHandler(),
          _buildTitleText(),
          _buildButtons(),
          _buildKakaoLogo(),
        ],
      ),
    );
  }

  Padding _buildKakaoLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 30),
      child: SvgPicture.asset(
        'assets/images/logo_light.svg',
        package: 'kakao_flutter_sdk_user',
        width: 44,
        height: 14,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }

  Column _buildButtons() {
    return Column(
      children: [
        const SizedBox(height: 10),
        SquareButton(
          iconAsset: 'assets/images/icon_talk_login_light.svg',
          title: '카카오톡으로 로그인',
          backgroundColor: const Color(0xFFFFE500),
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        SquareButton(
          iconAsset: 'assets/images/icon_account_login_light.svg',
          title: '카카오계정 직접 입력',
          backgroundColor: Colors.black.withValues(alpha: 0.06),
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

  Padding _buildTitleText() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Text(
        "로그인 방법을 선택해 주세요",
        style: TextStyle(
          fontSize: 16,
          height: 0.9,
          fontWeight: FontWeight.w600,
          color: Color(0xFF191919),
        ),
      ),
    );
  }
}

@Preview(name: 'LoginBridgeBottomSheet', size: Size(360, 640))
Widget previewLoginBridgeBottomSheet() {
  return const LoginBridgeBottomSheet(themeMode: LoginUiMode.light);
}
