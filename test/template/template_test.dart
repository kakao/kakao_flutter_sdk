import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/src/talk/talk_api.dart';

void main() {
  setUp(() {});

  test("feed", () {
    FeedTemplate template = FeedTemplate(
        Content(
            "Default Feed Template",
            "http://k.kakaocdn.net/dn/kit8l/btqgef9A1tc/pYHossVuvnkpZHmx5cgK8K/kakaolink40_original.png",
            Link()),
        social: Social(likeCount: 100));
    print(template.toJson());
  });
}
