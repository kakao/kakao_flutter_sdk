import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'constants.dart';
import 'model/picker_friend_request_params.dart';

/// nodoc
class PickerWebView extends StatefulWidget {
  const PickerWebView({
    super.key,
    required this.params,
    required this.enableMulti,
  });

  final bool enableMulti;
  final PickerFriendRequestParams params;

  @override
  State<PickerWebView> createState() => _PickerWebViewState();
}

class _PickerWebViewState extends State<PickerWebView> {
  static String domain = 'https://${KakaoSdk.hosts.picker}';

  late final String _initialUrl = '$domain/${Constants.sdkPath}';
  late final WebViewController _controller = _createWebViewController();

  bool _pickerShown = false;

  @override
  void initState() {
    super.initState();
    _controller.loadRequest(Uri.parse(_initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: WebViewWidget(controller: _controller)),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the WebView to prevent memory leaks.
    _controller.removeJavaScriptChannel(Constants.jsChannel);
    // _controller.removeJavaScriptChannel(Constants.jsAlertChannel);
    _controller.loadRequest(Uri.parse(Constants.aboutBlankUrl));
    super.dispose();
  }

  WebViewController _createWebViewController() {
    final params = const PlatformWebViewControllerCreationParams();

    return WebViewController.fromPlatformCreationParams(params)
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black.withAlpha(0))
      ..addJavaScriptChannel(
        Constants.jsChannel,
        onMessageReceived: _onJavaScriptMessage,
      )
      ..setOnJavaScriptAlertDialog(_onJavaScriptAlert)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: _onNavigationRequest,
          onPageFinished: _onPageFinished,
        ),
      );
  }

  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    // Block unexpected external navigation.
    if (!request.url.contains(KakaoSdk.hosts.picker)) {
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  Future<void> _onJavaScriptAlert(JavaScriptAlertDialogRequest request) {
    final snackBar = SnackBar(content: Text(request.message));
    return Future.sync(() {
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
      scaffoldMessenger?.hideCurrentSnackBar();
      scaffoldMessenger?.showSnackBar(snackBar);
    });
  }

  void _onPageFinished(String url) {
    if (!_pickerShown) {
      _startPickerNavigation();
      return;
    }

    if (_isReturnUrl(url)) {
      final queryParameters = Uri.parse(url).queryParameters;
      if (queryParameters.isNotEmpty) {
        Navigator.of(context).pop(queryParameters);
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  void _startPickerNavigation() {
    _controller.runJavaScript(
      '${Constants.jsChannel}.postMessage("${Constants.navigatePickerMessage}")',
    );
    _pickerShown = true;
  }

  bool _isReturnUrl(String url) => url.contains(_initialUrl);

  Future<void> _onJavaScriptMessage(JavaScriptMessage message) async {
    if (message.message != Constants.navigatePickerMessage) return;

    final url = _pickerUrl(enableMulti: widget.enableMulti);
    final pickerParams = await _createPickerParams();

    final javascript = _submitForm(url, pickerParams);
    await _controller.runJavaScript(javascript);
  }

  String _pickerUrl({required bool enableMulti}) {
    final path = enableMulti
        ? Constants.multiPickerPath
        : Constants.singlePickerPath;
    return '$domain/$path';
  }

  Future<Map<String, Object>> _createPickerParams() async {
    final token =
        (await TokenManagerProvider.instance.manager.getToken())!.accessToken;
    final transId = generateRandomString(60);

    return {
      Constants.transId: transId,
      Constants.appKey: KakaoSdk.appKey,
      Constants.ka: KakaoSdk.platformInfo.kaHeader,
      Constants.token: token,
      Constants.title: ?widget.params.title,
      Constants.enableSearch: ?widget.params.enableSearch,
      Constants.showMyProfile: ?widget.params.showMyProfile,
      Constants.showFavorite: ?widget.params.showFavorite,
      Constants.showPickedFriend: ?widget.params.showPickedFriend,
      Constants.maxPickableCount: ?widget.params.maxPickableCount,
      Constants.minPickableCount: ?widget.params.minPickableCount,
      Constants.enableBackButton: ?widget.params.enableBackButton,
      Constants.returnUrl: _initialUrl,
    };
  }

  String _submitForm(
    String url,
    Map<String, Object> pickerParams, {
    String popupName = '',
  }) {
    return """
      const param = ${jsonEncode(pickerParams)}
      const form = document.createElement('form')
      form.setAttribute('accept-charset', 'utf-8')
      form.setAttribute('method', 'post')
      form.setAttribute('action', '$url')
      form.setAttribute('target', '$popupName')
      form.setAttribute('style', 'display:none')

      for (var key in param) {
        const input = document.createElement('input')
        input.type = 'hidden'
        input.name = key
        input.value = String(param[key])
        form.appendChild(input)
      }

      document.body.appendChild(form);
      form.submit();
      document.body.removeChild(form);
    """;
  }
}
