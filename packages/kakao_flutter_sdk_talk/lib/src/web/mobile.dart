/// @nodoc
String androidChannelIntent(String scheme, String channelPublicId, String path,
    {String? queryParameters}) {
  final customScheme = Uri.parse(scheme);

  final query = queryParameters == null ? '' : '?$queryParameters';
  final intent = [
    'intent://${customScheme.authority}/$path$query#Intent',
    'scheme=${customScheme.scheme}',
    'end'
  ].join(';');
  return intent;
}

/// @nodoc
String iosChannelScheme(String scheme, String channelPublicId, String path,
    {String? queryParameters}) {
  final query = queryParameters == null ? '' : '?$queryParameters';
  return '$scheme/$path$query';
}
