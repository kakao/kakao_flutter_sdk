#!/bin/bash

# 각 패키지에 README.md, CHANGELOG.md 파일 생성, pubspec.yaml 버전 업데이트, 로컬 의존성 제거, 배포해주는 스크립트.

# 버전 정보를 업데이트하기 위해 임시로 패키지 목록을 저장하는 파일
FILENAME='package_list.txt'

# 로컬로 참조하는 의존성을 제거해줘야함
# 모듈 의존성 때문에 PACKAGE_LIST의 순서대로 로컬 의존성이 제거되어야함
SDK_NAME="kakao_flutter_sdk"

PACKAGE_LIST=("_common" "_auth" "_navi" "_template" "_link" "_story" "_user" "_talk" "")

echo "Do you want to publish kakao_flutter_sdk?"
select yn in "Yes" "No"; do
  case $yn in
  Yes) break ;;
  No)
    exit
    ;;
  esac
done

branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

# release 또는 hotfix 브랜치가 아니면 스크립트 종료
if [[ $branch != "release"* ]] && [[ $branch != "hotfix"* ]]; then
  echo "The current branch must be release or hotfix!"
  exit
fi

version="1.0.0"

# 브랜치 이름에서 버전 파싱
if [[ $branch == "release"* ]]; then
  version=${branch:8}
elif [[ $branch == "hotfix"* ]]; then
  version=${branch:7}
fi

# 브랜치 이름에 버전 정보가 없으면 스크립트 종료
if [[ $version != *.*.* ]] || [[ $version == 0.0.0 ]]; then
  echo "The current branch must contains version!"
  exit
fi

# KakaoSdk.sdkVersion 변경
find packages/kakao_flutter_sdk_common/lib/src -name "kakao_sdk.dart" -exec perl -pi -e "s/static String sdkVersion .*/static String sdkVersion = \"${version}\";/g" {} \;

# 버전 정보를 변경해야하는 패키지 이름 저장
melos list -a >$FILENAME

# 파일 읽으면서 패키지 버전 수정
while read -r line; do
  melos version "$line" "$version" --yes --no-changelog
done <$FILENAME

# 패키지 목록 저장 파일 삭제
rm $FILENAME

# 각 패키지의 pubspec.yaml 백업을 위한 디렉토리 생성
mkdir backup

cd "packages" || exit
for package in "${PACKAGE_LIST[@]}"; do
  # pubspec.yaml 백업을 위한 패키지 디렉토리 생성
  mkdir ../backup/${SDK_NAME}"$package"

  # 생성한 디렉토리에 pubspec.yaml 파일 백업
  cp "${SDK_NAME}${package}/pubspec.yaml" "../backup/${SDK_NAME}${package}/"

  cp "../README.md" "${SDK_NAME}${package}/"
  cp "../CHANGELOG.md" "${SDK_NAME}${package}/"

  # 로컬 참조를 외부 참조로 변경
  python3 ../edit_dependency.py "${SDK_NAME}${package}/pubspec.yaml" "$version"

  # 각 패키지로 이동해서 배포
  cd "${SDK_NAME}$package" || exit
  flutter packages pub publish -f || exit
  cd ..

  # 백업한 pubspec.yaml을 다시 복구
  mv "../backup/${SDK_NAME}${package}/pubspec.yaml" "${SDK_NAME}${package}/pubspec.yaml"
done

# 백업 디렉토리 삭제
rm -r ../backup

# README.md, CHANGELOG.md 파일 삭제
for package in "${PACKAGE_LIST[@]}"; do
  rm "${SDK_NAME}${package}/README.md"
  rm "${SDK_NAME}${package}/CHANGELOG.md"
done
