/// @nodoc
extension StringExtensions on String {
  String toSnakeCase() {
    String result = '';
    for (var i = 0; i < length; i++) {
      if (this[i].toUpperCase() == this[i] && i != 0) {
        result += '_';
      }
      result += this[i].toLowerCase();
    }
    return result;
  }
}
