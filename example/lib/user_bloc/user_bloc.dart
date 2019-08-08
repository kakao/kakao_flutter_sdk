import 'dart:async';
import 'package:bloc/bloc.dart';
import 'bloc.dart';
import 'package:kakao_flutter_sdk/user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserApi _userApi;

  UserBloc({UserApi userApi}) : _userApi = userApi ?? UserApi.instance;

  @override
  UserState get initialState => UserUninitialized();

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
      } on KakaoException catch (e) {
        yield UserFetchFailed(e);
      }
      return;
    }
    if (event is UserLoggedOut) {
      yield UserUninitialized();
      return;
    }
  }
}
