import 'package:flutter/widgets.dart';

sealed class ListItem {
  const ListItem(this.title);

  final String title;
}

class Header extends ListItem {
  const Header(super.title);
}

class Api extends ListItem {
  const Api(super.title, this.api, {this.showResult = true});

  final dynamic Function(BuildContext context) api;
  final bool showResult;
}
