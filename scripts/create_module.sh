#!/bin/zsh

# 사용법: ./create_module.sh <패키지명> [타입] [ORG]
# 예: ./create_module.sh my_plugin plugin com.kakao.sdk
# 예: ./create_module.sh my_package package

NAME=$1
TYPE=${2:-package} # 두 번째 인자가 없으면 기본값으로 'package' 사용
ORG=$3

# 패키지명이 입력되지 않았을 경우 종료
if [ -z "$NAME" ]; then
  echo "Error: 패키지명을 입력해주세요."
  echo "Usage: ./create_package.sh <package_name> [package|plugin] [org]"
  exit 1
fi

TARGET_DIR="../packages/$NAME"

echo "=========================================="
echo "Creating Flutter $TYPE: $NAME"
if [ -n "$ORG" ]; then
  echo "Organization: $ORG"
fi
echo "Location: $TARGET_DIR"
echo "=========================================="

# 1. 플러터 패키지/플러그인 생성
# 옵션 배열 구성
CREATE_ARGS=(create --template="$TYPE" --no-pub)

# 플러그인일 경우 플랫폼 지정
if [[ "$TYPE" == "plugin" ]]; then
  CREATE_ARGS+=(--platforms android,ios,web)
fi

# Org 지정
if [[ -n "$ORG" ]]; then
  CREATE_ARGS+=(--org "$ORG")
fi

CREATE_ARGS+=("$TARGET_DIR")

echo "Executing: flutter ${CREATE_ARGS[@]}"
flutter "${CREATE_ARGS[@]}"

if [ $? -ne 0 ]; then
  echo "Error: Flutter create command failed."
  exit 1
fi

# 2. 불필요한 파일 제거 (CHANGELOG.md, README.md, LICENSE, example/)
echo "Removing default files..."
rm -f "$TARGET_DIR/CHANGELOG.md"
rm -f "$TARGET_DIR/README.md"
rm -f "$TARGET_DIR/LICENSE"
rm -rf "$TARGET_DIR/example"

# 2.1 Android 패키지명 및 디렉토리 구조 수정 (ORG 입력 시 프로젝트 이름이 중복 생성되는 것 방지)
if [[ "$TYPE" == "plugin" && -n "$ORG" && -d "$TARGET_DIR/android" ]]; then
  echo "Adjusting Android package name..."

  # 언더스코어로 변환된 패키지 이름
  SAFE_NAME=$(echo "$NAME" | tr '-' '_')

  # src 디렉토리 하위의 모든 폴더(main, test, androidTest 등)를 대상으로 반복
  for SRC_TYPE in main test androidTest; do
    ANDROID_SRC="$TARGET_DIR/android/src/$SRC_TYPE"

    if [ ! -d "$ANDROID_SRC" ]; then
      continue
    fi

    echo "Processing $SRC_TYPE..."

    # Kotlin 또는 Java 디렉토리 확인
    if [ -d "$ANDROID_SRC/kotlin" ]; then
      LANG_DIR="kotlin"
      EXT="kt"
    elif [ -d "$ANDROID_SRC/java" ]; then
      LANG_DIR="java"
      EXT="java"
    else
      LANG_DIR=""
    fi

    if [ -n "$LANG_DIR" ]; then
      # 점(.)을 슬래시(/)로 변환
      ORG_PATH=$(echo "$ORG" | sed 's/\./\//g')

      # 기본 생성된 경로: .../ORG/NAME
      FULL_PATH="$ANDROID_SRC/$LANG_DIR/$ORG_PATH/$SAFE_NAME"
      TARGET_PATH="$ANDROID_SRC/$LANG_DIR/$ORG_PATH"

      if [ -d "$FULL_PATH" ]; then
        echo "Moving files from $FULL_PATH to $TARGET_PATH"

        # 파일 이동
        mv "$FULL_PATH"/* "$TARGET_PATH/" 2>/dev/null
        rmdir "$FULL_PATH"

        # 파일 내 package 선언 수정 (macOS sed)
        find "$TARGET_PATH" -type f -name "*.$EXT" | while read FILE; do
           sed -i '' "s/package ${ORG}.${SAFE_NAME}/package ${ORG}/g" "$FILE"
        done
      fi
    fi
  done

  # build.gradle 수정 (namespace 및 group)
  GRADLE_FILE="$TARGET_DIR/android/build.gradle"
  if [ -f "$GRADLE_FILE" ]; then
    echo "Updating build.gradle in $GRADLE_FILE"
    # namespace 수정 (등호 포함, 따옴표 처리)
    sed -i '' "s/namespace = [\"']${ORG}.${SAFE_NAME}[\"']/namespace = \"${ORG}\"/g" "$GRADLE_FILE"
    # group 수정 (등호 포함, 따옴표 처리)
    sed -i '' "s/group = [\"']${ORG}.${SAFE_NAME}[\"']/group = \"${ORG}\"/g" "$GRADLE_FILE"
  fi

  # AndroidManifest.xml package 수정
  MANIFEST_FILE="$TARGET_DIR/android/src/main/AndroidManifest.xml"
  if [ -f "$MANIFEST_FILE" ]; then
    echo "Updating package in $MANIFEST_FILE"
    sed -i '' "s/package=\"${ORG}.${SAFE_NAME}\"/package=\"${ORG}\"/g" "$MANIFEST_FILE"
  fi
fi

# 2.2 pubspec.yaml 수정
PUBSPEC_FILE="$TARGET_DIR/pubspec.yaml"
if [ -f "$PUBSPEC_FILE" ]; then
  echo "Modifying pubspec.yaml..."

  # resolution: workspace 추가 (environment 위에 추가)
  sed -i '' '/^environment:/i\
resolution: workspace\
\
' "$PUBSPEC_FILE"

  # 플러그인이고 ORG가 있을 때 android package 수정
  if [[ "$TYPE" == "plugin" && -n "$ORG" ]]; then
     SAFE_NAME=$(echo "$NAME" | tr '-' '_')
     sed -i '' "s/package: ${ORG}.${SAFE_NAME}/package: ${ORG}/g" "$PUBSPEC_FILE"
  fi
fi

# 2.3 Lib 및 Test 디렉토리 정리
echo "Cleaning up lib and test directories..."
# test 하위 파일 모두 삭제
rm -rf "$TARGET_DIR/test"/*

# lib 디렉토리 정리 (메인 라이브러리 파일만 library; 로 재생성)
rm -rf "$TARGET_DIR/lib"
mkdir -p "$TARGET_DIR/lib"
echo "library;" > "$TARGET_DIR/lib/$NAME.dart"

# 3. analysis_options.yaml 설정
echo "Configuring analysis_options.yaml..."
cat > "$TARGET_DIR/analysis_options.yaml" <<EOF
include: ../../analysis_options.yaml

# Additional information about this file can be found at
# https://dart.dev/guides/language/analysis-options
EOF

echo "=========================================="
echo "✅ 완료되었습니다!"
echo "Package created at: $TARGET_DIR"
echo "=========================================="

