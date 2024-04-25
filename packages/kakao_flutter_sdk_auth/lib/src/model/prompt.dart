/// KO: 상호작용 추가 요청
/// <br>
/// EN: Request to additinal interactivity
enum Prompt {
  /// KO: 사용자 재인증
  /// <br>
  /// EN: Reauthenticate users
  login,

  /// KO: 카카오계정 신규 가입 후 로그인
  /// <br>
  /// EN: Login after signing up for a Kakao Account
  create,

  /// KO: 카카오계정 간편로그인
  /// <br>
  /// EN: Kakao Account easy login
  selectAccount,

  /// @nodoc
  cert,
}
