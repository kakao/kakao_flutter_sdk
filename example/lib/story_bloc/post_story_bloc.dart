import 'dart:io';

import 'package:bloc/bloc.dart';
import 'bloc.dart';
import 'package:kakao_flutter_sdk/story.dart';

class PostStoryBloc extends Bloc<PostStoryEvent, PostStoryState> {
  final StoryApi _storyApi;
  PostStoryBloc({StoryApi storyApi})
      : _storyApi = storyApi ?? StoryApi.instance;

  @override
  PostStoryState get initialState => PostStoryState.init();

  @override
  Stream<PostStoryState> mapEventToState(
    PostStoryEvent event,
  ) async* {
    if (event is SetImages) {
      List<File> newImages = List<File>.from(currentState.images);
      if (event.selected) {
        newImages.add(await event.image);
      } else {
        newImages.remove(event.image);
      }
      yield currentState.assign(images: newImages);
      return;
    }
    if (event is SetEnableShare) {
      yield currentState.assign(enableShare: event.enableShare);
      return;
    }
    if (event is SetStoryPermission) {
      yield currentState.assign(permission: event.permission);
      return;
    }
    if (event is PostStory) {
      try {
        if (currentState.images.isNotEmpty) {
          final images = await _storyApi.scrapImages(currentState.images);
          await _storyApi.postPhotos(images,
              content: currentState.content,
              permission: currentState.permission,
              enableShare: currentState.enableShare,
              androidExecParams: currentState.androidExecParams,
              iosExecParams: currentState.iosExecParams);
        } else {
          await _storyApi.postNote(currentState.content,
              permission: currentState.permission,
              enableShare: currentState.enableShare,
              androidExecParams: currentState.androidExecParams,
              iosExecParams: currentState.iosExecParams);
        }
        yield PostStoryState.init().assign(posted: true);
      } on KakaoApiException catch (e) {
        if (e.code == ApiErrorCause.INVALID_SCOPE) {}
        yield currentState.assign(exception: e);
      } catch (e) {
        yield currentState.assign(exception: e);
      }
    }
  }
}
