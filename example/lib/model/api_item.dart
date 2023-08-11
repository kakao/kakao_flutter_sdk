import 'dart:ui';

class ApiItem {
  String label;
  Color? backgroundColor;
  Function()? api;

  ApiItem(this.label, {this.backgroundColor, this.api});
}
