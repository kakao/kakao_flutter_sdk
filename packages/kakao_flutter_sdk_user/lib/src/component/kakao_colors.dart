import 'package:flutter/material.dart';

class LightMode extends KakaoColorScheme {
  const LightMode();

  @override
  Color get gray900s => KakaoColorScheme.lightGray900s;

  @override
  Color get gray500s => KakaoColorScheme.lightGray500s;

  @override
  Color get gray070a => KakaoColorScheme.lightGray070a;

  @override
  Color get white001s => KakaoColorScheme.lightWhite001s;

  @override
  Color get yellow500s => KakaoColorScheme.lightYellow500s;
}

class DarkMode extends KakaoColorScheme {
  const DarkMode();

  @override
  Color get gray900s => KakaoColorScheme.darkGray900s;

  @override
  Color get gray500s => KakaoColorScheme.darkGray500s;

  @override
  Color get gray070a => KakaoColorScheme.darkGray070a;

  @override
  Color get white001s => KakaoColorScheme.darkWhite001s;

  @override
  Color get yellow500s => KakaoColorScheme.darkYellow500s;
}

abstract class KakaoColorScheme {
  const KakaoColorScheme();

  Color get gray900s;

  Color get gray500s;

  Color get gray070a;

  Color get white001s;

  Color get yellow500s;

  static const Color lightGray900s = Color(0xFF191919);
  static const Color lightGray500s = Color(0xFF949494);
  static const Color lightGray070a = Color(0x0F000000);
  static const Color lightWhite001s = Color(0xFFFFFFFF);
  static const Color lightYellow500s = Color(0xFFFEE500);

  static const Color darkGray900s = Color(0xFFF2F2F2);
  static const Color darkGray500s = Color(0xFF828282);
  static const Color darkGray070a = Color(0x1AFFFFFF);
  static const Color darkWhite001s = Color(0xFF202020);
  static const Color darkYellow500s = Color(0xFFFEE500);
}
