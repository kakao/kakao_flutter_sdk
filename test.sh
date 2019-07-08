flutter test --coverage test/
genhtml coverage/lcov.info -o coverage
open coverage/index.html