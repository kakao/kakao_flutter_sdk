import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:kakao_flutter_sdk_talk/src/constants.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path =
            uriPathToFilePath('${Constants.v1OpenTalkMessagePath}send');
        String body = await loadJson('talk/$path/$data.json');
        Map<String, dynamic> expected = jsonDecode(body);
        var response = MessageSendResult.fromJson(expected);

        var successfulLength = response.successfulReceiverUuids?.length ?? 0;
        for (int i = 0; i < successfulLength; i++) {
          var expectedUuid = expected['successful_receiver_uuids'][i];
          var uuid = response.successfulReceiverUuids![i];

          expect(uuid, expectedUuid);
        }

        var failureLength = response.failureInfos?.length ?? 0;
        for (int i = 0; i < failureLength; i++) {
          var expectedFailureInfo = expected['failure_info'][i];
          var failureInfo = response.failureInfos![i];

          expect(failureInfo.code, expectedFailureInfo['code']);
          expect(failureInfo.msg, expectedFailureInfo['msg']);

          for (int j = 0; j < failureInfo.receiverUuids.length; j++) {
            var uuid = failureInfo.receiverUuids[j];
            var expectedUuid = expectedFailureInfo['receiver_uuids'][j];

            expect(uuid, expectedUuid);
          }
        }
      });
    }

    parse('success');
    parse('partial_success');
  });
}
