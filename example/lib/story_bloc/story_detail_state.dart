import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:kakao_flutter_sdk/story.dart';

@immutable
abstract class StoryDetailState extends Equatable {
  StoryDetailState([List props = const []]) : super(props);
}

class StoryDetailUninitialized extends StoryDetailState {}

class StoryDetailFetchStarted extends StoryDetailState {
  final Story simpleStory;
  StoryDetailFetchStarted(this.simpleStory) : super([simpleStory]);
}

class StoryDetailFetched extends StoryDetailState {
  final Story storyDetail;
  StoryDetailFetched(this.storyDetail) : super([storyDetail]);
}

class StoryDetailFetchFailed extends StoryDetailState {
  final Exception exception;
  StoryDetailFetchFailed(this.exception) : super([exception]);
}

class StoryDeleted extends StoryDetailState {}

class StoryDeleteFailed extends StoryDetailState {
  final Exception exception;
  StoryDeleteFailed(this.exception) : super([exception]);
}
