import 'package:flutter/material.dart';

class KakaoSchemePage extends StatelessWidget {
  Map<String, dynamic> queryParams;

  KakaoSchemePage({Key? key, required this.queryParams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String params = '';
    queryParams.forEach((key, value) {
      params += '$key : $value\n';
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Kakao Scheme Page')),
      body: Center(
        child: queryParams.isNotEmpty
            ? Text(params)
            : const Text('No Query Parameters'),
      ),
    );
  }
}
