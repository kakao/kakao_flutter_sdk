import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FriendsEvent extends Equatable {
  FriendsEvent([List props = const []]) : super(props);
}

class FetchFriends extends FriendsEvent {
  @override
  String toString() => runtimeType.toString();
}

class RequestAgreement extends FriendsEvent {
  final List<String> scopes;
  RequestAgreement(this.scopes) : super([scopes]);

  @override
  String toString() => "$runtimeType with $scopes";
}
