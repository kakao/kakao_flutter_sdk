import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:kakao_flutter_sdk/story.dart';

@immutable
abstract class StoryDetailEvent extends Equatable {
  StoryDetailEvent([List props = const []]) : super(props);
}

class FetchStoryDetail extends StoryDetailEvent {
  final Story simpleStory;
  FetchStoryDetail(this.simpleStory) : super([simpleStory]);

  @override
  String toString() => "$runtimeType with story: $simpleStory";
}

class DeleteStory extends StoryDetailEvent {
  final Story story;
  DeleteStory(this.story) : super([story]);
}
