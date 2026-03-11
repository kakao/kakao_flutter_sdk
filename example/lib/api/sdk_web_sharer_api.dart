import 'package:example/model/custom_data.dart';
import 'package:example/model/list_item.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'sdk_message_templates.dart';

const tag = 'WebSharerClient';

List<ListItem> createWebSharerApis(CustomData customData) => <ListItem>[
  const Header('WebSharerClient'),
  Api('makeCustomUrl()', showResult: false, (context) async {
    // 커스텀 템플릿으로 카카오톡 공유 메시지 발송
    //  * 만들기 가이드: https://developers.kakao.com/docs/latest/ko/message/message-template
    final int templateId = customData.templateId;

    final url = await WebSharerClient.instance.makeCustomUrl(
      templateId: templateId,
    );
    await launchBrowser(url, useBrowserSessionOnIOS: true);
  }),
  Api('makeScrapUrl()', showResult: false, (context) async {
    // 스크랩 템플릿으로 카카오톡 공유 메시지 발송

    // 공유할 웹페이지 URL
    // * 주의: 개발자사이트 Web 플랫폼 설정에 공유할 URL의 도메인이 등록되어 있어야 합니다.
    final String url = "https://developers.kakao.com";

    final shareUrl = await WebSharerClient.instance.makeScrapUrl(url: url);
    await launchBrowser(shareUrl, useBrowserSessionOnIOS: true);
  }),
  Api('makeDefaultUrl() - feed', showResult: false, (context) async {
    // 디폴트 템플릿으로 카카오톡 공유 메시지 발송 - Feed
    final url = await WebSharerClient.instance.makeDefaultUrl(
        template: defaultFeed);
    await launchBrowser(url, useBrowserSessionOnIOS: true);
  }),
  Api('makeDefaultUrl() - list', showResult: false, (context) async {
    // 디폴트 템플릿으로 카카오톡 공유 메시지 발송 - List
    final url = await WebSharerClient.instance.makeDefaultUrl(
        template: defaultList);
    await launchBrowser(url, useBrowserSessionOnIOS: true);
  }),
  Api('makeDefaultUrl() - location', showResult: false, (context) async {
    // 디폴트 템플릿으로 카카오톡 공유 메시지 발송 - Location
    final url = await WebSharerClient.instance.makeDefaultUrl(
        template: defaultLocation);
    await launchBrowser(url, useBrowserSessionOnIOS: true);
  }),
  Api('makeDefaultUrl() - commerce', showResult: false, (context) async {
    // 디폴트 템플릿으로 카카오톡 공유 메시지 발송 - Commerce
    final url = await WebSharerClient.instance.makeDefaultUrl(
        template: defaultCommerce);
    await launchBrowser(url, useBrowserSessionOnIOS: true);
  }),
  Api('makeDefaultUrl() - text', showResult: false, (context) async {
    // 디폴트 템플릿으로 카카오톡 공유 메시지 발송 - Text
    final url = await WebSharerClient.instance.makeDefaultUrl(
        template: defaultText);
    await launchBrowser(url, useBrowserSessionOnIOS: true);
  }),
  Api('makeDefaultUrl() - calendar', showResult: false, (context) async {
    final calendarId = customData.calendarEventId;
    final template = defaultCalendar(calendarId);

    // 디폴트 템플릿으로 카카오톡 공유 메시지 발송 - Calendar
    final url = await WebSharerClient.instance.makeDefaultUrl(
        template: template);
    await launchBrowser(url, useBrowserSessionOnIOS: true);
  }),
];
