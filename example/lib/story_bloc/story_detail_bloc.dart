import 'package:bloc/bloc.dart';
import 'package:kakao_flutter_sdk_example/story_bloc/story_detail_event.dart';
import 'package:kakao_flutter_sdk_example/story_bloc/story_detail_state.dart';
import 'package:kakao_flutter_sdk/story.dart';

class StoryDetailBloc extends Bloc<StoryDetailEvent, StoryDetailState> {
  final StoryApi _storyApi;

  StoryDetailBloc({StoryApi storyApi})
      : _storyApi = storyApi ?? StoryApi.instance,
        super(StoryDetailUninitialized());

  @override
  Stream<StoryDetailState> mapEventToState(
    StoryDetailEvent event,
  ) async* {
    if (event is FetchStoryDetail) {
      final story = event.simpleStory;
      yield StoryDetailFetchStarted(story);

      try {
        final storyDetail = await _storyApi.myStory(story.id);
        yield StoryDetailFetched(storyDetail);
      } catch (e) {
        yield StoryDetailFetchFailed(e);
      }
      return;
    }
    if (event is DeleteStory) {
      try {
        await _storyApi.deleteStory(event.story.id);
        yield StoryDeleted();
      } catch (e) {
        yield StoryDeleteFailed(e);
      }
    }
  }
}
