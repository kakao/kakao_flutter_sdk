import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_example/ui/api_list.dart';

class MainPage extends StatelessWidget {
  final Map<String, dynamic> customData;

  const MainPage({super.key, required this.customData});

  @override
  Widget build(BuildContext context) {
    receiveKakaoScheme().then((url) {
      if (url == null) return;

      Navigator.of(context)
          .pushNamed('/talkSharing', arguments: Uri.parse(url).queryParameters);
    });

    kakaoSchemeStream.listen((link) {
      if (link != null) {
        Navigator.of(context).pushNamed('/talkSharing',
            arguments: Uri.parse(link).queryParameters);
      }
    }, onError: (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('에러가 발생했습니다')));
    });

    final theme= Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('SDK Sample'),
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: theme.scaffoldBackgroundColor,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text('DEBUG'),
              ),
            ),
            onTap: () => Navigator.of(context).pushNamed('/debug'),
          ),
        ],
      ),
      body: ApiList(customData: customData),
    );
  }
}
