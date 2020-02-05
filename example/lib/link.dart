import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/link.dart';

class LinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(title: Text("Custom"), onTap: onTapCustom),
        ListTile(title: Text("Default"), onTap: onTapDefault),
        ListTile(title: Text("Scrap"), onTap: onTapScrap)
      ],
    );
  }

  void onTapDefault() async {
    try {
      var template = FeedTemplate(
          Content(
              "딸기 치즈 케익",
              Uri.parse(
                  "http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png"),
              Link(
                  webUrl: Uri.parse("https://developers.kakao.com"),
                  mobileWebUrl: Uri.parse("https://developers.kakao.com"))),
          social: Social(likeCount: 286, commentCount: 45, sharedCount: 845),
          buttons: [
            Button("웹으로 보기",
                Link(webUrl: Uri.parse("https://developers.kakao.com"))),
            Button("앱으로 보기",
                Link(webUrl: Uri.parse("https://developers.kakao.com"))),
          ]);
      var uri = await LinkClient.instance.defaultWithWeb(template);
      await launchBrowserTab(uri);
    } catch (e) {
      print(e.toString());
    }
  }

  void onTapCustom() async {
    try {
      final talkInstalled = await isKakaoTalkInstalled();
      if (talkInstalled) {
        var uri = await LinkClient.instance
            .customWithTalk(16761, templateArgs: {"key1": "value1"});
        await LinkClient.instance.launchKakaoTalk(uri);
        return;
      }
      var uri = await LinkClient.instance
          .customWithWeb(16761, templateArgs: {"key1": "value1"});
      await launchBrowserTab(uri);
    } catch (e) {
      print(e.toString());
    }
  }

  void onTapScrap() async {
    try {
      final talkInstalled = await isKakaoTalkInstalled();
      if (talkInstalled) {
        var uri = await LinkClient.instance
            .scrapWithTalk("https://developers.kakao.com");
        await LinkClient.instance.launchKakaoTalk(uri);
        return;
      }
      var uri = await LinkClient.instance
          .scrapWithWeb("https://developers.kakao.com");
      await launchBrowserTab(uri);
    } catch (e) {
      print(e.toString());
    }
  }
}
