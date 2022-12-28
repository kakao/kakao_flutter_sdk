import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_example/ui/api_list.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  Future _navigateInitialLink(BuildContext context) async {
    var url = await receiveKakaoScheme();

    if (url != null) {
      Navigator.of(context)
          .pushNamed('/talkSharing', arguments: Uri.parse(url).queryParameters);
    }
  }

  @override
  Widget build(BuildContext context) {
    _navigateInitialLink(context);

    kakaoSchemeStream.listen((link) {
      if (link != null) {
        Navigator.of(context).pushNamed('/talkSharing',
            arguments: Uri.parse(link).queryParameters);
      }
    }, onError: (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('카카오톡 공유하기 페이지 이동 실패')));
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('SDK Sample'),
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
      body: const ApiList(),
    );
  }
}
