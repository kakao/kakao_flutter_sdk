import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_common/src/web/ua_parser.dart';

class KakaoFlutterSdkPlugin {
  final _uaParser = UaParser();

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
        "kakao_flutter_sdk", const StandardMethodCodec(), registrar.messenger);

    final KakaoFlutterSdkPlugin instance = KakaoFlutterSdkPlugin();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "launchBrowserTab":
        Map<dynamic, dynamic> args = call.arguments;
        String uri = args["url"];
        final fullUri = Uri.parse(uri);
        Map<String, dynamic> queryParameters =
            Map.from(fullUri.queryParameters);
        queryParameters["redirect_uri"] = html.window.location.origin;
        final finalUri = fullUri.replace(queryParameters: queryParameters);
        html.window.open(finalUri.toString(), "KakaoAccountLogin");
        final completer = Completer();
        html.window.addEventListener("message", (html.Event e) {
          if (e is html.MessageEvent) {
            return completer.complete(e.data);
          } else {
            return completer.completeError(PlatformException(
                code: "NotMessageEvent",
                details: "Received wrong type of event ${e.runtimeType}"));
          }
        });
        return completer.future;
      case "retrieveAuthCode":
        _retrieveAuthCode();
        break;
      case "getOrigin":
        return html.window.location.origin;
      case "getKaHeader":
        return _getKaHeader();
      case "isKakaoTalkInstalled":
        return false;
      case "platformId":
        return Uint8List.fromList([1, 2, 3]);
      case "platformRedirectURi":
        String ua = html.window.navigator.userAgent;
        if (_uaParser.isAndroid(ua)) {
          return "${CommonConstants.scheme}://${KakaoSdk.hosts.kapi}${CommonConstants.androidWebRedirectUri}";
        } else if (_uaParser.isiOS(ua)) {
          return CommonConstants.iosWebRedirectUri;
        }
        return null;
      case "authorizeWithTalk":
        String ua = html.window.navigator.userAgent;
        var arguments = call.arguments;

        String fallbackUrl = _redirectLoginThroughWeb(Map.castFrom(arguments));

        Browser currentBrowser = _uaParser.detectBrowser(ua);

        if (_uaParser.isAndroid(ua)) {
          String intent =
              _getAndroidLoginIntent(Map.castFrom(arguments), fallbackUrl);

          if (currentBrowser == Browser.kakaotalk ||
              currentBrowser == Browser.daum) {
            html.window.location.href = intent;
          } else {
            html.window.open(intent, '_blank');
          }
        } else if (_uaParser.isiOS(ua)) {
          String iosLoginScheme = _getIosLoginScheme(Map.castFrom(arguments));
          String universalLink =
              '${CommonConstants.iosWebUniversalLink}${Uri.encodeComponent(iosLoginScheme)}&web=${Uri.encodeComponent(fallbackUrl)}';

          if (currentBrowser == Browser.kakaotalk) {
            html.window.location.href = universalLink;
          } else {
            html.window.open(universalLink, "_blank");
          }
        }
        break;
      case 'launchKakaoTalk':
        String ua = html.window.navigator.userAgent;
        String uri = call.arguments['uri'];

        if (_uaParser.isAndroid(ua)) {
          final intent = _getAndroidShareIntent(uri);

          html.window.location.href = intent;
          return true;
        } else if (_uaParser.isiOS(ua)) {
          html.window.location.href = uri;
          return true;
        }
        return false;
      case "navigate":
      case "shareDestination":
        String ua = html.window.navigator.userAgent;

        String scheme = 'kakaonavi-sdk://navigate';
        String queries =
            'apiver=1.0&appkey=${KakaoSdk.appKey}&param=${Uri.encodeComponent(call.arguments['navi_params'])}&extras=${Uri.encodeComponent(call.arguments['extras'])}';

        if (_uaParser.isAndroid(ua)) {
          html.window.location.href = _getAndroidNaviIntent(scheme, queries);
          return true;
        } else if (_uaParser.isiOS(ua)) {
          _bindPageHideEvent(_deferredFallback(
              'https://kakaonavi.kakao.com/launch/index.do?$queries',
              (storeUrl) {
            html.window.top?.location.href = storeUrl;
          }));

          html.window.location.href = '$scheme?$queries';

          return true;
        }
        return false;
      default:
        throw PlatformException(
            code: "NotImplemented",
            details:
                "KakaoFlutterSdk for web doesn't implement the method ${call.method}");
    }
  }

  void _retrieveAuthCode() {
    final uri = Uri.parse(html.window.location.search!);
    final params = uri.queryParameters;
    if (params.containsKey("code") || params.containsKey("error")) {
      html.window.opener?.postMessage(html.window.location.href, "*");
      html.window.close();
    }
  }

  String _getKaHeader() {
    return "os/javascript origin/${html.window.location.origin}";
  }

  String _getAndroidShareIntent(String uri) {
    final newIntent = 'intent://send?$uri#Intent;scheme=kakaolink';
    final oldIntent = 'intent:$uri#Intent';

    final intent = [
      oldIntent,
      'launchFlags=0x14008000',
      'package=com.kakao.talk',
      'end;'
    ].join(';');
    return intent;
  }

  String _getAndroidLoginIntent(
      Map<String, dynamic> arguments, String fallbackUrl) {
    Map<String, dynamic> extras = {
      'channel_public_id': arguments['channel_public_ids'],
      'service_terms': arguments['service_terms'],
      'approval_type': arguments['approval_type'],
      'prompt': arguments['prompt'],
      'state': arguments['state'],
    };
    extras.removeWhere((k, v) => v == null);

    String intent = [
      'intent:#Intent',
      'action=com.kakao.talk.intent.action.CAPRI_LOGGED_IN_ACTIVITY',
      'launchFlags=0x08880000',
      'S.com.kakao.sdk.talk.appKey=${KakaoSdk.appKey}',
      'S.com.kakao.sdk.talk.redirectUri=${arguments['redirect_uri']}',
      'S.com.kakao.sdk.talk.state=${arguments['state_token']}',
      'S.com.kakao.sdk.talk.kaHeader=${_getKaHeader()}',
      'S.com.kakao.sdk.talk.extraparams=${Uri.encodeComponent(jsonEncode(extras))}',
      'S.browser_fallback_url=${Uri.encodeComponent(fallbackUrl)}',
      'end;',
    ].join(';');
    return intent;
  }

  String _getAndroidNaviIntent(String scheme, String queries) {
    var url = '$scheme?$queries';

    final intent = [
      'intent:$url#Intent',
      'package=com.locnall.KimGiSa',
      'S.browser_fallback_url=${Uri.encodeComponent('https://kakaonavi.kakao.com/launch/index.do?$queries')}',
      'end;'
    ].join(';');
    return intent;
  }

  String _getIosLoginScheme(Map<String, dynamic> arguments) {
    var authParams = {
      'client_id': KakaoSdk.appKey,
      'approval_type': arguments['approval_type'],
      'scope': arguments['scope'],
      'state': arguments['state_token'],
      'channel_public_id': arguments['channel_public_id'],
      'prompt': arguments['prompt'],
      'device_type': arguments['device_type'],
      'login_hint': arguments['login_hint'],
      'nonce': arguments['nonce'],
      'extra.plus_friend_public_id': arguments['plus_friend_public_id'],
      'extra.service_terms': arguments['service_terms'],
    };
    authParams.removeWhere((k, v) => v == null);

    var params = {
      'client_id': KakaoSdk.appKey,
      'redirect_uri': arguments[CommonConstants.redirectUri],
      'params': jsonEncode(authParams),
    };
    params.removeWhere((k, v) => v == null);

    return Uri.parse(CommonConstants.iosTalkLoginScheme)
        .replace(queryParameters: params)
        .toString();
  }

  String _loginThroughWeb(Map<String, dynamic> arguments) {
    return Uri.parse('${CommonConstants.scheme}://${KakaoSdk.hosts.kauth}')
        .replace(queryParameters: arguments)
        .toString();
  }

  String _redirectLoginThroughWeb(Map<String, dynamic> arguments) {
    var params = {
      'client_id': KakaoSdk.appKey,
      'approval_type': arguments['approval_type'],
      'scope': arguments['scope'],
      'state': arguments['state_token'],
      'channel_public_id': arguments['channel_public_id'],
      'prompt': arguments['prompt'],
      'login_hint': arguments['login_hint'],
      'nonce': arguments['nonce'],
      'redirect_uri': arguments[CommonConstants.redirectUri],
      'response_type': 'code',
      'ka': _getKaHeader(),
      'device_type': html.window.location.origin,
      'extra.channel_public_id': arguments['channel_public_ids'],
      'extra.service_terms': arguments['service_terms'],
    };

    params.removeWhere((k, v) => v == null);

    return Uri.parse(
            '${CommonConstants.scheme}://${KakaoSdk.hosts.kauth}/oauth/authorize')
        .replace(queryParameters: params)
        .toString();
  }

  Timer _deferredFallback(String storeUrl, Function(String) fallback) {
    int timeout = 5000;

    return Timer(Duration(milliseconds: timeout), () {
      fallback(storeUrl);
    });
  }

  _bindPageHideEvent(Timer timer) {
    EventListener? listener;

    listener = (event) {
      if (!_isPageVisible()) {
        timer.cancel();
        html.window.removeEventListener('pagehide', listener);
        html.window.removeEventListener('visibilitychange', listener);
      }
    };

    html.window.addEventListener('pagehide', listener);
    html.window.addEventListener('visibilitychange', listener);
  }

  bool _isPageVisible() {
    if (html.document.hidden != null) {
      return !html.document.hidden!;
    }
    return true;
  }
}
