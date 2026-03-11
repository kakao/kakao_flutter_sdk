import 'dart:convert';

/// @nodoc
extension MapExtension<K, V> on Map<K, V?> {
  String toJson() => jsonEncode(this);

  String toEncodedJson() => Uri.encodeComponent(toJson());

  String toQuery() {
    return entries
        .where((e) => e.value != null)
        .map((e) {
          final key = Uri.encodeComponent(e.key.toString());
          final value = Uri.encodeComponent(e.value.toString());
          return '$key=$value';
        })
        .join('&');
  }
}
