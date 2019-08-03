import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TalkEvent extends Equatable {
  TalkEvent([List props = const []]) : super(props);
}

class FetchTalkProfile extends TalkEvent {
  @override
  String toString() => runtimeType.toString();
}
