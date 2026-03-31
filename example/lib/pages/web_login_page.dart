import 'package:example/third_server_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_auth.dart';

class WebLoginPage extends StatefulWidget {
  const WebLoginPage({super.key});

  @override
  State<WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<WebLoginPage> {
  @override
  void initState() {
    super.initState();
    _completeWebLogin();
  }

  Future<void> _completeWebLogin() async {
    try {
      final token = await ThirdServerApi('http://172.20.29.239:3000').getToken();
      await TokenManagerProvider.instance.manager.setToken(token);

      if (!mounted) {
        return;
      }

      context.go('/');
    } catch (error, stackTrace) {
      debugPrint('Web login bridge failed: $error\n$stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(),
    );
  }
}
