import 'package:flutter/material.dart';

class LightMode extends KakaoColorScheme {
  @override
  Color gray900s = KakaoColorScheme.lightGray900s;

  @override
  Color gray500s = KakaoColorScheme.lightGray500s;

  @override
  Color gray070a = KakaoColorScheme.lightGray070a;

  @override
  Color white001s = KakaoColorScheme.lightWhite001s;

  @override
  Color yellow500s = KakaoColorScheme.lightYellow500s;
}

class DarkMode extends KakaoColorScheme {
  @override
  Color gray900s = KakaoColorScheme.darkGray900s;

  @override
  Color gray500s = KakaoColorScheme.darkGray500s;

  @override
  Color gray070a = KakaoColorScheme.darkGray070a;

  @override
  Color white001s = KakaoColorScheme.darkWhite001s;

  @override
  Color yellow500s = KakaoColorScheme.darkYellow500s;
}

abstract class KakaoColorScheme {
  abstract Color gray900s;
  abstract Color gray500s;
  abstract Color gray070a;
  abstract Color white001s;
  abstract Color yellow500s;

  static Color lightGray900s = const Color(0xFF191919);
  static Color lightGray500s = const Color(0xFF949494);
  static Color lightGray070a = const Color(0x0F000000);
  static Color lightWhite001s = const Color(0xFFFFFFFF);
  static Color lightYellow500s = const Color(0xFFFEE500);

  static Color darkGray900s = const Color(0xFFF2F2F2);
  static Color darkGray500s = const Color(0xFF828282);
  static Color darkGray070a = const Color(0x1AFFFFFF);
  static Color darkWhite001s = const Color(0xFF202020);
  static Color darkYellow500s = const Color(0xFFFEE500);
}
