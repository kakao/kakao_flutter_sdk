import 'package:flutter/material.dart';

@immutable
class KakaoSchemePage extends StatelessWidget {
  final Map<String, dynamic>? queryParams;

  const KakaoSchemePage({Key? key, required this.queryParams})
      : super(key: key);

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
