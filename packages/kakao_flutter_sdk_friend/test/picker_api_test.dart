import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_friend/src/friend_platform.dart';
import 'package:kakao_flutter_sdk_friend/src/model/picker_friend_request_params.dart';
import 'package:kakao_flutter_sdk_friend/src/model/selected_user.dart';
import 'package:kakao_flutter_sdk_friend/src/platform/friend_platform_stub.dart'
    as friend_stub;
import 'package:kakao_flutter_sdk_friend/src/picker_api.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../../kakao_flutter_sdk_common/test/shared/utils/shared_preferences.dart';
import '../../kakao_flutter_sdk_common/test/shared/doubles/fake_common_platform.dart';

class FakeTokenManager implements TokenManager {
  OAuthToken? token;

  @override
  Future<void> clear() async {
    token = null;
  }

  @override
  Future<OAuthToken?> getToken() async {
    return token;
  }

  @override
  Future<void> setToken(OAuthToken token) async {
    this.token = token;
  }
}

class FakeFriendPlatform extends FriendPlatform {
  SelectedUsers response = SelectedUsers(totalCount: 1, users: []);
  KakaoClientException? error;

  PickerFriendRequestParams? lastParams;
  bool? lastEnableMulti;

  @override
  Future<SelectedUsers> selectFriend(
    BuildContext context,
    PickerFriendRequestParams params,
    bool enableMulti,
  ) async {
    lastParams = params;
    lastEnableMulti = enableMulti;
    if (error != null) throw error!;
    return response;
  }
}

Future<BuildContext> _pumpContext(WidgetTester tester) async {
  late BuildContext context;

  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Builder(
        builder: (buildContext) {
          context = buildContext;
          return const SizedBox.shrink();
        },
      ),
    ),
  );

  return context;
}

Matcher _isClientError(ClientErrorCause cause) {
  return isA<KakaoClientException>().having((e) => e.reason, 'reason', cause);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TokenManager originalManager;
  late FakeTokenManager tokenManager;
  late FakeFriendPlatform platform;
  late PickerApi pickerApi;

  final token = OAuthToken(
    'access-token',
    DateTime.now().add(const Duration(hours: 1)),
    'refresh-token',
    DateTime.now().add(const Duration(days: 30)),
    const ['talk_message'],
  );

  setUp(() async {
    await KakaoSdk.init(
      nativeAppKey: '',
      platformProvider: FakeCommonPlatform(),
    );

    await initializeSharedPreferences();

    originalManager = TokenManagerProvider.instance.manager;
    tokenManager = FakeTokenManager();
    TokenManagerProvider.instance.manager = tokenManager;
    platform = FakeFriendPlatform();
    pickerApi = PickerApi(platform: platform);
  });

  tearDown(() {
    TokenManagerProvider.instance.manager = originalManager;
  });

  testWidgets('throws tokenNotFound when token is missing', (tester) async {
    final context = await _pumpContext(tester);

    await expectLater(
      pickerApi.selectFriend(
        context: context,
        params: PickerFriendRequestParams(),
      ),
      throwsA(_isClientError(ClientErrorCause.tokenNotFound)),
    );
  });

  testWidgets('forces min/max pickable count to 1 when enableMulti is false', (
    tester,
  ) async {
    tokenManager.token = token;
    final context = await _pumpContext(tester);

    final result = await pickerApi.selectFriend(
      context: context,
      params: PickerFriendRequestParams(
        minPickableCount: 3,
        maxPickableCount: 8,
      ),
      enableMulti: false,
    );

    expect(platform.lastEnableMulti, isFalse);
    expect(platform.lastParams?.minPickableCount, 1);
    expect(platform.lastParams?.maxPickableCount, 1);
    expect(result.totalCount, 1);
  });

  testWidgets('throws badParameter when minPickableCount is less than 1', (
    tester,
  ) async {
    tokenManager.token = token;
    final context = await _pumpContext(tester);

    await expectLater(
      pickerApi.selectFriend(
        context: context,
        params: PickerFriendRequestParams(
          minPickableCount: 0,
          maxPickableCount: 5,
        ),
      ),
      throwsA(_isClientError(ClientErrorCause.badParameter)),
    );
  });

  testWidgets('throws badParameter when maxPickableCount is greater than 100', (
    tester,
  ) async {
    tokenManager.token = token;
    final context = await _pumpContext(tester);

    await expectLater(
      pickerApi.selectFriend(
        context: context,
        params: PickerFriendRequestParams(
          minPickableCount: 1,
          maxPickableCount: 101,
        ),
      ),
      throwsA(_isClientError(ClientErrorCause.badParameter)),
    );
  });

  testWidgets(
    'throws badParameter when minPickableCount is greater than maxPickableCount',
    (tester) async {
      tokenManager.token = token;
      final context = await _pumpContext(tester);

      await expectLater(
        pickerApi.selectFriend(
          context: context,
          params: PickerFriendRequestParams(
            minPickableCount: 5,
            maxPickableCount: 3,
          ),
        ),
        throwsA(_isClientError(ClientErrorCause.badParameter)),
      );
    },
  );

  testWidgets('throws illegalState when context is unmounted', (tester) async {
    tokenManager.token = token;
    final context = await _pumpContext(tester);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();

    expect(context.mounted, isFalse);

    await expectLater(
      pickerApi.selectFriend(
        context: context,
        params: PickerFriendRequestParams(),
      ),
      throwsA(_isClientError(ClientErrorCause.illegalState)),
    );
  });

  testWidgets('propagates cancelled error from platform', (tester) async {
    tokenManager.token = token;
    platform.error = KakaoClientException(
      ClientErrorCause.cancelled,
      'User Cancelled',
    );
    final context = await _pumpContext(tester);

    await expectLater(
      pickerApi.selectFriend(
        context: context,
        params: PickerFriendRequestParams(),
      ),
      throwsA(_isClientError(ClientErrorCause.cancelled)),
    );
  });

  testWidgets('friend stub throws consistent notSupported error', (
    tester,
  ) async {
    final context = await _pumpContext(tester);
    final platform = friend_stub.FriendPlatformImpl();

    await expectLater(
      platform.selectFriend(context, PickerFriendRequestParams(), true),
      throwsA(
        isA<KakaoClientException>()
            .having((e) => e.reason, 'reason', ClientErrorCause.notSupported)
            .having(
              (e) => e.msg,
              'msg',
              'This SDK operation is not supported on this platform.',
            ),
      ),
    );
  });
}
