import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/talk.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:kakao_flutter_sdk_example/talk_bloc/bloc.dart';
import 'package:kakao_flutter_sdk_example/talk_bloc/friends_event.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final TalkApi _api;
  final AuthCodeClient _authCodeClient;
  final AuthApi _authApi;

  FriendsBloc({TalkApi api, AuthCodeClient authCodeClient, AuthApi authApi})
      : _api = api ?? TalkApi.instance,
        _authCodeClient = authCodeClient ?? AuthCodeClient.instance,
        _authApi = authApi ?? AuthApi.instance,
        super(FriendsUninitialized());

  @override
  Stream<FriendsState> mapEventToState(
    FriendsEvent event,
  ) async* {
    if (event is FetchFriends) {
      try {
        final friends = await _api.friends();
        yield FriendsFetched(friends.elements);
      } on KakaoApiException catch (e) {
        if (e.code == ApiErrorCause.INVALID_SCOPE) {
          yield FriendsPermissionRequired(e.requiredScopes);
          return;
        }
        yield FriendsFetchFailed(e);
      } catch (e) {
        debugPrint(e);
        yield FriendsFetchFailed(e);
      }
      return;
    }
    if (event is RequestAgreement) {
      try {
        print(event.scopes);
        await UserApi.instance.loginWithNewScopes(event.scopes);
        this.add(FetchFriends());
      } catch (e) {
        yield FriendsPermissionRequired(event.scopes);
      }
    }
  }
}
