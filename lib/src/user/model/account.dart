import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Account {
  Account(this.hasEmail, this.isEmailVerified, this.email, this.isKakaotalkUser,
      this.hasPhoneNumber, this.phoneNumber);
  bool hasEmail;
  bool isEmailVerified;
  String email;
  bool isKakaotalkUser;
  bool hasPhoneNumber;
  String phoneNumber;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
