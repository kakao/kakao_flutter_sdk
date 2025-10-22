import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';

@immutable
class SquareButton extends StatelessWidget {
  final String iconAsset;
  final String title;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const SquareButton({
    required this.iconAsset,
    required this.title,
    required this.backgroundColor,
    required this.onPressed,
    super.key,
  });

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
          package: 'kakao_flutter_sdk_user',
          width: 19,
          height: 19,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
        )
      ],
    );
  }
}

@Preview(name: 'SquareButtonPreview', size: Size(360, 640))
Widget previewSquareButton() {
  return SquareButton(
    iconAsset: 'assets/images/icon_talk_login_light.svg',
    title: '카카오톡으로 로그인',
    backgroundColor: Color(0xFFFFE812),
    onPressed: () {},
  );
}
