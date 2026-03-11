import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:kakao_flutter_sdk_talk/src/constants.dart';

import '../../kakao_flutter_sdk_common/test/shared/utils/load_data.dart';

void main() {
  group('parse test', () {
    void verifyJsonToModel(String data) {
      test(data, () async {
        final path = uriPathToFilePath(
          '${Constants.v1OpenTalkMessagePath}send',
        );
        final body = await loadJson('talk/$path/$data.json');
        final expected = jsonDecode(body);
        final response = MessageSendResult.fromJson(expected);

        final successfulLength = response.successfulReceiverUuids?.length ?? 0;
        for (int i = 0; i < successfulLength; i++) {
          final expectedUuid = expected['successful_receiver_uuids'][i];
          final uuid = response.successfulReceiverUuids![i];

          expect(uuid, expectedUuid);
        }

        final failureLength = response.failureInfos?.length ?? 0;
        for (int i = 0; i < failureLength; i++) {
          final expectedFailureInfo = expected['failure_info'][i];
          final failureInfo = response.failureInfos![i];

          expect(failureInfo.code, expectedFailureInfo['code']);
          expect(failureInfo.msg, expectedFailureInfo['msg']);

          for (int j = 0; j < failureInfo.receiverUuids.length; j++) {
            final uuid = failureInfo.receiverUuids[j];
            final expectedUuid = expectedFailureInfo['receiver_uuids'][j];

            expect(uuid, expectedUuid);
          }
        }
      });
    }

    verifyJsonToModel('success');
    verifyJsonToModel('partial_success');
  });
}
