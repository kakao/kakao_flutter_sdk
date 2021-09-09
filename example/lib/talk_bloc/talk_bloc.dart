import 'package:bloc/bloc.dart';
import 'bloc.dart';
import 'package:kakao_flutter_sdk_example/talk_bloc/talk_event.dart';
import 'package:kakao_flutter_sdk/talk.dart';

class TalkBloc extends Bloc<TalkEvent, TalkState> {
  final TalkApi _talkApi;
  TalkBloc({TalkApi talkApi})
      : _talkApi = talkApi ?? TalkApi.instance,
        super(TalkprofileUninitialized());

  @override
  Stream<TalkState> mapEventToState(
    TalkEvent event,
  ) async* {
    if (event is FetchTalkProfile) {
      try {
        final profile = await _talkApi.profile();
        yield TalkProfileFetched(profile);
      } catch (e) {
        yield TalkProfileFetchFailed(e);
      }
    }
  }
}
