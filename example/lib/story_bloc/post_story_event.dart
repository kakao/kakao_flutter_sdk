import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:kakao_flutter_sdk/story.dart';

@immutable
abstract class PostStoryEvent extends Equatable {
  PostStoryEvent([List props = const []]) : super(props);
}

class SetContent extends PostStoryEvent {
  final String content;
  SetContent(this.content) : super([content]);

  @override
  String toString() => "$runtimeType: $content";
}

class SetImages extends PostStoryEvent {
  final Future<File> image;
  final bool selected;
  SetImages(this.image, this.selected) : super([image, selected]);

  @override
  String toString() => "$runtimeType: $image";
}

class SetEnableShare extends PostStoryEvent {
  final bool enableShare;
  SetEnableShare(this.enableShare) : super([enableShare]);

  @override
  String toString() => "$runtimeType: $enableShare";
}

class SetStoryPermission extends PostStoryEvent {
  final StoryPermission permission;
  SetStoryPermission(this.permission) : super([permission]);

  @override
  String toString() => "$runtimeType: $permission";
}

class SetAndroidExecParams extends PostStoryEvent {
  final String androidExecParams;
  SetAndroidExecParams(this.androidExecParams) : super([androidExecParams]);
}

class SetIosExecParams extends PostStoryEvent {
  final String iosExecParams;
  SetIosExecParams(this.iosExecParams) : super([iosExecParams]);
}

class PostStory extends PostStoryEvent {}
