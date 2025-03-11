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

          expect(
              account.ageRange,
              $enumDecodeNullable(
                $AgeRangeEnumMap,
                expectedAccount['age_range'],
                unknownValue: AgeRange.unknown,
              ));

          expect(
            account.birthyearNeedsAgreement,
            expectedAccount['birthyear_needs_agreement'],
          );
          expect(account.birthyear, expectedAccount['birthyear']);
          expect(account.birthday, expectedAccount['birthday']);

          expect(
            account.birthdayType,
            $enumDecodeNullable(
              $BirthdayTypeEnumMap,
              expectedAccount['birthday_type'],
              unknownValue: BirthdayType.unknown,
            ),
          );

          expect(
            account.genderNeedsAgreement,
            expectedAccount['gender_needs_agreement'],
          );

          expect(
            account.gender,
            $enumDecodeNullable(
              $GenderEnumMap,
              expectedAccount['gender'],
              unknownValue: Gender.other,
            ),
          );

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

          expect(
            account.legalGender,
            $enumDecodeNullable($GenderEnumMap, expectedAccount['legal_gender'],
                unknownValue: Gender.other),
          );
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
      expect(
        AgeRange.age_0_9,
        $enumDecodeNullable($AgeRangeEnumMap, '0~9',
            unknownValue: AgeRange.unknown),
      );
      expect(
        AgeRange.age_10_14,
        $enumDecode($AgeRangeEnumMap, '10~14', unknownValue: AgeRange.unknown),
      );
      expect(
        AgeRange.age_15_19,
        $enumDecode($AgeRangeEnumMap, '15~19', unknownValue: AgeRange.unknown),
      );
      expect(
        AgeRange.age_20_29,
        $enumDecode($AgeRangeEnumMap, '20~29', unknownValue: AgeRange.unknown),
      );
      expect(
        AgeRange.age_30_39,
        $enumDecode($AgeRangeEnumMap, '30~39', unknownValue: AgeRange.unknown),
      );
      expect(
        AgeRange.age_40_49,
        $enumDecode($AgeRangeEnumMap, '40~49', unknownValue: AgeRange.unknown),
      );
      expect(
        AgeRange.age_50_59,
        $enumDecode($AgeRangeEnumMap, '50~59', unknownValue: AgeRange.unknown),
      );
      expect(
        AgeRange.age_60_69,
        $enumDecode($AgeRangeEnumMap, '60~69', unknownValue: AgeRange.unknown),
      );
      expect(
        AgeRange.age_70_79,
        $enumDecode($AgeRangeEnumMap, '70~79', unknownValue: AgeRange.unknown),
      );
      expect(
        AgeRange.age_80_89,
        $enumDecode($AgeRangeEnumMap, '80~89', unknownValue: AgeRange.unknown),
      );
      expect(
        AgeRange.age_90above,
        $enumDecode($AgeRangeEnumMap, '90~', unknownValue: AgeRange.unknown),
      );
      expect(
        AgeRange.unknown,
        $enumDecode($AgeRangeEnumMap, 'test', unknownValue: AgeRange.unknown),
      );
    });

    test('BirthdayType Test', () {
      expect(
          BirthdayType.solar,
          $enumDecode($BirthdayTypeEnumMap, 'SOLAR',
              unknownValue: BirthdayType.unknown));
      expect(
          BirthdayType.lunar,
          $enumDecode($BirthdayTypeEnumMap, 'LUNAR',
              unknownValue: BirthdayType.unknown));
      expect(
          BirthdayType.unknown,
          $enumDecode($BirthdayTypeEnumMap, 'test',
              unknownValue: BirthdayType.unknown));
    });

    test('Gender Test', () {
      expect(Gender.female,
          $enumDecode($GenderEnumMap, 'female', unknownValue: Gender.other));
      expect(Gender.male,
          $enumDecode($GenderEnumMap, 'male', unknownValue: Gender.other));
      expect(Gender.other,
          $enumDecode($GenderEnumMap, 'test', unknownValue: Gender.other));
    });
  });
}
