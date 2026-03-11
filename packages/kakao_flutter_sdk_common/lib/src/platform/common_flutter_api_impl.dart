import '../pigeon/common_messages.g.dart';

/// @nodoc
class CommonFlutterApiImpl extends CommonFlutterApi {
  CommonFlutterApiImpl(this._callback);

  final Function(String url) _callback;

  @override
  void onDeepLinkReceived(String url) => _callback(url);
}
