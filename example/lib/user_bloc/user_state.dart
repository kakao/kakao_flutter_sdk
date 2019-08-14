import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:kakao_flutter_sdk/user.dart';

@immutable
abstract class UserState extends Equatable {
  UserState([List props = const []]) : super(props);
}

class UserUninitialized extends UserState {
  @override
  String toString() => "UserUninitialized";
}

class UserLoggedOut extends UserState {}

class UserFetched extends UserState {
  final User user;

  UserFetched(this.user) : super([user]);

  @override
  String toString() => user.toString();
}

class UserFetchFailed extends UserState {
  final KakaoException exception;

  UserFetchFailed(this.exception) : super([exception]);

  @override
  String toString() => exception.toString();
}
