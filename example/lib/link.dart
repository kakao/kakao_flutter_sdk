import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/link.dart';

class LinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(title: Text("DefaultFeed"), onTap: onTapDefaultFeed),
        ListTile(title: Text("DefaultList"), onTap: onTapDefaultList),
        ListTile(title: Text("DefaultLocation"), onTap: onTapDefaultLocation),
        ListTile(title: Text("DefaultCommerce"), onTap: onTapDefaultCommerce),
        ListTile(title: Text("DefaultText"), onTap: onTapDefaultText),
        ListTile(title: Text("Scrap"), onTap: onTapScrap),
        ListTile(title: Text("Custom"), onTap: onTapCustom)
      ],
    );
  }

  void onTapDefaultFeed() async {
    try {
      var template = defaultFeed;
      final isTalkInstalled = await isKakaoTalkInstalled();
      if (isTalkInstalled) {
        var uri = await LinkClient.instance.defaultWithTalk(template);
        await LinkClient.instance.launchKakaoTalk(uri);
      } else {
        var uri = await LinkClient.instance.defaultWithWeb(template);
        await launchBrowserTab(uri);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void onTapDefaultList() async {
    try {
      var template = defaultList;
      final isTalkInstalled = await isKakaoTalkInstalled();
      if (isTalkInstalled) {
        var uri = await LinkClient.instance.defaultWithTalk(template);
        await LinkClient.instance.launchKakaoTalk(uri);
      } else {
        var uri = await LinkClient.instance.defaultWithWeb(template);
        await launchBrowserTab(uri);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void onTapDefaultLocation() async {
    try {
      var template = defaultLocation;
      final isTalkInstalled = await isKakaoTalkInstalled();
      if (isTalkInstalled) {
        var uri = await LinkClient.instance.defaultWithTalk(template);
        await LinkClient.instance.launchKakaoTalk(uri);
      } else {
        var uri = await LinkClient.instance.defaultWithWeb(template);
        await launchBrowserTab(uri);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void onTapDefaultCommerce() async {
    try {
      final template = defaultCommerce;
      final isTalkInstalled = await isKakaoTalkInstalled();
      if (isTalkInstalled) {
        var uri = await LinkClient.instance.defaultWithTalk(template);
        await LinkClient.instance.launchKakaoTalk(uri);
      } else {
        var uri = await LinkClient.instance.defaultWithWeb(template);
        await launchBrowserTab(uri);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void onTapDefaultText() async {
    try {
      var template = defaultText;
      final isTalkInstalled = await isKakaoTalkInstalled();
      if (isTalkInstalled) {
        var uri = await LinkClient.instance.defaultWithTalk(template);
        await LinkClient.instance.launchKakaoTalk(uri);
      } else {
        var uri = await LinkClient.instance.defaultWithWeb(template);
        await launchBrowserTab(uri);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void onTapCustom() async {
    try {
      final isTalkInstalled = await isKakaoTalkInstalled();
      if (isTalkInstalled) {
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
      final isTalkInstalled = await isKakaoTalkInstalled();
      if (isTalkInstalled) {
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

  final defaultFeed = FeedTemplate(
      Content(
          "딸기 치즈 케익",
          Uri.parse(
              "http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png"),
          Link(
              webUrl: Uri.parse("https://developers.kakao.com"),
              mobileWebUrl: Uri.parse("https://developers.kakao.com"))),
      itemContent: ItemContent(
          profileText: 'Kakao',
          profileImageUrl:
              'http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png',
          titleImageUrl:
              'http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png',
          titleImageText: 'Cheese cake',
          titleImageCategory: 'cake',
          items: [
            ItemInfo(item: 'cake1', itemOp: '1000원'),
            ItemInfo(item: 'cake2', itemOp: '2000원'),
            ItemInfo(item: 'cake3', itemOp: '3000원'),
            ItemInfo(item: 'cake4', itemOp: '4000원'),
            ItemInfo(item: 'cake5', itemOp: '5000원'),
          ],
          sum: 'total',
          sumOp: '15000원'),
      social: Social(likeCount: 286, commentCount: 45, sharedCount: 845),
      buttons: [
        Button(
            "웹으로 보기", Link(webUrl: Uri.parse("https://developers.kakao.com"))),
        Button(
            "앱으로 보기", Link(webUrl: Uri.parse("https://developers.kakao.com"))),
      ]);

  final defaultList = ListTemplate(
      'WEEKLY MAGAZINE',
      Link(
          webUrl: Uri.parse('https:developers.kakao.com'),
          mobileWebUrl: Uri.parse('https:developers.kakao.com')),
      [
        Content(
            "취미의 특징, 탁구",
            Uri.parse(
                "http://mud-kage.kakao.co.kr/dn/bDPMIb/btqgeoTRQvd/49BuF1gNo6UXkdbKecx600/kakaolink40_original.png"),
            Link(
                webUrl: Uri.parse("https://developers.kakao.com"),
                mobileWebUrl: Uri.parse("https://developers.kakao.com")),
            description: "스포츠"),
        Content(
            "크림으로 이해하는 커피이야기",
            Uri.parse(
                "http://mud-kage.kakao.co.kr/dn/QPeNt/btqgeSfSsCR/0QJIRuWTtkg4cYc57n8H80/kakaolink40_original.png"),
            Link(
                webUrl: Uri.parse('https:developers.kakao.com'),
                mobileWebUrl: Uri.parse('https:developers.kakao.com')),
            description: "음식"),
        Content(
            "감성이 가득한 분위기",
            Uri.parse(
                "http://mud-kage.kakao.co.kr/dn/c7MBX4/btqgeRgWhBy/ZMLnndJFAqyUAnqu4sQHS0/kakaolink40_original.png"),
            Link(
                webUrl: Uri.parse("https://developers.kakao.com"),
                mobileWebUrl: Uri.parse("https://developers.kakao.com")),
            description: "사진")
      ],
      buttons: [
        Button(
          '웹으로 보기',
          Link(
              webUrl: Uri.parse('https:developers.kakao.com'),
              mobileWebUrl: Uri.parse('https:developers.kakao.com')),
        ),
        Button(
          '앱으로 보기',
          Link(
              androidExecParams: 'key1=value1&key2=value2',
              iosExecParams: 'key1=value1&key2=value2'),
        )
      ]);

  final defaultLocation = LocationTemplate(
      "경기 성남시 분당구 판교역로 235 에이치스퀘어 N동 8층",
      Content(
        "신메뉴 출시❤️ 체리블라썸라떼",
        Uri.parse(
            "http://mud-kage.kakao.co.kr/dn/bSbH9w/btqgegaEDfW/vD9KKV0hEintg6bZT4v4WK/kakaolink40_original.png"),
        Link(
            webUrl: Uri.parse("https://developers.com"),
            mobileWebUrl: Uri.parse("https://developers.kakao.com")),
        description: "이번 주는 체리블라썸라떼 1+1",
      ),
      addressTitle: "카카오 판교오피스 카페톡",
      social: Social(likeCount: 286, commentCount: 45, sharedCount: 845));

  final defaultCommerce = CommerceTemplate(
      Content(
          "Ivory long dress (4 Color)",
          Uri.parse(
              "http://mud-kage.kakao.co.kr/dn/RY8ZN/btqgOGzITp3/uCM1x2xu7GNfr7NS9QvEs0/kakaolink40_original.png"),
          Link(
              webUrl: Uri.parse("https://developers.kakao.com"),
              mobileWebUrl: Uri.parse("https://developers.kakao.com"))),
      Commerce(208800,
          discountPrice: 146160,
          discountRate: 30,
          productName: "Ivory long dress",
          currencyUnit: "₩",
          currencyUnitPosition: 1),
      buttons: [
        Button(
            "구매하기",
            Link(
                webUrl: Uri.parse("https://developers.kakao.com"),
                mobileWebUrl: Uri.parse("https://developers.kakao.com"))),
        Button(
          "공유하기",
          Link(
              androidExecParams: 'key1=value1&key2=value2',
              iosExecParams: 'key1=value1&key2=value2'),
        )
      ]);

  final defaultText = TextTemplate(
      '''
      카카오링크는 카카오 플랫폼 서비스의 대표 기능으로써 사용자의 모바일 기기에 설치된 카카오 플랫폼과 연동하여 다양한 기능을 실행할 수 있습니다.
      현재 이용할 수 있는 카카오링크는 다음과 같습니다.
      카카오톡링크
      카카오톡을 실행하여 사용자가 선택한 채팅방으로 메시지를 전송합니다.
      카카오스토리링크
      카카오스토리 글쓰기 화면으로 연결합니다.
      '''
          .trim(),
      Link(
          webUrl: Uri.parse("https://developers.kakao.com"),
          mobileWebUrl: Uri.parse("https://developers.kakao.com")));
}
