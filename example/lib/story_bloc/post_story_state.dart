import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:kakao_flutter_sdk/story.dart';

@immutable
class PostStoryState extends Equatable {
  PostStoryState(
      {this.content,
      this.images,
      this.permission,
      this.enableShare,
      this.androidExecParams,
      this.iosExecParams,
      this.posted,
      this.exception})
      : super([
          content,
          images,
          permission,
          enableShare,
          androidExecParams,
          iosExecParams,
          posted,
          exception
        ]);

  final String content;
  final List<File> images;
  final StoryPermission permission;
  final bool enableShare;
  final String androidExecParams;
  final String iosExecParams;

  final bool posted;
  final Exception exception;

  factory PostStoryState.init() => PostStoryState(
      content: "",
      images: List(),
      permission: StoryPermission.PUBLIC,
      enableShare: true,
      androidExecParams: "",
      iosExecParams: "",
      posted: false);

  PostStoryState assign(
          {String content,
          List<File> images,
          StoryPermission permission,
          bool enableShare,
          String androidExecParams,
          String iosExecParams,
          bool posted,
          Exception exception}) =>
      PostStoryState(
          content: content ?? this.content,
          images: images ?? this.images,
          permission: permission ?? this.permission,
          enableShare: enableShare ?? this.enableShare,
          androidExecParams: androidExecParams ?? this.androidExecParams,
          iosExecParams: iosExecParams ?? this.iosExecParams,
          exception: exception ?? this.exception);
}
