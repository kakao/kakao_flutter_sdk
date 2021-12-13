import 'package:equatable/equatable.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FriendsState extends Equatable {
  FriendsState([List props = const []]) : super(props);
}

class FriendsUninitialized extends FriendsState {}

class FriendsFetched extends FriendsState {
  final List<Friend> friends;
  FriendsFetched(this.friends) : super([friends]);
}

class FriendsPermissionRequired extends FriendsState {
  final List<String> scopes;

  FriendsPermissionRequired(this.scopes) : super([scopes]);
}

class FriendsFetchFailed extends FriendsState {
  final Exception exception;
  FriendsFetchFailed(this.exception) : super([exception]);
  @override
  String toString() => "FriendsFetchFailed: $exception";
}
