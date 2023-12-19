import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Kakao Scheme Page')),
      body: Center(
        child: params.isNotEmpty
            ? Text(params)
            : const Text('No Query Parameters'),
      ),
    );
  }
}
