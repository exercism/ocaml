#!/bin/bash
set -e

eval $(opam env)

cd /repo/tools/test-generator
dune runtest 

git clone https://github.com/exercism/problem-specifications.git /problem-specifications
cd /problem-specifications
git checkout 2af3c9b0074f16c62366c5c533eaacd3ff27b583 

cd /repo/tools/test-generator/bin_test_gen
dune exec ./test_gen.exe --profile=release

cd /repo
ocp-indent -i exercises/**/test.ml

if output=$(git status --porcelain -- "exercises/**/test.ml") && [ -z "$output" ]; then
 echo "Tests are in sync."
else
 echo "Checked in test files diverged from generated files:"
 echo $output
 exit 1
fi

make test
