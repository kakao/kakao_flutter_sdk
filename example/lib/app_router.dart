import 'package:example/model/custom_data.dart';
import 'package:example/model/friend_page_item.dart';
import 'package:example/pages/debug_page.dart';
import 'package:example/pages/friend_page.dart';
import 'package:example/pages/friend_picker_config_page.dart';
import 'package:example/pages/main_page.dart';
import 'package:example/pages/scheme_page.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter({required CustomData customData}) => GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          MainPage(title: 'Kakao Flutter Sdk', customData: customData),
    ),
    GoRoute(path: '/debug', builder: (context, state) => const DebugPage()),
    GoRoute(
      path: '/picker/config',
      builder: (context, state) => const PickerConfigPage(),
    ),
    GoRoute(
      path: '/friend',
      builder: (context, state) =>
          FriendPage(items: state.extra as List<FriendPageItem>),
    ),
    GoRoute(
      path: '/scheme',
      builder: (context, state) {
        final url = state.uri.queryParameters['url'];
        final schemeUri = url == null ? Uri() : (Uri.tryParse(url) ?? Uri());
        return SchemePage(schemeUri);
      },
    ),
  ],
);
