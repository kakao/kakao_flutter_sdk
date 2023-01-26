import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_example/ui/api_list.dart';

class MainPage extends StatelessWidget {
  Map<String, dynamic> customData;

  MainPage({Key? key, required this.customData}) : super(key: key);

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
          .showSnackBar(const SnackBar(content: Text('에러가 발생했습니다')));
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
      body: ApiList(customData: customData),
    );
  }
}
