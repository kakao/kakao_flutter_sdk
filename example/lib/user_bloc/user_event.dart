import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserEvent extends Equatable {
  UserEvent([List props = const []]) : super(props);
}

class AppStarted extends UserEvent {
  @override
  String toString() => "AppStarted";
}

class UserFetchStarted extends UserEvent {
  @override
  String toString() => "UserFetchStarted";
}

class UserLogOut extends UserEvent {
  @override
  String toString() => runtimeType.toString();
}

class UserUnlink extends UserEvent {}
