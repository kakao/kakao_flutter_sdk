import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';

import 'bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserApi _userApi;

  UserBloc({UserApi userApi})
      : _userApi = userApi ?? UserApi.instance,
        super(UserUninitialized());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is AppStarted) {
      yield UserUninitialized();
      return;
    }
    if (event is UserFetchStarted) {
      try {
        final user = await _userApi.me();
        yield UserFetched(user);
      } on KakaoApiException catch (e) {
        if (e.code == ApiErrorCause.INVALID_TOKEN) {
          yield UserLoggedOut();
        } else {
          yield UserFetchFailed(e);
        }
      } catch (e) {
        yield UserFetchFailed(e);
      }
      return;
    }
    if (event is UserLogOut) {
      await _userApi.logout();
      await TokenManagerProvider.instance.manager.clear();
      yield UserLoggedOut();
      return;
    }
    if (event is UserUnlink) {
      await _userApi.unlink();
      await TokenManagerProvider.instance.manager.clear();
      yield UserLoggedOut();
      return;
    }
  }
}
