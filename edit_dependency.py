import sys

# pubspec.yaml 파일에서 로컬 참조를 외부 참조로 변경해주는 파이썬 스크립트.
# publish.sh 스크립트에서 파일 경로와 버전 정보를 전달받아 실행됨

file_path = sys.argv[1]
version = sys.argv[2]

with open(file_path, 'r') as f:
    lines = f.readlines()

with open(file_path, 'w') as f:
    for pos, line in enumerate(lines):
        if line.__contains__("path:"):
            continue
        elif line.__contains__("kakao_flutter_sdk_") and line.endswith(':\n'):
            line = line.replace('\n', ' {}\n'.format(version))
            f.write(line)
        else:
            f.write(line)
