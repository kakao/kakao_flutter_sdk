import 'package:bloc/bloc.dart';
import 'package:kakao_flutter_sdk_example/talk_bloc/bloc.dart';
import 'package:kakao_flutter_sdk_example/talk_bloc/friends_event.dart';
import 'package:kakao_flutter_sdk/talk.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final TalkApi _api;
  final AuthCodeClient _authCodeClient;
  final AuthApi _authApi;

  FriendsBloc({TalkApi api, AuthCodeClient authCodeClient, AuthApi authApi})
      : _api = api ?? TalkApi.instance,
        _authCodeClient = authCodeClient ?? AuthCodeClient.instance,
        _authApi = authApi ?? AuthApi.instance;

  @override
  FriendsState get initialState => FriendsUninitialized();

  @override
  Stream<FriendsState> mapEventToState(
    FriendsEvent event,
  ) async* {
    if (event is FetchFriends) {
      try {
        final friends = await _api.friends();
        yield FriendsFetched(friends.friends);
      } on KakaoApiException catch (e) {
        if (e.code == ApiErrorCause.INVALID_SCOPE) {
          yield FriendsPermissionRequired(e.requiredScopes);
          return;
        }
        yield FriendsFetchFailed(e);
      } catch (e) {
        yield FriendsFetchFailed(e);
      }
      return;
    }
    if (event is RequestAgreement) {
      try {
        final code = await _authCodeClient.request(scopes: event.scopes);
        final token = await _authApi.issueAccessToken(code);
        await AccessTokenRepo.instance.toCache(token);
        dispatch(FetchFriends());
      } catch (e) {
        yield FriendsPermissionRequired(event.scopes);
      }
    }
  }
}
