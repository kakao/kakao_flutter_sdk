import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:kakao_flutter_sdk/story.dart';

@immutable
abstract class StoryState extends Equatable {
  StoryState([List props = const []]) : super(props);
}

class StoriesUninitialized extends StoryState {}

class NotStoryUser extends StoryState {}

class StoriesFetched extends StoryState {
  final List<Story> stories;

  StoriesFetched(this.stories) : super([stories]);

  @override
  String toString() => stories.toString();
}

class StoriesFetchFailed extends StoryState {
  final Exception exception;
  StoriesFetchFailed(this.exception) : super([exception]);
}

class StoriesPermissionRequired extends StoryState {
  final List<String> scopes;

  StoriesPermissionRequired(this.scopes) : super([scopes]);
}
