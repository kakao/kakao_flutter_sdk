class ServerHosts {
  final String kapi = "kapi.kakao.com";
  final String kauth = "kauth.kakao.com";
  final String sharer = "sharer.kakao.com";
}

class SandboxServerHosts extends ServerHosts {
  @override
  String get kapi => "sandbox-kapi.kakao.com";

  @override
  String get kauth => "sandbox-kauth.kakao.com";

  @override
  String get sharer => 'sandbox-sharer.kakao.com';
}
