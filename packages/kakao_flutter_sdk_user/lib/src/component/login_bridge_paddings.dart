abstract class LoginBridgePaddings {
  double get portraitPadding;

  double get landscapePadding;

  double get titleTopPadding;

  double get titleBottomPadding;

  double get logoPortraitBottomPadding;

  double get logoLandscapeBottomPadding;
}

class AndroidPaddings extends LoginBridgePaddings {
  @override
  double get portraitPadding => 8.5;

  @override
  double get landscapePadding => 16.0;

  @override
  double get titleBottomPadding => 14.0;

  @override
  double get titleTopPadding => 14.0;

  @override
  double get logoPortraitBottomPadding => 30.0;

  @override
  double get logoLandscapeBottomPadding => 30.0;
}

class IosPaddings extends LoginBridgePaddings {
  @override
  double get portraitPadding => 25.0;

  @override
  double get landscapePadding => 73.0;

  @override
  double get titleTopPadding => 14.0;

  @override
  double get titleBottomPadding => 15.0;

  @override
  double get logoPortraitBottomPadding => 50.0;

  @override
  double get logoLandscapeBottomPadding => 37.0;
}
