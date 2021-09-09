import 'dart:io';

import 'package:bloc/bloc.dart';
import 'bloc.dart';
import 'package:kakao_flutter_sdk/story.dart';

class PostStoryBloc extends Bloc<PostStoryEvent, PostStoryState> {
  final StoryApi _storyApi;
  PostStoryBloc({StoryApi storyApi})
      : _storyApi = storyApi ?? StoryApi.instance,
        super(PostStoryState.init());

  @override
  PostStoryState get initialState => PostStoryState.init();

  @override
  Stream<PostStoryState> mapEventToState(
    PostStoryEvent event,
  ) async* {
    if (event is SetImages) {
      List<File> newImages = List<File>.from(this.state.images);
      if (event.selected) {
        newImages.add(await event.image);
      } else {
        newImages.remove(event.image);
      }
      yield this.state.assign(images: newImages);
      return;
    }
    if (event is SetEnableShare) {
      yield this.state.assign(enableShare: event.enableShare);
      return;
    }
    if (event is SetStoryPermission) {
      yield this.state.assign(permission: event.permission);
      return;
    }
    if (event is PostStory) {
      try {
        if (this.state.images.isNotEmpty) {
          final images = await _storyApi.scrapImages(this.state.images);
          await _storyApi.postPhotos(images,
              content: this.state.content,
              permission: this.state.permission,
              enableShare: this.state.enableShare,
              androidExecParams: this.state.androidExecParams,
              iosExecParams: this.state.iosExecParams);
        } else {
          await _storyApi.postNote(this.state.content,
              permission: this.state.permission,
              enableShare: this.state.enableShare,
              androidExecParams: this.state.androidExecParams,
              iosExecParams: this.state.iosExecParams);
        }
        yield PostStoryState.init().assign(posted: true);
      } on KakaoApiException catch (e) {
        if (e.code == ApiErrorCause.INSUFFICIENT_SCOPE) {}
        yield this.state.assign(exception: e);
      } catch (e) {
        yield this.state.assign(exception: e);
      }
    }
  }
}
