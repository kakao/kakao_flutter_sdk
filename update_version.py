import sys

# pubspec.yaml 파일에서 패키지 버전 정보를 업데이트하는 파이썬 스크립트
# publish.sh 스크립트에서 파일 경로와 버전 정보를 전달받아 실행됨

file_path = sys.argv[1]
version = sys.argv[2]

with open(file_path, 'r') as f:
    lines = f.readlines()

with open(file_path, 'w') as f:
    for pos, line in enumerate(lines):
        if line.__contains__("version:"):
            continue
        elif line.__contains__("description:"):
            line = line.replace('\n', '\nversion: {}\n'.format(version))
            f.write(line)
        else:
            f.write(line)
