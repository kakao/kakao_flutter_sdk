import 'package:flutter/material.dart';

class SchemePage extends StatelessWidget {
  const SchemePage(this.url, {super.key});

  final Uri url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scheme Page')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text('Opened with URL: $url')),
        ),
      ),
    );
  }
}
