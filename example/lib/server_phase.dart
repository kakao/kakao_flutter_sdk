import 'package:kakao_flutter_sdk/common.dart';

enum KakaoPhase { DEV, SANDBOX, CBT, PRODUCTION }

class PhasedAppKey {
  KakaoPhase phase;

  PhasedAppKey(this.phase);

  String getAppKey() {
    if (phase == KakaoPhase.DEV) {
      return '01a5e3755dee69871faf55fe79d47c42';
    } else if (phase == KakaoPhase.SANDBOX) {
      return '148b7d8c3c52e3421f7a13a8fc236b19';
    } else {
      return '030ba7c59137629e86e8721eb1a22fd6';
    }
  }
}

class PhasedServerHosts extends ServerHosts {
  KakaoPhase phase;

  PhasedServerHosts(this.phase);

  @override
  String get kapi {
    if (phase == KakaoPhase.DEV) {
      return 'alpha-${super.kapi}';
    } else if (phase == KakaoPhase.SANDBOX) {
      return 'sandbox-${super.kapi}';
    } else if (phase == KakaoPhase.CBT) {
      return 'beta-${super.kapi}';
    } else {
      return super.kapi;
    }
  }

  @override
  String get kauth {
    if (phase == KakaoPhase.DEV) {
      return 'alpha-${super.kauth}';
    } else if (phase == KakaoPhase.SANDBOX) {
      return 'sandbox-${super.kauth}';
    } else if (phase == KakaoPhase.CBT) {
      return 'beta-${super.kauth}';
    } else {
      return super.kauth;
    }
  }

  @override
  String get sharer {
    if (phase == KakaoPhase.DEV) {
      return 'alpha-${super.sharer}';
    } else if (phase == KakaoPhase.SANDBOX) {
      return 'sandbox-${super.sharer}';
    } else if (phase == KakaoPhase.CBT) {
      return 'beta-${super.sharer}';
    } else {
      return super.sharer;
    }
  }

  @override
  String get pf {
    if (phase == KakaoPhase.DEV) {
      return 'alpha-${super.pf}';
    } else if (phase == KakaoPhase.SANDBOX) {
      return 'sandbox-${super.pf}';
    } else if (phase == KakaoPhase.CBT) {
      return 'beta-${super.pf}';
    } else {
      return super.pf;
    }
  }
}
