extension StringExtensions on String {
  String toSnakeCase() {
    final exp = RegExp('(?<=[a-z])[A-Z]');
    return replaceAllMapped(exp, (match) => '_${match.group(0)}').toLowerCase();
  }
}
