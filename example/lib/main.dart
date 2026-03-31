import 'package:example/app_router.dart';
import 'package:example/model/custom_data.dart';
import 'package:example/theme_mode_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_share.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    usePathUrlStrategy();
  }

  final pendingSchemeUri = ValueNotifier<Uri?>(null);

  receiveKakaoScheme((uri) {
    pendingSchemeUri.value = uri;
  });

  final customData = CustomData(
    templateId: 67020,
    channelId: '_ZeUTxl',
    calendarEventId: '63996425afcec577cce94f0b',
    scopes: ['name', 'gender'],
    serviceTerms: ['option'],
  );

  await KakaoSdk.init(
    nativeAppKey: '030ba7c59137629e86e8721eb1a22fd6',
    javaScriptAppKey: 'fa2d8e9f47b88445000592c9a293bbe2',
    loggingEnabled: true,
  );

  runApp(
    ProviderScope(
      child: MyApp(customData: customData, pendingSchemeUri: pendingSchemeUri),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({
    super.key,
    required this.customData,
    required this.pendingSchemeUri,
  });

  final CustomData customData;
  final ValueNotifier<Uri?> pendingSchemeUri;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  late final appRouter = createAppRouter(customData: widget.customData);
  bool _navigationScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.pendingSchemeUri.addListener(_handlePendingScheme);
    WidgetsBinding.instance.addPostFrameCallback((_) => _handlePendingScheme());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handlePendingScheme();
    }
  }

  void _handlePendingScheme() {
    final uri = widget.pendingSchemeUri.value;
    if (uri == null) {
      return;
    }

    if (_navigationScheduled) {
      return;
    }
    _navigationScheduled = true;

    // iOS 웜 스타트에서는 새 프레임이 실행되지 않을 수 있어서 강제로 스케쥴링.
    WidgetsBinding.instance.scheduleFrame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigationScheduled = false;
      if (!mounted) {
        return;
      }

      final pendingUri = widget.pendingSchemeUri.value;
      if (pendingUri == null) {
        return;
      }

      final encodedUrl = Uri.encodeComponent(pendingUri.toString());
      appRouter.push('/scheme?url=$encodedUrl');
      widget.pendingSchemeUri.value = null;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.pendingSchemeUri.removeListener(_handlePendingScheme);
    widget.pendingSchemeUri.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Kakao Flutter Sdk Example',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.amber,
      brightness: brightness,
    );

    return ThemeData(
      colorScheme: colorScheme,
      brightness: brightness,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
      ),
    );
  }
}
