#!/usr/bin/env sh
set -eu

cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build --config Debug
ctest --test-dir build -C Debug --output-on-failure

[ "$(build/bin/hello)" = "Hello World" ]
