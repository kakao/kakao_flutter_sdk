import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:kakao_flutter_sdk/talk.dart';

@immutable
abstract class TalkState extends Equatable {
  TalkState([List props = const []]) : super(props);
}

class TalkprofileUninitialized extends TalkState {}

class TalkProfileFetched extends TalkState {
  final TalkProfile profile;
  TalkProfileFetched(this.profile) : super([profile]);
}

class TalkProfileFetchFailed extends TalkState {
  final Exception exception;
  TalkProfileFetchFailed(this.exception) : super([exception]);
}
