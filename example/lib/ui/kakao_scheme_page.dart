import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@immutable
class KakaoSchemePage extends StatelessWidget {
  final Map<String, dynamic>? queryParams;

  const KakaoSchemePage({super.key, required this.queryParams});

  @override
  Widget build(BuildContext context) {
    String params = '';
    queryParams?.forEach((key, value) {
      params += '$key : $value\n';
    });

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Kakao Scheme Page'),
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: theme.scaffoldBackgroundColor,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: params.isNotEmpty
              ? Text(params)
              : const Text('No Query Parameters'),
        ),
      ),
    );
  }
}
