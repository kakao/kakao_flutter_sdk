/// @nodoc
bool isMobileWeb() =>
    throw UnsupportedError('isMobileWeb() is only supported on Web');

/// @nodoc
bool isAndroidWeb() =>
    throw UnsupportedError('isAndroidWeb() is only supported on Web');

/// @nodoc
bool isiOSWeb() =>
    throw UnsupportedError('isiOSWeb() is only supported on Web');

/// @nodoc
void submitForm(String url, Map<String, dynamic> params, {String popupName = ''}) {
  throw UnsupportedError('submitForm() is only supported on Web');
}

/// @nodoc
dynamic createHiddenIframe(String transId, String source) {
  throw UnsupportedError('createHiddenIframe() is only supported on Web');
}

/// @nodoc
dynamic addMessageEventListener(
  dynamic browser,
  String requestDomain,
  dynamic completer,
  Function afterReceive,
) {
  throw UnsupportedError('addMessageEventListener() is only supported on Web');
}
