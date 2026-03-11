import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_common.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  static const TextStyle _logStyle = TextStyle(
    color: Colors.green,
    fontFamily: 'monospace',
    fontSize: 12,
    height: 1.25,
  );

  @override
  Widget build(BuildContext context) {
    final logLines = _splitLogs(SdkLog.logs);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Debug Page"),
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        actions: [
          TextButton(
            child: Text('CLEAR'),
            onPressed: () {
              setState(() {
                SdkLog.clear();
              });
            },
          ),
        ],
      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectionArea(
            child: ListView.builder(
              itemCount: logLines.length,
              itemBuilder: (context, index) {
                return Text(logLines[index], style: _logStyle);
              },
            ),
          ),
        ),
      ),
    );
  }

  List<String> _splitLogs(String logs) {
    if (logs.isEmpty) {
      return const <String>['(no logs)'];
    }
    return logs.split('\n');
  }
}
