import 'package:kakao_flutter_sdk_story/src/model/story.dart';
import 'package:kakao_flutter_sdk_story/src/model/story_like.dart';

// This is a copy of the enumMap created by the json_serializable package. Needs to be modified when values are added
const $StoryTypeEnumMap = {
  StoryType.note: 'NOTE',
  StoryType.photo: 'PHOTO',
  StoryType.notSupported: 'NOT_SUPPORTED',
};

// This is a copy of the enumMap created by the json_serializable package. Needs to be modified when values are added
const $StoryPermissionEnumMap = {
  StoryPermission.public: 'PUBLIC',
  StoryPermission.friend: 'FRIEND',
  StoryPermission.onlyMe: 'ONLY_ME',
  StoryPermission.unknown: 'UNKNOWN',
};

// This is a copy of the enumMap created by the json_serializable package. Needs to be modified when values are added
const $EmotionEnumMap = {
  Emotion.like: 'LIKE',
  Emotion.cool: 'COOL',
  Emotion.happy: 'HAPPY',
  Emotion.sad: 'SAD',
  Emotion.cheerUp: 'CHEER_UP',
  Emotion.unknown: 'UNKNOWN',
};
