import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_template/kakao_flutter_sdk_template.dart';

void main() {
  setUp(() {});

  test("feed", () {
    final template = FeedTemplate(
        content: Content(
          title: "Default Feed Template",
          imageUrl: Uri.parse(
              "http://k.kakaocdn.net/dn/kit8l/btqgef9A1tc/pYHossVuvnkpZHmx5cgK8K/kakaolink40_original.png"),
          link: Link(),
        ),
        social: Social(likeCount: 100));
    final json = template.toJson();
    expect(json["object_type"], "feed");
  });

  test("location", () {
    final template = LocationTemplate(
        address: "성남시 분당구 판교역로 235",
        content: Content(
          title: "장소 공유",
          imageUrl: Uri.parse(
              "http://www.kakaocorp.com/images/logo/og_daumkakao_151001.png"),
          link: Link(
            webUrl: Uri.parse("https://developers.kakao.com"),
            mobileWebUrl: Uri.parse("https://developers.kakao.com"),
          ),
        ),
        social: Social(likeCount: 286, commentCount: 45, sharedCount: 845),
        buttons: [
          Button(
            title: "웹으로 보기",
            link: Link(
              webUrl: Uri.parse("https://map.kakao.com/link/map/0,0"),
            ),
          ),
        ],
        addressTitle: "카카오판교오피스");

    final json = template.toJson();
    expect(json["object_type"], "location");
  });
}
