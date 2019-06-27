#!/bin/bash
set -e

eval $(opam env)

sudo git clone https://github.com/exercism/problem-specifications.git /problem-specifications
cd /problem-specifications
sudo git checkout 2af3c9b0074f16c62366c5c533eaacd3ff27b583 
cd /repo/tools/test-generator
sudo dune exec ./test_gen.exe --profile=release
cd /repo
sudo ocp-indent -i exercises/**/test.ml

if output=$(git status --porcelain -- "exercises/**/test.ml") && [ -z "$output" ]; then
 echo "Tests are in sync."
else
 echo "Checked in test files diverged from generated files:"
 echo $output
 exit 1
fi

make test
