import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_flutter_sdk_user/src/component/kakao_colors.dart';

@immutable
class SquareButton extends StatelessWidget {
  final String iconAsset;
  final String title;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onPressed;

  SquareButton({
    required this.iconAsset,
    required this.title,
    required this.backgroundColor,
    iconColor,
    textColor,
    required this.onPressed,
    super.key,
  })  : iconColor = iconColor ?? KakaoColorScheme.lightGray900s,
        textColor = textColor ?? KakaoColorScheme.lightGray900s;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        side: BorderSide.none,
        backgroundColor: backgroundColor,
        foregroundColor: Colors.black54,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: SizedBox(height: 46, child: _buildIconAndText()),
    );
  }

  Widget _buildIconAndText() {
    return Row(
      spacing: 4,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          iconAsset,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          package: 'kakao_flutter_sdk_user',
          width: 19,
          height: 19,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        )
      ],
    );
  }
}

@Preview(name: 'SquareButtonPreview', size: Size(360, 640))
Widget previewSquareButton() {
  return SquareButton(
    iconAsset: 'assets/images/icon_account_login.svg',
    title: '카카오톡으로 로그인',
    backgroundColor: const Color(0xFFFFE812),
    textColor: Colors.black54,
    onPressed: () {},
  );
}
