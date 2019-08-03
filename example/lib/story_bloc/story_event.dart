import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class StoryEvent extends Equatable {
  StoryEvent([List props = const []]) : super(props);
}

class CheckStoryUser extends StoryEvent {
  @override
  String toString() => runtimeType.toString();
}

class FetchStories extends StoryEvent {
  @override
  String toString() => runtimeType.toString();
}
