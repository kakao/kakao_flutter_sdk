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

      List<File> newImages = List<File>.from(state.images);
      if (event.selected) {
        newImages.add(await event.image);
      } else {
        newImages.remove(event.image);
      }
      yield state.assign(images: newImages);
      return;
    }
    if (event is SetEnableShare) {
      yield state.assign(enableShare: event.enableShare);
      return;
    }
    if (event is SetStoryPermission) {
      yield state.assign(permission: event.permission);
      return;
    }
    if (event is PostStory) {
      try {
        if (state.images.isNotEmpty) {
          final images = await _storyApi.scrapImages(state.images);
          await _storyApi.postPhotos(images,
              content: state.content,
              permission: state.permission,
              enableShare: state.enableShare,
              androidExecParams: state.androidExecParams,
              iosExecParams: state.iosExecParams);
        } else {
          await _storyApi.postNote(state.content,
              permission: state.permission,
              enableShare: state.enableShare,
              androidExecParams: state.androidExecParams,
              iosExecParams: state.iosExecParams);
        }
        yield PostStoryState.init().assign(posted: true);
      } on KakaoApiException catch (e) {
        if (e.code == ApiErrorCause.INVALID_SCOPE) {}
        yield state.assign(exception: e);
      } catch (e) {
        yield state.assign(exception: e);
      }
    }
  }
}
