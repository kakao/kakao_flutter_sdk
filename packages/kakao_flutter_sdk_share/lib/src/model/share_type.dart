/// KO: 카카오톡 공유 대상 선택 화면 유형
/// <br>
/// EN: Type of share target selection screen in Kakao Talk.
enum ShareType {
  /// KO: 친구 목록과 채팅방 목록 모두 노출(기본값)
  /// <br>
  /// EN: Shows both friends list and chat rooms list (default)
  defaultType('default'),

  /// KO: 친구 목록만 노출
  /// <br>
  /// EN: Shows friends list only
  friend('friend'),

  /// KO: 채팅방 목록만 노출
  /// <br>
  /// EN: Shows chat rooms list only
  chat('chat');

  /// @nodoc
  const ShareType(this.value);

  /// @nodoc
  final String value;
}
