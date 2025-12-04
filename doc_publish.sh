#!/bin/bash

if [ $# -eq 0 ]; then
  echo "No arguments supplied"
  exit
fi

if [[ $1 != *.*.* ]] || [[ $1 == 0.0.0 ]]; then
  echo "The version code format is *.*.*"
  exit
fi

VERSION=$1
REPOSITORY=""

if [ "$2" = "release" ]; then
  REPOSITORY="releases"
elif [ "$2" = "snapshot" ]; then
  REPOSITORY="snapshots"
  VERSION="$1-SNAPSHOT"
else
  echo "Pass the argument 'release' or 'snapshot'"
  exit
fi

# README 파일 복사
cp "./README.md" packages/kakao_flutter_sdk/

# 레퍼런스 생성
cd ./packages/kakao_flutter_sdk || exit
dartdoc --no-link-to-remote

# 레퍼런스 링크 수정 (dartdoc 8.3.0 버전부터 패키지 루트 문서가 index.html로 생성되어 링크 수정 필요)
dart ../../edit_doc_link.dart doc/api

# 레퍼런스 zip (루트에서 zip 하면 서브 디렉토리까지 다 포함되므로 cd 로 디렉토리 이동 후 zip)
cd doc/api || exit
zip -q -r ../../../../kakao-flutter-sdk-doc-"$1".zip .
cd ../../../../

# nexus 업로드
mvn deploy:deploy-file -e -DgroupId=com.kakao.sdk -DartifactId=kakao-flutter-sdk-doc -Dversion="$VERSION" -Dpackaging=zip -DrepositoryId=kakaodev-"$REPOSITORY" -Durl=https://devrepo.kakao.com/nexus/content/repositories/kakaodev-"$REPOSITORY" -Dfile=kakao-flutter-sdk-doc-"$1".zip

# 파일 삭제
rm ./packages/kakao_flutter_sdk/README.md
rm -rf ./packages/kakao_flutter_sdk/doc
rm kakao-flutter-sdk-doc-"$1".zip
