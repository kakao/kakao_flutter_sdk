import 'dart:io';

import 'package:example/model/custom_data.dart';
import 'package:example/model/list_item.dart';
import 'package:example/util/log.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:path_provider/path_provider.dart';

import 'sdk_message_templates.dart';

const tag = 'ShareClient';

List<ListItem> createShareApis(CustomData customData) => <ListItem>[
  const Header(tag),
  Api('isKakaoTalkSharingAvailable()', (context) async {
    // 카카오톡 설치여부 조회
    final bool result = await ShareClient.instance
        .isKakaoTalkSharingAvailable();

    final msg = result ? '카카오톡 공유 가능' : '카카오톡 미설치: 웹 공유 사용 권장';
    Log.i(tag, msg);
  }),
  Api('customTemplate()', showResult: false, (context) async {
    // 커스텀 템플릿으로 카카오톡 공유 메시지 발송
    //  * 만들기 가이드: https://developers.kakao.com/docs/latest/ko/message/message-template
    final int templateId = customData.templateId;

    try {
      await ShareClient.instance.shareCustom(templateId: templateId);
      Log.i(tag, '카카오톡 공유 성공');
    } catch (e) {
      Log.e(tag, '카카오톡 공유 실패', e);
    }
  }),
  Api('scrapTemplate()', showResult: false, (context) async {
    // 스크랩 템플릿으로 카카오톡 공유 메시지 발송

    // 공유할 웹페이지 URL
    // * 주의: 개발자사이트 Web 플랫폼 설정에 공유할 URL의 도메인이 등록되어 있어야 합니다.
    final String url = "https://developers.kakao.com";

    try {
      await ShareClient.instance.shareScrap(url: url);
      Log.i(tag, '카카오톡 공유 성공');
    } catch (e) {
      Log.e(tag, '카카오톡 공유 실패', e);
    }
  }),
  Api('defaultTemplate() - feed', showResult: false, (context) async {
    // 디폴트 템플릿으로 카카오톡 공유 메시지 발송 - Feed

    try {
      await ShareClient.instance.shareDefault(template: defaultFeed);
      Log.i(tag, '카카오톡 공유 성공');
    } catch (e) {
      Log.e(tag, '카카오톡 공유 실패', e);
    }
  }),
  Api('defaultTemplate() - list', showResult: false, (context) async {
    // 디폴트 템플릿으로 카카오톡 공유 메시지 발송 - List

    try {
      await ShareClient.instance.shareDefault(template: defaultList);
      Log.i(tag, '카카오톡 공유 성공');
    } catch (e) {
      Log.e(tag, '카카오톡 공유 실패', e);
    }
  }),
  Api('defaultTemplate() - location', showResult: false, (context) async {
    // 디폴트 템플릿으로 카카오톡 공유 메시지 발송 - Location

    try {
      await ShareClient.instance.shareDefault(template: defaultLocation);
      Log.i(tag, '카카오톡 공유 성공');
    } catch (e) {
      Log.e(tag, '카카오톡 공유 실패', e);
    }
  }),
  Api('defaultTemplate() - commerce', showResult: false, (context) async {
    // 디폴트 템플릿으로 카카오톡 공유 메시지 발송 - Commerce

    try {
      await ShareClient.instance.shareDefault(template: defaultCommerce);
      Log.i(tag, '카카오톡 공유 성공');
    } catch (e) {
      Log.e(tag, '카카오톡 공유 실패', e);
    }
  }),
  Api('defaultTemplate() - text', showResult: false, (context) async {
    // 디폴트 템플릿으로 카카오톡 공유 메시지 발송 - Text

    try {
      await ShareClient.instance.shareDefault(template: defaultText);
      Log.i(tag, '카카오톡 공유 성공');
    } catch (e) {
      Log.e(tag, '카카오톡 공유 실패', e);
    }
  }),
  Api('defaultTemplate() - calendar', showResult: false, (context) async {
    final String calendarId = customData.calendarEventId;
    final DefaultTemplate template = defaultCalendar(calendarId);

    try {
      // 디폴트 템플릿으로 카카오톡 공유 메시지 발송 - Calendar
      await ShareClient.instance.shareDefault(template: template);
      Log.i(tag, '카카오톡 공유 성공');
    } catch (e) {
      Log.e(tag, '카카오톡 공유 실패', e);
    }
  }),
  Api('uploadImage() - File', (context) async {
    // 이미지 업로드

    // 로컬 이미지 파일
    // 이 샘플에서는 프로젝트 리소스로 추가한 이미지 파일을 사용했습니다. 갤러리 등 서비스 니즈에 맞는 사진 파일을 준비하세요.
    ByteData byteData = await rootBundle.load('assets/images/cat1.png');

    // 이 샘플에서는 path_provider를 사용해 프로젝트 리소스를 이미지 파일로 저장했습니다.
    final File tempFile = File(
      '${(await getTemporaryDirectory()).path}/cat1.png',
    );
    final File file = await tempFile.writeAsBytes(
      byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ),
    );

    try {
      // 카카오 이미지 서버로 업로드
      final ImageUploadResult imageUploadResult = await ShareClient.instance
          .uploadImage(imagePath: file.path);
      Log.i(tag, '이미지 업로드 성공\n${imageUploadResult.infos.original}');
    } catch (e) {
      Log.e(tag, '이미지 업로드 실패', e);
    }
  }),
  Api('uploadImage() - ByteData', (context) async {
    // 이미지 업로드

    // 이 샘플에서는 file_picker를 사용해 이미지 파일을 가져왔습니다.
    final filePickerResult = await FilePicker.platform.pickFiles(
      withData: true,
    );

    if (filePickerResult != null) {
      final byteData = filePickerResult.files.first.bytes;

      try {
        // 카카오 이미지 서버로 업로드
        final ImageUploadResult imageUploadResult = await ShareClient.instance
            .uploadImage(byteData: byteData);
        Log.i(tag, '이미지 업로드 성공\n${imageUploadResult.infos.original}');
      } catch (e) {
        Log.e(tag, '이미지 업로드 실패', e);
      }
    }
  }),
];
