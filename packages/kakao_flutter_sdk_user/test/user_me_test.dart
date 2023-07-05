import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kakao_flutter_sdk_user/src/constants.dart';
import 'package:kakao_flutter_sdk_user/src/model/account.dart';
import 'package:kakao_flutter_sdk_user/src/model/user.dart';

import '../../kakao_flutter_sdk_common/test/helper.dart';
import 'test_enum_map.dart';

void main() {
  group('parse test', () {
    void parse(String data) {
      test(data, () async {
        final path = uriPathToFilePath(Constants.v2MePath);
        var body = await loadJson("user/$path/$data.json");
        Map<String, dynamic> expected = jsonDecode(body);
        var response = User.fromJson(expected);

        expect(response.id, expected['id']);
        expect(response.properties, expected['properties']);

        if (response.kakaoAccount != null) {
          var account = response.kakaoAccount!;
          var expectedAccount = expected['kakao_account'];

          expect(
            account.profileNeedsAgreement,
            expectedAccount['profile_needs_agreement'],
          );
          expect(
            account.profileNicknameNeedsAgreement,
            expectedAccount['profile_nickname_needs_agreement'],
          );
          expect(
            account.profileImageNeedsAgreement,
            expectedAccount['profile_image_needs_agreement'],
          );
          expect(
            account.nameNeedsAgreement,
            expectedAccount['name_needs_agreement'],
          );
          expect(account.name, expectedAccount['name']);
          expect(
            account.emailNeedsAgreement,
            expectedAccount['email_needs_agreement'],
          );
          expect(account.isEmailVerified, expectedAccount['is_email_verified']);
          expect(account.isEmailValid, expectedAccount['is_email_valid']);
          expect(account.email, expectedAccount['email']);
          expect(account.ageRangeNeedsAgreement,
              expectedAccount['age_range_needs_agreement']);

          if (account.ageRange != null) {
            expect(account.ageRange,
                $enumDecode($AgeRangeEnumMap, expectedAccount['age_range']));
          }

          expect(
            account.birthyearNeedsAgreement,
            expectedAccount['birthyear_needs_agreement'],
          );
          expect(account.birthyear, expectedAccount['birthyear']);
          expect(account.birthday, expectedAccount['birthday']);

          if (account.birthdayType != null) {
            expect(
              account.birthdayType,
              $enumDecode(
                $BirthdayTypeEnumMap,
                expectedAccount['birthday_type'],
              ),
            );
          }

          expect(
            account.genderNeedsAgreement,
            expectedAccount['gender_needs_agreement'],
          );

          if (account.gender != null) {
            expect(
              account.gender,
              $enumDecode($GenderEnumMap, expectedAccount['gender']),
            );
          }

          expect(
            account.ciNeedsAgreement,
            expectedAccount['ci_needs_agreement'],
          );
          expect(account.ci, expectedAccount['ci']);

          if (account.ciAuthenticatedAt != null) {
            expect(account.ciAuthenticatedAt,
                DateTime.parse(expectedAccount['ci_authenticated_at']));
          }

          expect(
            account.legalNameNeedsAgreement,
            expectedAccount['legal_name_needs_agreement'],
          );
          expect(account.legalName, expectedAccount['legal_name']);

          expect(
            account.legalBirthDateNeedsAgreement,
            expectedAccount['legal_birth_date_needs_agreement'],
          );

          expect(account.legalBirthDate, expectedAccount['legal_birth_date']);
          expect(
            account.legalGenderNeedsAgreement,
            expectedAccount['legal_gender_needs_agreement'],
          );

          if (account.legalGender != null) {
            expect(
              account.legalGender,
              $enumDecode($GenderEnumMap, expectedAccount['legal_gender']),
            );
          }
          expect(
            account.phoneNumberNeedsAgreement,
            expectedAccount['phone_number_needs_agreement'],
          );
          expect(account.phoneNumber, expectedAccount['phone_number']);

          expect(account.isKorean, expectedAccount['is_korean']);

          if (account.profile != null) {
            var profile = account.profile!;
            var expectedProfile = expectedAccount['profile'];

            expect(profile.nickname, expectedProfile['nickname']);
            expect(
              profile.profileImageUrl,
              expectedProfile['profile_image_url'],
            );
            expect(
              profile.thumbnailImageUrl,
              expectedProfile['thumbnail_image_url'],
            );
            expect(profile.isDefaultImage, expectedProfile['is_default_image']);
          }
        }

        expect(response.groupUserToken, expected['group_user_token']);

        if (response.connectedAt != null) {
          expect(
            response.connectedAt,
            DateTime.parse(expected['connected_at']),
          );
        }

        if (response.synchedAt != null) {
          expect(response.synchedAt, DateTime.parse(expected['synched_at']));
        }

        expect(response.hasSignedUp, expected['has_signed_up']);
      });
    }

    parse('min');
    parse('max');
  });

  group('enum test', () {
    test('AgeRange Test', () {
      expect(AgeRange.age_0_9, $enumDecode($AgeRangeEnumMap, '0~9'));
      expect(AgeRange.age_10_14, $enumDecode($AgeRangeEnumMap, '10~14'));
      expect(AgeRange.age_15_19, $enumDecode($AgeRangeEnumMap, '15~19'));
      expect(AgeRange.age_20_29, $enumDecode($AgeRangeEnumMap, '20~29'));
      expect(AgeRange.age_30_39, $enumDecode($AgeRangeEnumMap, '30~39'));
      expect(AgeRange.age_40_49, $enumDecode($AgeRangeEnumMap, '40~49'));
      expect(AgeRange.age_50_59, $enumDecode($AgeRangeEnumMap, '50~59'));
      expect(AgeRange.age_60_69, $enumDecode($AgeRangeEnumMap, '60~69'));
      expect(AgeRange.age_70_79, $enumDecode($AgeRangeEnumMap, '70~79'));
      expect(AgeRange.age_80_89, $enumDecode($AgeRangeEnumMap, '80~89'));
      expect(AgeRange.age_90above, $enumDecode($AgeRangeEnumMap, '90~'));
    });

    test('BirthdayType Test', () {
      expect(BirthdayType.solar, $enumDecode($BirthdayTypeEnumMap, 'SOLAR'));
      expect(BirthdayType.lunar, $enumDecode($BirthdayTypeEnumMap, 'LUNAR'));
    });

    test('Gender Test', () {
      expect(Gender.female, $enumDecode($GenderEnumMap, 'female'));
      expect(Gender.male, $enumDecode($GenderEnumMap, 'male'));
    });
  });
}
