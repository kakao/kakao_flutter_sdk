import 'package:bloc/bloc.dart';
import 'bloc.dart';
import 'package:kakao_flutter_sdk/story.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryApi _storyApi;

  StoryBloc({StoryApi storyApi})
      : _storyApi = storyApi ?? StoryApi.instance,
        super(StoriesUninitialized());

  @override
  Stream<StoryState> mapEventToState(
    StoryEvent event,
  ) async* {
    if (event is FetchStories) {
      try {
        final isUser = await _storyApi.isStoryUser();
        if (!isUser) {
          yield NotStoryUser();
          return;
        }
        final stories = await _storyApi.myStories();
        yield StoriesFetched(stories);
      } catch (e) {
        yield StoriesFetchFailed(e);
      }
    }
  }
}
