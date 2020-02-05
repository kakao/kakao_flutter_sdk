import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk/template.dart';

void main() {
  setUp(() {});

  test("feed", () {
    final template = FeedTemplate(
        Content(
            "Default Feed Template",
            Uri.parse(
                "http://k.kakaocdn.net/dn/kit8l/btqgef9A1tc/pYHossVuvnkpZHmx5cgK8K/kakaolink40_original.png"),
            Link()),
        social: Social(likeCount: 100));
    final json = template.toJson();
    expect(json["object_type"], "feed");
  });

  test("location", () {
    final template = LocationTemplate(
        "성남시 분당구 판교역로 235",
        Content(
          "장소 공유",
          Uri.parse(
              "http://www.kakaocorp.com/images/logo/og_daumkakao_151001.png"),
          Link(
            webUrl: Uri.parse("https://developers.kakao.com"),
            mobileWebUrl: Uri.parse("https://developers.kakao.com"),
          ),
        ),
        social: Social(likeCount: 286, commentCount: 45, sharedCount: 845),
        buttons: [
          Button("웹으로 보기",
              Link(webUrl: Uri.parse("https://map.kakao.com/link/map/0,0"))),
        ],
        addressTitle: "카카오판교오피스");

    final json = template.toJson();
    expect(json["object_type"], "location");
  });
}
